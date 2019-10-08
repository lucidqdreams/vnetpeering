param
    (
        [Parameter(Mandatory=$true,Position=1)]
        [String] $TargetRRASIP,
        [Parameter(Mandatory=$true,Position=2)]
        [String] $TargetIPRange,
        [Parameter(Mandatory=$true,Position=3)]     
        [String] $SharedSecret
    )


$S2SName = ($TargetIPRange.Replace('.','')).Replace('/','')
Write-Output "Creating Tunnel called $S2SName"

$TargetIPRangeMetric = $TargetIPRange + ':100'

Write-Information "Tunnel EndPoint: $TargetRRASIP"
Write-Information "Subnet and Metric in Tunnel: $TargetIPRangeMetric"

Write-Information "Checking Routing Installation"
$RoutingInstallation = get-windowsfeature routing
if ($RoutingInstallation.Installed)
{
    Write-Information "Routing Already Installed"
}
else
{
    Write-Information 'Installing Routing'
    Install-WindowsFeature Routing -IncludeManagementTools -Confirm:$false 
    start-sleep 10
    Write-Information 'Set Automatic Start for RemoateAccess'
    Set-Service -Name "remoteaccess" -StartupType Automatic -Confirm:$false 
    Write-Information 'Start RemoateAccess Service '
    Start-Service -Name "remoteaccess" -Confirm:$false 
    start-sleep 10
}


$RRASInstalled = (Get-RemoteAccess).VpnS2SStatus
if ($RRASInstalled -ne 'Installed')
{
    write-Information 'Installing VpnS2S'
    Install-RemoteAccess -VpnType VpnS2S
    start-sleep 10

}
else
{
    write-Information 'VpnS2S Installed'
}

$existing = get-VpnS2SInterface | where {$_.name -eq $S2SName}
if ($existing.name -eq $S2SName)
{
    Write-Information "Existing Tunnel $S2SName Found, Deleting..."
    disconnect-VpnS2SInterface -Name $S2SName -Confirm:$false -Force 
    remove-VpnS2SInterface -Name $S2SName -Confirm:$false -Force
}

Write-Information "Configuring Tunnel $S2SName"
try 
{
    Add-VpnS2SInterface -Name $S2SName $TargetRRASIP -Protocol IKEv2 -AuthenticationMethod PSKOnly -SharedSecret $SharedSecret -IPv4Subnet $TargetIPRangeMetric -persistent -AutoConnectEnabled $true
    Set-VpnS2SInterface -Name $S2SName  -InitiateConfigPayload $false 
    start-sleep 5
    $result = get-VpnS2SInterface -name $S2SName
    Write-Information "Tunnel Created, Status: $($result.ConnectionState)"
}
catch{}
Finally{
    start-sleep 60
    $result = get-VpnS2SInterface -name $S2SName
}

write-Information "Tunnel Status: $($result.ConnectionState)"




