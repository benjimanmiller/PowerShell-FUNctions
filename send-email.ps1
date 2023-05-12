function Send-Email {
    <#
        .SYNOPSIS
        Sends an email message.
    
        .DESCRIPTION
        This function sends an email message using the built-in Send-MailMessage cmdlet.
    
        .PARAMETER To
        The email address of the recipient.
    
        .PARAMETER Subject
        The subject of the email message.
    
        .PARAMETER Body
        The body of the email message.
    
        .PARAMETER Attachment
        (Optional) The path to the file to attach to the email message.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)] 
        [string]$To,
    
        [Parameter(Mandatory = $true)] 
        [string]$Subject,
    
        [Parameter(Mandatory = $true)] 
        [string]$Body,
    
        [Parameter(Mandatory = $false)] 
        [string]$Attachment
    )
    
    # Set the SMTP server and sender.
    $SmtpServer = "mail-out.serveraddress.com"
    $SmtpFrom = "sender@serveraddress.com"
    
    # Set the recipient, subject, and body of the message.
    $SmtpTo = $To
    $MessageSubject = $Subject
    $MessageBody = $Body
    
    # If an attachment is specified, set the attachment path.
    If ($Attachment) {
        $MessageAttachment = $Attachment
    }
    
    # Send the email message.
    Send-MailMessage -From $SmtpFrom -To $SmtpTo -Subject $MessageSubject -Body $MessageBody -Attachments $MessageAttachment -SmtpServer $SmtpServer
}
