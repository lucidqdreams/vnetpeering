param
    (
        [Parameter(Mandatory=$true)]
        [String] $TargetRRASIP,
        [Parameter(Mandatory=$true)]
        [String] $TargetIPRange          
    )

    
ConvertTo-SecureString -AsPlainText -Force 
Start-Transcript C:\RRASinstall.log

$TargetIPRange = $TargetIPRange + ':100'
Install-WindowsFeature Routing -IncludeManagementTools
Install-RemoteAccess -VpnType VpnS2S

Start-Sleep 10
Add-VpnS2SInterface -Name "remote" $TargetRRASIP -Protocol IKEv2 -AuthenticationMethod PSKOnly -SharedSecret "" -IPv4Subnet $TargetIPRange 
Set-VpnS2SInterface -Name "remote" -InitiateConfigPayload $false 
Set-VpnS2SInterface -Name "remote" -persistent

Start-Sleep 10

$i=1
do {
    get-VpnS2SInterface
    start-sleep 5
    $i++
    Write-output $i
} while ($i -lt 10)

Stop-Transcript

