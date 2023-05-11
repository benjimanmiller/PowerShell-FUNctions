Function Wardrive {
    $Allwifi = @()
    Try {
        while ($True) {
            $Currentwifi = Get-Wifi-Network
            Clear-Host
            Write-Host "Signal SSID"
            $Currentwifi | Sort-Object Signal | Select-Object Signal, SSID
            Foreach ($Wifi in $Currentwifi) {
                $Bssid = '*' + $Wifi.'BSSID 1' + '*'
                If (!($Allwifi -like $Bssid)) {
                    $Allwifi += $Wifi
                }                
            }
            Start-sleep -Seconds 1
        } 
    }
    Catch {
        Write-Host $_
    }
    Finally {
        $Allwifi = $Allwifi | Select-Object "SSID","BSSID 1","BSSID 2","Authentication","Encryption","Channel","Signal","Radio type","Network type" 
        $Date = Get-Date -Format hhmm-MMdd
        $Outpath = 'C:\Temp\' + $Date + '-wardrive.csv'
        $Allwifi | Convertto-Csv -NoTypeInformation | Out-File $Outpath -Force
    }
}
