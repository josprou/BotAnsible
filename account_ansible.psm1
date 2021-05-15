#########################################
## Confiuraci�n del Bot
#########################################
function New-MyTelegramConfiguration{
    $RegKey = "HKCU:\Software\MyTelegram"
    New-Item -Path $RegKey -Force | Out-Null
    New-ItemProperty $RegKey -Name 'BotKey' -Value "1572077157:AAHg8ChqgDgiJl092Ydz0q6AgNFSJQoHQik" -Force | Out-Null
    New-ItemProperty $RegKey -Name 'ChatID' -Value "685749607" -Force | Out-Null
    New-ItemProperty $RegKey -Name 'LastUpdateID' -Value 0 -Force | Out-Null
}

# Obtiene los �ltimos Telegrams
function Get-TelegramTimeLine{
    param([int]$MaxinumMessages)

    $RegKey = "HKCU:\Software\MyTelegram"
    $botkey = (Get-ItemProperty -Path $RegKey).BotKey
    $lastUpdate = (Get-ItemProperty -Path $RegKey).LastUpdateID
    $telegrams = (Invoke-WebRequest -Uri "https://api.telegram.org/bot$BotKey/getUpdates?offset=$lastUpdate").content
    $telegrams = ConvertFrom-Json $telegrams 
    [PSObject[]]$msgs = $null;$count=0

    for($i=$telegrams.result.count-1;$i -ne 0;$i--){
        $msgs += $telegrams.result[$i]
        $count++
        if($count -eq $MaxinumMessages){
            break
        }
    }
    return $msgs
}

# Envia texto al chat
function Send-Results{
     param([string]$chat_id,
           [string]$texto)

     $RegKey = "HKCU:\Software\MyTelegram"
     $BotKey = (Get-ItemProperty -Path $RegKey).botkey
     Invoke-Webrequest -uri "https://api.telegram.org/bot$BotKey/sendMessage?chat_id=$chat_id&text=$texto" -Method post | Out-Null
}

# Envia imagen al chat
function Send-Photo{
    param([String]$file_path)

    $RegKey = "HKCU:\Software\MyTelegram"
    $BotKey = (Get-ItemProperty -Path $RegKey).Botkey
    $chat_id = (Get-ItemProperty -Path $RegKey).ChatID

    $file_object = Get-Item $file_path -ErrorAction Stop
    
    $uri = "https://api.telegram.org/bot$BotKey/sendPhoto"
    $Form = @{
        chat_id              = $chat_id
        photo                = $file_object
        caption              = $Caption
        parse_mode           = $ParseMode
        disable_notification = $DisableNotification
    }    
    $invokeRestMethodSplat = @{
        Uri = $Uri
        ErrorAction = 'Stop'
        Form = $Form
        Method = 'Post'
    }    
    $results = Invoke-RestMethod @invokeRestMethodSplat
}

# Envia documento al chat (m�ximo 50 MB)
function Send-Document{
    param([String]$file_path)

    $RegKey = "HKCU:\Software\MyTelegram"
    $BotKey = (Get-ItemProperty -Path $RegKey).Botkey
    $chat_id = (Get-ItemProperty -Path $RegKey).ChatID

    $file_object = Get-Item $file_path -ErrorAction Stop
    
    $Uri = "https://api.telegram.org/bot$BotKey/sendDocument"
    $Form = @{
        chat_id              = $chat_id
        document             = $file_object
        caption              = $Caption
        parse_mode           = $ParseMode
        disable_notification = $DisableNotification
    }    
    $invokeRestMethodSplat = @{
        Uri = $Uri
        ErrorAction = 'Stop'
        Form = $Form
        Method = 'Post'
    }    
    $results = Invoke-RestMethod @invokeRestMethodSplat
}

# Obtiene el �ltimo Telegram leido
function Get-LastUpdateID{
    $RegKey = "HKCU:\Software\MyTelegram"
    return (Get-ItemProperty -Path $RegKey).LastUpdateID
}

# Modifica el �ltimo Telegram le�do
function Update-Time{
    param([string]$LastUpdateID)
    $LastUpdateID
    $RegKey = "HKCU:\Software\MyTelegram"
    New-ItemProperty $RegKey -Name 'LastUpdateID' -Value $LastUpdateID -Force | Out-Null
}


