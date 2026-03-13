This Project is for automating the VMWare Operation using Jenkins.

Pre-requisites for setting up this workflow.
1. vcenter
2. Jenkins
3. PowerCLI

Steps to follow:
1. Login into jenkins console
2. Create a pipeline job
3. Paste the codes mentioned in Jenkins_Pipelines folder.
4. copy the vmware_automation folder on your system, and make the configuration changes for logging the vcenter.
5. create one service account and provide below permissions to perform the jon in vcenter
   (Virtual Machine & Assign Virtual Machine to Resource Pool)
7. Run the jobs
