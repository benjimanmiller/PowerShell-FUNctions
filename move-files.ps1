function Move-Files {
    <#
        .SYNOPSIS
        Moves files from one directory to another.
    
        .DESCRIPTION
        This function moves files from one directory to another.
    
        .PARAMETER SourceDirectory
        The directory that contains the files to move.
    
        .PARAMETER DestinationDirectory
        The directory to move the files to.
    
        .PARAMETER Wildcard
        (Optional) A wildcard that specifies the files to move.
        
        .EXAMPLE
        Move-Files -SourceDirectory "D:\music" -DestinationDirectory "D:\mp3s" -Filter "*.mp3"
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)] 
        [string]$SourceDirectory,
    
        [Parameter(Mandatory = $true)] 
        [string]$DestinationDirectory,
    
        [Parameter(Mandatory = $false)] 
        [string]$Wildcard
    )
    
    # Get all files in the specified directory.
    $Files = Get-ChildItem -Path $SourceDirectory -Recurse -Filter $Wildcard
    
    # Move the files to the new directory.
    $Files | Move-Item -Destination $DestinationDirectory -Force
}
