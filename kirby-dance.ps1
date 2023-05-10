<#
.SYNOPSIS
    This script displays a dancing ASCII figure in the console.

.DESCRIPTION
    The script creates an ASCII animation by looping over pre-defined frames. 
    It controls the speed of the animation and the number of times the animation is looped.

.EXAMPLE
    PS> .\DancingAscii.ps1
#>

# Define the ASCII animation frames
$Animation = @"
(>'-')>
#
^('-')^
#
<('-'<)
#
^('-')^
"@

$Frames = $Animation.Split("#").Trim()

$AnimationLoopNumber = 50  # Number of times to loop animation
$AnimationSpeed = 250  # Time in milliseconds to show each frame
$Counter = 0

# Start the animation loop
Do {
    ForEach ($Frame in $Frames) {
        Write-Host "`r$Frame" -NoNewline            
        Start-Sleep -Milliseconds $AnimationSpeed
    }
    $Counter++    
} Until ($Counter -eq $AnimationLoopNumber)
