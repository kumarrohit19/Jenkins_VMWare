param(
    [string]$vcenter,
    [string]$vmList,
    [string]$action,
    [string]$snapshotName
)

#Import-Module VMware.PowerCLI

$vcUser = $env:VC_USER
$vcPass = $env:VC_PASS

$securePass = ConvertTo-SecureString $vcPass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vcUser,$securePass)

Connect-VIServer $vcenter

$vms = $vmList -split "`n"

foreach ($vm in $vms) {

    $vm = $vm.Trim()

    if ($vm -eq "") { continue }

    Write-Host "Processing VM: $vm"

    if ($action -eq "CREATE") {

        New-Snapshot -VM $vm `
        -Name $snapshotName `
        -Description "Snapshot created from Jenkins" `
        -Memory:$false `
        -Quiesce:$true

        Write-Host "Snapshot created on $vm"

    }

    elseif ($action -eq "DELETE") {

        Get-Snapshot -VM $vm -Name $snapshotName | Remove-Snapshot -Confirm:$false

        Write-Host "Snapshot deleted on $vm"

    }

}

Disconnect-VIServer -Confirm:$false