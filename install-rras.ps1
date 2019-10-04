param
    (
        [Parameter(Mandatory=$true)]
        [String] $TargetRRASIP,
        [Parameter(Mandatory=$true)]
        [String] $TargetIPRange          
    )

Start-Transcript C:\RRASinstall.log
Start-Sleep 15

$TargetIPRangeMetric = $TargetIPRange + ':100'
Install-WindowsFeature Routing 
Install-RemoteAccess -VpnType VpnS2S

Start-Sleep 10
Add-VpnS2SInterface -Name "remote" $TargetRRASIP -Protocol IKEv2 -AuthenticationMethod PSKOnly -SharedSecret "ilovestack!" -IPv4Subnet $TargetIPRangeMetric -persistent
Set-VpnS2SInterface -Name "remote" -InitiateConfigPayload $false 



$i=1
do {
    get-VpnS2SInterface | Format-Table
    start-sleep 6
    $i++
    Write-output $i
} while ($i -lt 10)

Stop-Transcript

