#Loads all my custom functions
."$PSScriptRoot\bitcoin-notice.ps1"
."$PSScriptRoot\chatgpt-chat.ps1"
."$PSScriptRoot\encrypt-decrypt-string.ps1"
."$PSScriptRoot\get-public-ip.ps1"
."$PSScriptRoot\get-web-directory.ps1"
."$PSScriptRoot\get-wifi-network.ps1"
."$PSScriptRoot\kirby-dance.ps1"
."$PSScriptRoot\roll-dice.ps1"
."$PSScriptRoot\SSH-Bruteforcer\BruteForce-SSH-Server.ps1"

#Loads some modules
Import-Module PoSH-SSH

#Window customizations - This section is for some simple window customizations. 
$host.UI.RawUi.WindowTitle = "Ben's Shell of Power"
$host.UI.RawUi.BackgroundColor = "Black"
$host.UI.RawUi.ForegroundColor = "Green"
Write-Host -ForegroundColor Red "
This terminal gives you ultimate power!
   _________________________________
  |:::::::::::::;;::::::::::::::::::|
  |:::::::::::'~||~~~'':::::::::::::|
  |::::::::'   .':     o':::::::::::|
  |:::::::' oo | |o  o    ::::::::::|
  |::::::: 8  .'.'    8 o  :::::::::|
  |::::::: 8  | |     8    :::::::::|
  |::::::: _._| |_,...8    :::::::::|
  |::::::'~--.   .--. '.   '::::::::|
  |:::::'     =8     ~  \ o ::::::::|
  |::::'       8._ 88.   \ o::::::::|
  |:::'   __. ,.ooo~~.    \ o'::::::|
  |:::   . -. 88'78o/:     \  ':::::|
  |::'     /. o o \ ::      \88'::::|
  |:;     o|| 8 8 |d.        '8 ':::|
  |:.       - ^ ^ -'           '-'::|
  |::.                          .:::|
  |:::::.....           ::'     ''::|
  |::::::::-''-        88          '|
  |:::::-'.          -       ::     |
  |:-~. . .                   :     |
  | .. .   ..:   o:8      88o       |
  |. .     :::   8:P     d888. . .  |
  |.   .   :88   88      888'  . .  |
  |   o8  d88P . 88   ' d88P   ..   |
  |  88P  888   d8P   ' 888         |
  |   8  d88P.'d:8  .- dP~ o8       |
  |      888   888    d~ o888       |
  |_________________________________|
  
Your eyes can deceive you. Don't trust them. Stretch out with your feelings!

"