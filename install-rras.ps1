param
    (
        [Parameter(Mandatory=$true)]
        [String] $TargetRRASIP,
        [Parameter(Mandatory=$true)]
        [String] $TargetIPRange          
    )
        
Start-Transcript C:\PerfLogs\RRASinstall.log

$TargetIPRange = $TargetIPRange + ':100'
Install-WindowsFeature Routing -IncludeManagementTools
Install-RemoteAccess -VpnType VpnS2S

Start-Sleep 10
Add-VpnS2SInterface -Name "remote" $TargetRRASIP -Protocol IKEv2 -AuthenticationMethod PSKOnly -SharedSecret "ilovestack!" -IPv4Subnet $TargetIPRange 
Set-VpnS2SInterface remote -InitiateConfigPayload $false

Start-Sleep 10
get-VpnS2SInterface

$i=1
do {
    connect-VpnS2SInterface -name 'remote'
    start-sleep 5
    $i++
    Write-output $i
} while ($i -lt 10)

Stop-Transcript

