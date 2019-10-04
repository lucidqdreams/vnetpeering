param
    (
        [Parameter(Mandatory=$true)]
        [String] $TargetRRASIP,
        [Parameter(Mandatory=$true)]
        [String] $TargetIPRange          
    )

Start-Sleep 60

Start-Transcript C:\RRASinstall.log

$S2SName = ($TargetIPRange.Replace('.','')).Replace('/','')


$TargetIPRangeMetric = $TargetIPRange + ':100'

Add-VpnS2SInterface -Name $S2SName  $TargetRRASIP -Protocol IKEv2 -AuthenticationMethod PSKOnly -SharedSecret "ilovestack!" -IPv4Subnet $TargetIPRangeMetric -persistent
Set-VpnS2SInterface -Name $S2SName  -InitiateConfigPayload $false 


$i=1
do {
    get-VpnS2SInterface | Format-Table
    start-sleep 2
    $i++
    Write-output $i
} while ($i -lt 10)


$result = get-VpnS2SInterface -name $S2SName
Write-Output $result.ConnectionState

Stop-Transcript

