Function Get-Wifi-Network {
    <#
    .SYNOPSIS
        Retrieves information about all available WiFi networks.

    .DESCRIPTION
        Uses 'netsh' command to get detailed information about each available WiFi network, 
        including SSID, Network Type, Authentication, and Encryption.

    .EXAMPLE
        Get-Wifi-Network
        
    #>
    End {
        Netsh Wlan Sh Net Mode=Bssid | ForEach-Object -Process {
            If ($_ -match '^SSID (\d+) : (.*)$') {
                $Current = @{}
                $Networks += $Current
                $Current.Index = $Matches[1].Trim()
                $Current.SSID = $Matches[2].Trim()
            }
            Else {
                If ($_ -match '^\s+(.*)\s+:\s+(.*)\s*$') {
                    $Current[$Matches[1].Trim()] = $Matches[2].Trim()
                }
            }
        } -Begin { 
            $Networks = @() 
        } -End { 
            $Networks | ForEach-Object { New-Object PSObject -Property $_ } 
        }
    }
}
