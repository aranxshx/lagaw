$settings = @{}
foreach ($line in [IO.File]::ReadAllLines("$PSScriptRoot/../.env")) {
    if ($line -match '^\s*(?:export\s+)?(DEEPSEEK_[A-Z_]+)\s*=\s*(.*)$') {
        $name = $Matches[1]
        $value = $Matches[2].Trim()
        if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
            $value = $value.Substring(1, $value.Length - 2)
        } else { $value = ($value -replace '\s+#.*$', '').Trim() }
        $settings[$name] = $value
    }
}
if (-not $settings['DEEPSEEK_API_KEY']) { Write-Output 'RESULT: missing_api_key'; exit 1 }
$model = $settings['DEEPSEEK_MODEL']
if (-not $model) { $model = 'deepseek-flash' }
$body = @{
    model = $model
    messages = @(
        @{role='system'; content='Extract preferences only. Return JSON with budget_level (low, medium, high, unspecified), tags (array of cafe, photography, relaxing, heritage, food, nature), duration (morning, afternoon, evening, full_day, unspecified), pace (slow, moderate, fast, unspecified). Missing fields use unspecified or []. Do not recommend destinations.'},
        @{role='user'; content='I want a cheap and relaxing afternoon with coffee and photography spots.'}
    )
    response_format = @{type='json_object'}
    thinking = @{type='disabled'}
    max_tokens = 512
    stream = $false
} | ConvertTo-Json -Depth 8
$evidence = @{tested_at_utc=[DateTime]::UtcNow.ToString('o'); test='deepseek_api_connectivity_powershell'; live_call=$true; model=$model}
try {
    $response = Invoke-RestMethod -Method Post -Uri 'https://api.deepseek.com/chat/completions' -Headers @{Authorization="Bearer $($settings['DEEPSEEK_API_KEY'])"} -ContentType 'application/json' -Body $body -TimeoutSec 30
    $choice = $response.choices[0]
    if ($choice.finish_reason -ne 'stop') { throw 'invalid_output' }
    $result = $choice.message.content | ConvertFrom-Json
    $names = @($result.PSObject.Properties.Name | Sort-Object)
    if (($names -join ',') -ne 'budget_level,duration,pace,tags') { throw 'invalid_output' }
    if ($result.budget_level -notin @('low','medium','high','unspecified') -or $result.duration -notin @('morning','afternoon','evening','full_day','unspecified') -or $result.pace -notin @('slow','moderate','fast','unspecified') -or $result.tags -isnot [array]) { throw 'invalid_output' }
    foreach ($tag in $result.tags) { if ($tag -notin @('cafe','photography','relaxing','heritage','food','nature')) { throw 'invalid_output' } }
    $evidence.status = 'passed'
    $evidence.validated_response = @{budget_level=$result.budget_level; tags=@($result.tags); duration=$result.duration; pace=$result.pace}
    $code = 0
} catch {
    $evidence.status = 'failed'
    if ($null -ne $_.Exception.Response) { $evidence.error_code = "provider_http_$([int]$_.Exception.Response.StatusCode)" }
    elseif ($_.Exception.Message -eq 'invalid_output') { $evidence.error_code = 'invalid_provider_output' }
    else { $evidence.error_code = 'transport_or_output_failure' }
    $code = 1
}
$target = "$PSScriptRoot/../docs/evidence/deepseek-smoke.json"
New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
$evidence | ConvertTo-Json -Depth 6 | Set-Content $target
$evidence | ConvertTo-Json -Depth 6
exit $code
