Function Encrypt-String {
    <#
    .SYNOPSIS
        This function encrypts a plaintext string using a provided key.

    .DESCRIPTION
        Encrypt-String takes a key and a plaintext string as parameters, encrypts the string using the key, and returns the encrypted data.

    .PARAMETER Key
        Encryption key, should be between 16 and 32 characters.

    .PARAMETER Plaintext
        The string to be encrypted.

    .EXAMPLE
        PS> Encrypt-String -Key 'mySecureKey' -Plaintext 'Hello, World!'
        
    #>
    Param (
        [string]$Key,
        [string]$Plaintext
    )

    $KeyLength = $Key.Length
    $Padding = 32 - $KeyLength

    # Key length validation
    If (($KeyLength -lt 16) -or ($KeyLength -gt 32)) {
        Throw "Key must be between 16 and 32 characters"
    }

    $Encoding = New-Object System.Text.ASCIIEncoding
    $Key = $Encoding.GetBytes($Key + "0" * $Padding)

    $SecureString = New-Object System.Security.SecureString
    $Characters = $Plaintext.ToCharArray()

    # Appending characters to the secure string
    Foreach ($Character in $Characters) {
        $SecureString.AppendChar($Character)
    }

    $EncryptedData = ConvertFrom-SecureString -SecureString $SecureString -Key $Key

    Return $EncryptedData
}

Function Decrypt-String {
    <#
    .SYNOPSIS
        This function decrypts an encrypted string using a provided key.

    .DESCRIPTION
        Decrypt-String takes a key and encrypted data as parameters, decrypts the data using the key, and returns the plaintext string.

    .PARAMETER Key
        Decryption key, should be between 16 and 32 characters.

    .PARAMETER EncryptedData
        The data to be decrypted.

    .EXAMPLE
        PS> Decrypt-String -Key 'mySecureKey' -EncryptedData $encryptedData

    #>
    Param (
        [string]$Key,
        [string]$EncryptedData
    )

    $KeyLength = $Key.Length
    $Padding = 32 - $KeyLength

    # Key length validation
    If (($KeyLength -lt 16) -or ($KeyLength -gt 32)) {
        Throw "Key must be between 16 and 32 characters"
    }

    $Encoding = New-Object System.Text.ASCIIEncoding
    $Key = $Encoding.GetBytes($Key + "0" * $Padding)

    $DecryptedData = $EncryptedData | ConvertTo-SecureString -Key $Key |
    ForEach-Object {
        [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)
        )
    }

    Return $DecryptedData
}
