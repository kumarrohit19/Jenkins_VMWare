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
5. create one service account and provide below permissions to perform the job in vcenter
   (Virtual Machine & Assign Virtual Machine to Resource Pool)
6. Run the jobs

Here are some Images for reference:

Service Account Created in Active Directory
![alt text](Images/Service_Account_in_AD.png)

Added Service Account in Jenkins for performing VMware Operations
![alt text](Images/Credentials.png)

Dashboard
![alt text](Images/Dashboard.png)

Permissions required in vCenter:
Need to provide permission under Resources
![alt text](Images/Resource.png)

Need Virtual Machine Management Permission
![alt text](Images/Virtual_machine.png)

Need to Assign this custom created permission to service account
![alt text](Images/Service_Account.png)


