param(
[string]$vcenter,
[string]$vmname,
[string]$template,
[int]$cpu,
[int]$memory,
[int]$disk,
[string]$datastore,
[string]$cluster,
[string]$network)


$vcUser = $env:VC_USER
$vcPass = $env:VC_PASS

$securePass = ConvertTo-SecureString $vcPass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vcUser,$securePass)

Connect-VIServer $vcenter -Credential $cred

Write-Host "Selecting host from cluster..."

$vmhost = Get-Cluster $cluster | Get-VMHost | Sort MemoryUsageGB | Select -First 1

Write-Host "Deploying VM from template..."

$vm = New-VM `
-Name $vmname `
-Template $template `
-VMHost $vmhost `
-Datastore $datastore

Write-Host "Customizing CPU and Memory..."

Set-VM -VM $vm -NumCpu $cpu -MemoryGB $memory -Confirm:$false

Write-Host "Updating Network..."

Get-NetworkAdapter -VM $vm | Set-NetworkAdapter -NetworkName $network -Confirm:$false

Write-Host "Resizing Disk..."

$hardDisk = Get-HardDisk -VM $vm | Select -First 1
if($hardDisk.CapacityGB -lt $disk){
    Set-HardDisk -HardDisk $hardDisk -CapacityGB $disk -Confirm:$false
}

Write-Host "VM deployment completed: $vmname"

Disconnect-VIServer -Confirm:$false