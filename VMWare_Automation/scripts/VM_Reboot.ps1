$vcenter = "indprdvc01.mylab.local"

Connect-VIServer $vcenter

$vms = Get-Content "D:\VMware-Automation\vm_lists\vm_list.txt"

foreach ($vm in $vms)
{
    try {
        Restart-VMGuest -VM $vm -Confirm:$false
        Write-Output "$vm reboot initiated"
    }
    catch {
        Write-Output "$vm failed"
    }
}