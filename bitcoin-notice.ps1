<#
.SYNOPSIS
    This script monitors the current price of Bitcoin and provides an audible alert for significant changes.

.DESCRIPTION
    This script uses the coindesk API to get the current price of Bitcoin every 10 minutes. 
    If the price difference is more than 25 USD, it plays a sound file. 
    The script then uses System.Speech.Synthesis to provide an audible update of the current price.
#>

# Import required assemblies
Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName PresentationCore

# Initialize variables
$Voice = New-Object System.Speech.Synthesis.SpeechSynthesizer
$Napalm = "https://millersecurityresearch.com/files/scripts/sounds/Napalm%20Death%20-%20You%20Suffer.mp3"
$Path = Join-Path $Env:Temp "Napalm Death - You Suffer.mp3"
$WebClient = New-Object System.Net.WebClient
$MediaPlayer = New-Object System.Windows.Media.MediaPlayer

# Download the sound file
$WebClient.DownloadFile($Napalm, $Path)
$MediaPlayer.Open($Path)

# Get the initial Bitcoin price
$Response = Invoke-WebRequest -URI "https://api.coindesk.com/v1/bpi/currentprice.json" | ConvertFrom-Json
$StartingRate = $Response.Bpi.USD.Rate
Write-Host "Starting BTC: $StartingRate"

# Continuously monitor the Bitcoin price
While ($true) {
    Start-Sleep -Seconds 600

    # Get the current Bitcoin price
    $Response = Invoke-WebRequest -URI "https://api.coindesk.com/v1/bpi/currentprice.json" | ConvertFrom-Json
    $CurrentRate = $Response.Bpi.USD.Rate

    # Check for changes and provide updates
    If ($StartingRate -gt $CurrentRate) {
        $Difference = $StartingRate - $CurrentRate
        If ($Difference -gt 25) {
            $MediaPlayer.Play()
            Start-Sleep -Seconds 2
        }
        $VoiceOutput = "Bitcoin Down by " + $Difference + " Dollars to " + $CurrentRate -replace ".{5}$"
        $Voice.Speak($VoiceOutput)
        Write-Host "Current BTC: $CurrentRate - Down"
    } ElseIf ($StartingRate -lt $CurrentRate) {
        $Difference = $CurrentRate - $StartingRate
        $VoiceOutput = "Bitcoin Up by " + $Difference + " Dollars to " + $CurrentRate -replace ".{5}$"
        $Voice.Speak($VoiceOutput)
        Write-Host "Current BTC: $CurrentRate - Up"
    } Else {
        $VoiceRate = $CurrentRate -replace ".{5}$"
        $VoiceOutput = "Bitcoin same at " + $VoiceRate + " Dollars"
        $Voice.Speak($VoiceOutput)
        Write-Host "Current BTC: $CurrentRate"
    }

    $StartingRate = $CurrentRate
}
