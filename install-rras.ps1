param
    (
        [Parameter(Mandatory=$true)]
        [String] $TargetRRASIP,
        [Parameter(Mandatory=$true)]
        [String] $TargetIPRange,
        [Parameter(Mandatory=$true)]
        [securestring] $SharedSecret
    )
    Start-Transcript C:\PerfLogs\RRASinstall.log

$TargetIPRange = $TargetIPRange + ':100'
Install-WindowsFeature Routing -IncludeManagementTools
Install-RemoteAccess -VpnType VpnS2S

Start-Sleep 10
Add-VpnS2SInterface -Name "remote" $TargetRRASIP -Protocol IKEv2 -AuthenticationMethod PSKOnly -SharedSecret "ilovestack!" -IPv4Subnet $TargetIPRange 
Set-VpnS2SInterface remote -InitiateConfigPayload $false

Stop-Transcript

