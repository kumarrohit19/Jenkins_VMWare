param(
$vmfile,
$operation,
$batchsize = 50
)

$vcenter = "indprdvc01.mylab.local"

Connect-VIServer $vcenter

$vms = Get-Content $vmfile

$total = $vms.Count
Write-Host "Total VMs: $total"

$batches = [math]::Ceiling($total / $batchsize)

for ($i=0; $i -lt $batches; $i++) {

$start = $i * $batchsize
$batch = $vms[$start..($start+$batchsize-1)]

Write-Host "Processing Batch $($i+1)"

$jobs = @()

foreach ($vm in $batch) {

$jobs += Start-Job -ScriptBlock {

param($vm,$operation)

Connect-VIServer indprdvc01.mylab.local

if ($operation -eq "reboot") {
Restart-VMGuest -VM $vm -Confirm:$false
}

if ($operation -eq "poweron") {
Start-VM -VM $vm -Confirm:$false
}

if ($operation -eq "poweroff") {
Stop-VM -VM $vm -Confirm:$false
}

} -ArgumentList $vm,$operation

}

$jobs | Wait-Job
$jobs | Remove-Job

Start-Sleep -Seconds 30

}