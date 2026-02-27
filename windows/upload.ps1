param(
    [Parameter(Mandatory = $true)]
    [string]$DistributorId,

    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [Parameter(Mandatory = $false)]
    [ValidateSet("full", "inc")]
    [string]$Mode = "full",

    [Parameter(Mandatory = $false)]
    [string]$ApiUserLogin = $env:API_USERNAME,

    [Parameter(Mandatory = $false)]
    [string]$ApiUserPsw = $env:API_USERPSW,

    [Parameter(Mandatory = $false)]
    [string]$ApiHost = $env:API_HOST
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ApiUserLogin) -or
    [string]::IsNullOrWhiteSpace($ApiUserPsw) -or
    [string]::IsNullOrWhiteSpace($ApiHost)) {
    Write-Error "API credentials are required. Set API_USERNAME/API_USERPSW/API_HOST or pass -ApiUserLogin/-ApiUserPsw/-ApiHost."
    exit 2
}

if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
    Write-Error "Price file not found: $FilePath"
    exit 2
}

$baseUrl = $ApiHost.Trim().TrimEnd("/")
if ($baseUrl -notmatch "^https?://") {
    $baseUrl = "https://$baseUrl"
}
$url = "$baseUrl/cp/distributor/pricelistUpdate"
$fileTypeId = if ($Mode -eq "inc") { "4" } else { "1" }

Write-Host "Start uploading $Mode file..."

$handler = New-Object System.Net.Http.HttpClientHandler
$client = New-Object System.Net.Http.HttpClient($handler)
$client.Timeout = [TimeSpan]::FromSeconds(60)

try {
    $multipart = New-Object System.Net.Http.MultipartFormDataContent

    $multipart.Add((New-Object System.Net.Http.StringContent($ApiUserLogin)), "userlogin")
    $multipart.Add((New-Object System.Net.Http.StringContent($ApiUserPsw)), "userpsw")
    $multipart.Add((New-Object System.Net.Http.StringContent($DistributorId)), "distributorId")
    $multipart.Add((New-Object System.Net.Http.StringContent($fileTypeId)), "fileTypeId")

    $fileName = [System.IO.Path]::GetFileName($FilePath)
    $fileStream = [System.IO.File]::OpenRead($FilePath)
    $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
    $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
    $multipart.Add($fileContent, "uploadFile", $fileName)

    $response = $client.PostAsync($url, $multipart).GetAwaiter().GetResult()
    $body = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()

    if (-not $response.IsSuccessStatusCode) {
        Write-Error "HTTP $([int]$response.StatusCode): $body"
        exit 1
    }

    try {
        $json = $body | ConvertFrom-Json
    } catch {
        Write-Error "Non-JSON response: $body"
        exit 1
    }

    if ($null -ne $json.errorMessage -and "$($json.errorMessage)".Trim().Length -gt 0) {
        Write-Error "$($json.errorMessage)"
        exit 1
    }

    if ($null -ne $json.message -and "$($json.message)".Trim().Length -gt 0) {
        Write-Host "$($json.message)"
    } else {
        Write-Host "Upload completed, but response message is empty."
    }
} finally {
    if ($null -ne $fileStream) { $fileStream.Dispose() }
    if ($null -ne $multipart) { $multipart.Dispose() }
    if ($null -ne $client) { $client.Dispose() }
}
