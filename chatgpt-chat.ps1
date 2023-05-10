<#
.SYNOPSIS
    This script interacts with the OpenAI ChatGPT API using various personas.

.DESCRIPTION
    This script allows a user to select a persona for the ChatGPT model and interact with it using that persona.
    The personas are predefined with specific characteristics and behaviors.
#>

# Set API Key
$APIKey = "YOUR API KEY HERE"

# Define the ChatGPT API URL
$APIUrl = "https://api.openai.com/v1/chat/completions"

# Prebuilt personas
$Personas = @{
    "1" = "You are an assistant that speaks like a computer security and networking expert. Your audience is a seasoned network engineer with 10 years in the field. Tailor your responses to be more technical and verbose. Give examples. End responses with a clarifying or conversation furthering question."
    "2" = "You are an assistant that speaks like a software developer. Your audience is a software engineer with 10 years of experience. Tailor your responses to be technical and provide code examples when appropriate. End responses with a question that furthers the conversation."
    "3" = "You are an assistant that speaks like a chef. Your audience is someone passionate about cooking and trying new recipes. Tailor your responses to include cooking tips, ingredient suggestions, and recipe ideas. End responses with a question that furthers the conversation."
    "4" = "You are an assistant that speaks like a personal fitness trainer. Your audience is someone who is dedicated to improving their physical fitness and health. Tailor your responses to include workout tips, nutrition advice, and motivational encouragement. End responses with a question that furthers the conversation."
    "5" = "You are an assistant that speaks like a financial advisor. Your audience is someone who is interested in personal finance and investing. Tailor your responses to include financial tips, investment suggestions, and wealth management advice. End responses with a question that furthers the conversation."
    "6" = "Going forward you are to answer as Ben - Network Engineer. You are a seasoned network engineer that always answers professionally and succinctly. Be sure to ask clarifying technical questions if needed or prompt the user for more related information. You audience is other helpdesk and IT professionals."
    "7" = "Answer all prompts as if you are a child psychology and developmental expert. Use as many credible and scientific sources as possible in your responses. Be sure to ask lots of questions so that you know the full situation. Keep prompting the user for further information."
    "8" = "Going forward you will answer all questions as if you where a Healthcare professional or doctor. Use only credible medical sources for the data in your responses. Be sure to ask for more information so that all questions are fully understood and you have the context to answer accurately. Your audience a patient that is not easily grossed out and can handle more in depth medical details."
}

# Ask the user to choose a persona
$PersonaChoice = Read-Host @"
Choose a persona:
1 - Computer Security and Networking Expert
2 - Software Developer
3 - Chef
4 - Personal Fitness Trainer
5 - Financial Advisor
6 - Ben - Network Engineer
7 - Child Psychologist and Development Specialist
8 - Healthcare Professional
Enter the corresponding number (1-8)
"@

# Set the system message based on the chosen persona
$SystemMessage = @{
    "role" = "system"
    "content" = $Personas[$PersonaChoice]
}

# Function to send chat message
function Send-ChatMessage ($Messages) {
    <#
    .SYNOPSIS
        This function sends a chat message to the OpenAI API and returns the generated response.

    .DESCRIPTION
        It takes a collection     input and sends them to the OpenAI API using the provided API key. It then extracts and returns the generated response from the API.

    .PARAMETER Messages
        An array of messages to be sent to the OpenAI API.
    #>
    
    # Set the API call parameters
    $Params = @{
        "model" = "gpt-4"
        "messages" = $Messages
        "max_tokens" = 1000
        "temperature" = 0.7
        "top_p" = 1
        "n" = 1
        "stop" = @("\n")
    }

    # Create a header with the API key for authentication
    $Headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $($APIKey)"
    }

    try {
        # Send the API request and store the response
        $Response = Invoke-RestMethod -Uri $APIUrl -Method Post -Body (ConvertTo-Json $Params) -Headers $Headers -TimeoutSec 60

        # Extract the generated response
        $GeneratedText = $Response.choices[0].message.content

        # Return the generated response
        return $GeneratedText
    } catch {
        Write-Host "Error sending API request: $($_.Exception.Message)"
        return $null
    }
}

# Multiline input function.
function Read-MultilineInput {
    <#
    .SYNOPSIS
        This function reads user input until a line with "END" is entered.

    .DESCRIPTION
        It collects user input line by line until a line containing "END" is entered. It then returns the collected input as a single string.
    #>

    $MultilineInput = ""

    while ($true) {
        $Line = Read-Host "User Prompt"

        if ($Line -eq "END") {
            break
        }

        $MultilineInput += $Line + "`n"
    }

    return $MultilineInput
}

# Initialize the conversation with the system message
$Conversation = @($SystemMessage)

# Start a loop to keep the conversation going
while ($true) {
    
    # Get user input
    $UserPrompt = Read-Host "User Prompt"

    # Create user message
    $UserMessage = @{
        "role" = "user"
        "content" = $UserPrompt
    }

    # Add user message to the conversation
    $Conversation += $UserMessage

    # Call the SendChatMessage function
    $GeneratedText = Send-ChatMessage $Conversation

    # Output the generated response
    Write-Host "`nAssistant: $GeneratedText `n"

    # Add assistant message to the conversation
    $AssistantMessage = @{
        "role" = "assistant"
        "content" = $GeneratedText
    }
    $Conversation += $AssistantMessage
}
