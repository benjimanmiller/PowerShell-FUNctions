function Get-Web-Directory {

    <#
    .Synopsis
        Downloads all files from an open directory

    .DESCRIPTION
        Downloads all files from an open directory

    .PARAMETER Url
        The Url to download from

    .PARAMETER Destination
        The destination path to store the files

    .PARAMETER SearchTerm
	
        Used to filter results to only inlcude those with the searchterm in the filename. 
        Can include the * wildcard character. 

    .PARAMETER ExcludeTerm
        Used to filter results to exclude those with the excludeterm in the filename. 
        Can include the * wildcard character.

    .PARAMETER Recursive
        Download from all child folders
    
    .PARAMETER Preview
        Writes out to the console all actions that would be taken. 

    .PARAMETER RecursivePath
        Not needed by the user, Updates the destination path in when using recursion

    .EXAMPLE
        Get-Web-Directory -Url "filesandsuch.com/files/" -Destination 'C:\Temp\' -Recursive -SearchTerm 'bears' -Verbose

    .EXAMPLE
        Get-Web-Directory -Url "filesandsuch.com/files/" -Destination 'C:\Temp\' -Recursive -SearchTerm 'bears'

    .EXAMPLE
        Get-Web-Directory -Url "filesandsuch.com/files/" -Destination 'C:\Temp\' -Recursive

    .EXAMPLE
        Get-Web-Directory -Url "filesandsuch.com/files/" -Destination 'C:\Temp\' 

#>

    Param (
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $true)]
        [string]$Destination,

        [string]$SearchTerm,

        [string]$ExcludeTerm,

        [switch]$Recursive,

        [switch]$Preview,

        [string]$RecursivePath
    )

    #This is to take any ssl cert (secure af)
    Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    Add-Type -AssemblyName System.Web
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    [Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls11, Tls, Ssl3"

    #Gets list of gets list of files from server and parses results to download
    $Output = "Checking out " + $Url
    $Output = [System.Web.HttpUtility]::UrlDecode($Output)
    Write-Verbose $Output
    Try {
        $Dir = Invoke-WebRequest –Uri $Url
    }
    Catch {
        Write-Verbose " $_"
        Return
    }
    If ([string]::IsNullOrEmpty($SearchTerm) -eq $false) {  
        If ([string]::IsNullOrEmpty($ExcludeTerm) -eq $false) {  
            $SearchTerm = "*$SearchTerm*"
            $ExcludeTerm = "*$ExcludeTerm*"
            $Results = $Dir.Links | Where-Object {$_ -notlike '*Parent Directory*' -and $_.href -notlike '*../*' -and $_.href -notlike '*://*' -and $_.href -notlike '/' -and $_.href -notlike '*/' -and $_.href -notlike '?C=*' -and $_.href -like $SearchTerm -and $_.href -notlike $ExcludeTerm}
        }
        Else {
            $SearchTerm = "*$SearchTerm*"
            $Results = $Dir.Links | Where-Object {$_ -notlike '*Parent Directory*' -and $_.href -notlike '*../*' -and $_.href -notlike '*://*' -and $_.href -notlike '/' -and $_.href -notlike '*/' -and $_.href -notlike '?C=*' -and $_.href -like $SearchTerm}
        }
    }
    Else {
        If ([string]::IsNullOrEmpty($ExcludeTerm) -eq $false) { 
            $ExcludeTerm = "*$ExcludeTerm*"
            $Results = $Dir.Links | Where-Object {$_ -notlike '*Parent Directory*' -and $_.href -notlike '*../*' -and $_.href -notlike '*://*' -and $_.href -notlike '/' -and $_.href -notlike '*/' -and $_.href -notlike '?C=*' -and $_.href -notlike $ExcludeTerm}
        }
        Else {
            $Results = $Dir.Links | Where-Object {$_ -notlike '*Parent Directory*' -and $_.href -notlike '*../*' -and $_.href -notlike '*://*' -and $_.href -notlike '/' -and $_.href -notlike '*/' -and $_.href -notlike '?C=*'}   
        }
    }

    $Lastdir = $null
    #Downloads all matching found files
    ForEach ($Result In $Results) {
        If ($Preview.IsPresent) { 
            If (-not (Test-Path $Destination)) {
                If (([string]::IsNullOrEmpty($Lastdir) -eq $true) -or ($Lastdir -notlike $Destination)) {
                    $Output = $Destination + " would be created."
                    $Output = $Output -replace '/', ''
                    Write-Host $Output
                    $Lastdir = $Destination
                }                
            }
            $Output = $Result.href.ToString() + " would be downloaded."
            $Output = [System.Web.HttpUtility]::UrlDecode($Output)   
            Write-Host $Output                
        }
        Else {
            $Downloadpath = $Url + $Result.href.ToString()
            $Destinationpath = $Destination + $Result.href.ToString()
            $Destinationpath = [System.Web.HttpUtility]::UrlDecode($Destinationpath)
            If (-not (Test-Path $Destination)) {
                New-Item $Destination -type directory -Force
            }
            $Output = "Dowloading " + $Result.href.ToString()
            $Output = [System.Web.HttpUtility]::UrlDecode($Output)
            Write-Verbose $Output
            Try {
                (New-Object System.Net.WebClient).DownloadFile($Downloadpath, $Destinationpath)
            }
            Catch {
                Write-Verbose " $_"
            }
        }
    }

    #Recurses through the folders if needed
    If ($Recursive.IsPresent) {
        $Results = $Dir.Links | Where-Object {$_ -notlike '*Parent Directory*' -and $_.href -notlike '*../*' -and $_.href -notlike '*://*' -and $_.href -notlike '/' -and $_.href -like '*/'}

        ForEach ($Result In $Results) {
            If ($Preview.IsPresent) {
                $RecursivePath = $Destination + $Result.href.ToString() + "\"
                $RecursivePath = [System.Web.HttpUtility]::UrlDecode($Recursivepath)
                $Downloadpath = $Url + $Result.href.ToString()
                If ([string]::IsNullOrEmpty($SearchTerm) -eq $false) {
                    If ([string]::IsNullOrEmpty($ExcludeTerm) -eq $false) {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -SearchTerm $SearchTerm -Recursive -Preview -ExcludeTerm $ExcludeTerm
                    }
                    Else {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -SearchTerm $SearchTerm -Recursive -Preview
                    }
                }
                Else {
                    If ([string]::IsNullOrEmpty($ExcludeTerm) -eq $false) {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -Recursive -Preview -ExcludeTerm $ExcludeTerm
                    }
                    Else {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -Recursive -Preview
                    }
                }
            }
            Else {
                $RecursivePath = $Destination + $Result.href.ToString() + "\"
                $RecursivePath = [System.Web.HttpUtility]::UrlDecode($Recursivepath)
                $Downloadpath = $Url + $Result.href.ToString()
                If ([string]::IsNullOrEmpty($SearchTerm) -eq $false) {
                    If ([string]::IsNullOrEmpty($ExcludeTerm) -eq $false) {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -SearchTerm $SearchTerm -Recursive -ExcludeTerm $ExcludeTerm
                    }
                    Else {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -SearchTerm $SearchTerm -Recursive
                    }
                }
                Else {
                    If ([string]::IsNullOrEmpty($ExcludeTerm) -eq $false) {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -Recursive -ExcludeTerm $ExcludeTerm
                    }
                    Else {
                        Get-Web-Directory -Url $Downloadpath -Destination $RecursivePath -Recursive
                    }
                }
            }
        }
    }
}