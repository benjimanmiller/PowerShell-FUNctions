Function Get-Public-IP {
    <#
    .SYNOPSIS
        This function retrieves the public IPv4 and IPv6 addresses.

    .DESCRIPTION
        It sends requests to ip4.me and ip6.me services, respectively, to get the public IPv4 and IPv6 addresses. 
        The addresses are then stored in global variables, $IP4 and $IP6.
        
    #>

    # CmdletBinding for Write-Host to work
    [CmdletBinding()]
    Param()

    # Retrieve the public IPv4 address
    $URLofServer = "http://ip4.me/"
    $Request = Invoke-WebRequest -Uri $URLofServer -SessionVariable ses -UseBasicParsing

    # Parse the webpage using a regex that matches only IPv4 addresses and store it in $IP4.
    $Regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
    Try {
        $Global:IP4 = $Request | Select-String -Pattern $Regex -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
    } Catch {}
    
    # Display IPv4 address or no address message
    If ($IP4 -ne $null) {
        Write-Host "IPv4 address: $IP4"
    } Else {
        Write-Host "No Public IPv4 address"
    }

    # Retrieve the public IPv6 address
    $URLofServer = "http://IP6.me/"
    $Request = Invoke-WebRequest -Uri $URLofServer -SessionVariable ses -UseBasicParsing

    # Parse the webpage using a regex that matches only IPv6 addresses and store it in $IP6.
    $Regex = '([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{{0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])'
    Try {
        $Global:IP6 = $Request | Select-String -Pattern $Regex -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
    } Catch {}

    # Display IPv6 address or no address message
    If ($IP6 -ne $null) {
        Write-Host "IPv6 address: $IP6"
    } Else {
        Write-Host "No Public IPv6 address"
    }
}
