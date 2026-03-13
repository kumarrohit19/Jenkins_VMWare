param(
[string]$vcenter,
[string]$csvFile
)

$vcUser = $env:VC_USER
$vcPass = $env:VC_PASS

$securePass = ConvertTo-SecureString $vcPass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vcUser,$securePass)

Connect-VIServer $vcenter -Credential $cred

$vmlist = Import-Csv $csvFile

foreach ($vm in $vmlist){

    Write-Host "Creating VM:" $vm.VM_NAME

    $vmhost = Get-Cluster $vm.CLUSTER | Get-VMHost | Sort MemoryUsageGB | Select -First 1

    $newvm = New-VM `
    -Name $vm.VM_NAME `
    -Template $vm.TEMPLATE `
    -VMHost $vmhost `
    -Datastore $vm.DATASTORE
    
    Set-VM -VM $newvm `
    -NumCpu $vm.CPU `
    -MemoryGB $vm.MEMORY_GB `
    -Confirm:$false

    Get-NetworkAdapter -VM $newvm |
    Set-NetworkAdapter -NetworkName $vm.NETWORK -Confirm:$false

    $disk = Get-HardDisk -VM $newvm | Select -First 1

    if($disk.CapacityGB -lt $vm.DISK_GB){
        Set-HardDisk -HardDisk $disk -CapacityGB $vm.DISK_GB -Confirm:$false
    }

    Write-Host "VM created successfully:" $vm.VM_NAME
}

Disconnect-VIServer -Confirm:$false