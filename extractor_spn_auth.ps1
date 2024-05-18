# Define variables
$clientId = #"<your_client_id>"
$clientSecret = #"<your_client_secret>"
$tenantId = #"<your_tenant_id>"
$resourceAppIdURI = "https://analysis.windows.net/powerbi/api"
$authority = "https://login.microsoftonline.com/$tenantId"
$tokenEndpointUri = "$authority/oauth2/token"
$apiEndpointUri = "https://api.powerbi.com/v1.0/myorg/admin/groups?`$expand=datasets&`$top=100"
$tabularEditorPath = "C:\Program Files (x86)\Tabular Editor\TabularEditor.exe"
$scriptPath = "C:\temp\TEscript\extract_partition.cs"

# Define function to acquire access token using client credentials flow
function Get-AccessToken {
    param (
        [string]$clientId,
        [string]$clientSecret,
        [string]$resourceAppIdURI,
        [string]$authority,
        [string]$tokenEndpointUri
    )
 
    $body = @{
        'grant_type'    = 'client_credentials'
        'client_id'     = $clientId
        'client_secret' = $clientSecret
        'resource'      = $resourceAppIdURI
    }
    $response = Invoke-RestMethod -Method Post -Uri $tokenEndpointUri -Body $body
    return $response.access_token
}

# Get access token
$accessToken = Get-AccessToken -clientId $clientId -clientSecret $clientSecret -resourceAppIdURI $resourceAppIdURI -authority $authority -tokenEndpointUri $tokenEndpointUri
# Call Power BI API to get all workspaces
$workspacesResponse = Invoke-RestMethod -Method Get -Uri $apiEndpointUri -Headers @{Authorization = "Bearer $accessToken" }

# Loop through each workspace
foreach ($workspace in $workspacesResponse.value) {
    $workspaceName = $workspace.name
    $workspaceNameEncoded = [URI]::EscapeUriString($workspaceName)

    if ($workspaceName -eq "MyWorkspace" -or $workspaceName -eq "MyWorkspace2") #this is done to filter on specific models
    {
        foreach ($dataset in $workspace.datasets) {
            Write-Output "Workspace: $workspaceName"
            
            $datasetName = $dataset.name
            Write-Output "Dataset: $datasetName"
                   
            # Formulate connection string
            $connectionString = "Provider=MSOLAP;Data Source=powerbi://api.powerbi.com/v1.0/myorg/$workspaceNameEncoded;User ID=app:$clientId@$tenantId;Password=$clientSecret;"
        
            Start-Process -FilePath $tabularEditorPath -Wait -NoNewWindow -PassThru -ArgumentList "`"$connectionString`" `"$datasetName`" -S $scriptPath"
        }
    }
}
