Function Roll-Dice {
    <#
    .Synopsis
        Rolls a dice with any number of sides and says the results outloud. 

    .DESCRIPTION
        Rolls a dice with any number of sides and says the results outloud.

    .PARAMETER Sides
        Number of sides the dice will have when rolled

    .EXAMPLE
        Roll-Dice -Sides 20    

    #>

    Param (
        [Parameter(Mandatory = $true)]
        [int]$Sides
    )

    #Adds Voice Assembly and initalizes it
    Add-Type -AssemblyName System.Speech
    $Voice = New-Object System.Speech.Synthesis.SpeechSynthesizer

    #Rolls the dice and says the results
    $Roll = Get-Random -Minimum 1 -Maximum $Sides
    $SpeechOutput = "You rolled a " + $Roll
    $Voice.Speak($SpeechOutput)
    Return $Roll
}
