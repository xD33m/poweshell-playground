# Initialize the HttpListener
$httpListener = New-Object System.Net.HttpListener

# Add a prefix. The listener will handle requests to this URL
$httpListener.Prefixes.Add("http://localhost:8080/")

# Start the listener
$httpListener.Start()

write-host "Server started at http://localhost:8080/"
write-host "Press any key to stop the HTTP listener after next request"

while (!([console]::KeyAvailable)) {
    $context = $httpListener.GetContext()
    $context.Response.StatusCode = 200
    $context.Response.ContentType = 'application/json'
    $WebContent = Get-Content -Path "C:\Users\lucas\Downloads\data.json" -Raw -Encoding UTF8
    $EncodingWebContent = [Text.Encoding]::UTF8.GetBytes($WebContent)
    $context.Response.OutputStream.Write($EncodingWebContent , 0, $EncodingWebContent.Length)
    $context.Response.Close()
    Write-Output "" # Newline
}

$httpListener.Close()

write-host "Server stopped"
