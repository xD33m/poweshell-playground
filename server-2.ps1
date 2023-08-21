$port = 9090
$filePath = "E:\Github\ps-playground\data.json"

# Initialize the HttpListener
$httpListener = New-Object System.Net.HttpListener

$httpListener.Prefixes.Add("http://localhost:$port/")

# Start the listener
$httpListener.Start()

function HandleRequest {
    param($context)
    try {
        if (Test-Path $filePath) {
            $WebContent = Get-Content -Path $filePath -Raw -Encoding UTF8
            $context.Response.StatusCode = 200
            $context.Response.ContentType = 'application/json'
            $EncodingWebContent = [Text.Encoding]::UTF8.GetBytes($WebContent)
            $context.Response.OutputStream.Write($EncodingWebContent, 0, $EncodingWebContent.Length)
        } else {
            $context.Response.StatusCode = 404
            Write-Error "File not found"
        }
    } catch {
        Write-Error "Error handling request: $_"
        $context.Response.StatusCode = 500
    } finally {
        $context.Response.Close()
    }
}

try {
    Write-Output "Listening on port http://localhost:$port"
    while ($true) {
        $context = $httpListener.GetContext()
        HandleRequest -context $context
    }
} catch {
    Write-Error "Server error: $_"
} finally {
    $httpListener.Close()
    Write-Output "Server stopped"
}
