# Initialize the HttpListener
$httpListener = New-Object System.Net.HttpListener

# Bind to localhost
$httpListener.Prefixes.Add("http://locahost:8080/")
$httpListener.Start()

Write-Host "Listening on http://locahost:8080/"

while ($true) {
    $context = $httpListener.GetContext()
    $context.Response.StatusCode = 200
    $context.Response.ContentType = 'text/plain'
    $responseText = "Hello, World!"
    $encodedResponse = [Text.Encoding]::UTF8.GetBytes($responseText)
    $context.Response.OutputStream.Write($encodedResponse, 0, $encodedResponse.Length)
    $context.Response.Close()
}