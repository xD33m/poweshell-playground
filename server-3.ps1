$listenerPort = "9090"
$filePath = "C:\Users\lucas\Downloads\ps-playground\data.json"

$ServerThreadCode = {
  $listenerPort = $args[0]
  $listener = New-Object System.Net.HttpListener
  $listenerString = "http://localhost:$listenerPort/"
  $listener.Prefixes.Add($listenerString)
 
  $listener.Start()
  
  while ($listener.IsListening) {
 
    $context = $listener.GetContext() # blocks until request is received
    # $request = $context.Request
    $response = $context.Response
    $response.StatusCode = 200
    $response.ContentType = 'application/json'
    $webContent = Get-Content -Path $filePath -Raw -Encoding UTF8

    $buffer = [Text.Encoding]::UTF8.GetBytes($webContent)
    # $response.ContentLength64 = $buffer.length
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.length)
    $output.Close()
  }
 
  $listener.Stop()
}
  
$serverJob = Start-Job $ServerThreadCode -ArgumentList $listenerPort
Write-Host "Listening on $listenerPort ..."
Write-Host "Press Ctrl+X to terminate" 
 
# [console]::TreatControlCAsInput = $true

# Wait for it all to complete
while ($serverJob.State -eq "Running")
{
  if ([console]::KeyAvailable) {
    # $key = [system.console]::readkey($true)
    Write-Host "Terminating. Please Wait.."
    try { $result = Invoke-WebRequest -Uri "http://localhost:9090" } catch { Write-Host "Listener ended" }
    $serverJob | Stop-Job 
    Remove-Job $serverJob
    break
  }

  Start-Sleep -s 1
}
 
# Getting the information back from the jobs
Get-Job | Receive-Job