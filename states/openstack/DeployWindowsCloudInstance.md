
## Deploy Windows Cloud Instance on OpenStack Ocata

1. Download the evaulation image for KVM from https://cloudbase.it/windows-cloud-images/
2. Deploy the downloaded image to Glance

Perform the following steps on the **controller** with the **admin** environment: `. admin-openrc.sh`

  ```
  gunzip -d windows_server_2012_r2_standard_eval_kvm_20170321.qcow2.gz
  
  openstack image create "win2012-r2-std-eval-20170321" \
   --file windows_server_2012_r2_standard_eval_kvm_20170321.qcow2 \
   --disk-format qcow2 --container-format bare \
   --property hypervisor_type=QEMU --property os_type=windows \
   --public
  ```
   
6. Launch the instance
  ```
  openstack server create --flavor m1.medium --image "win2012-r2-std-eval-20170321" \
    --nic net-id=bad3be29-b22a-4e3e-bd6a-fb855d5ad652 \
    --security-group windows-server \
    --key-name devops-key \
    win2012r2-1
  ```
  
  Wait for the status to go to ACTIVE
  ```
  openstack server list
  ```
  
6. Get the Administrator password

  ```
  nova get-password win2012r2-1 /home/devops/.ssh/id_rsa
  ```
  
### Using FreeRDP to connect to the Instance

1. Connect to the instance via RDP

  ```
  yum install freerdp
  xfreerdp -u Admin 10.0.0.216
  ```
  
### Configure Active Directory and DNS Server

1. Login as Administrator.
2. From the Server Manager Dashboard, verify the VM is set with a static IP address -- **You must do this for AD to work**
3. From the Server Manager Dashboard, set the Active Directory and DNS Roles
  * a. Click Add roles and features
  * b. Select a server from the server pool: 
  * c. The Select Roles dialog appears. Check:
      - Active Directory Domain Services
      - DNS Server
  * d. Take the defaults for the remaining steps and click Next
  
4. You should see AD DS and DNS added to the list column in the Server Manager Dashboard
5. Promote the server to Domain Controller
  * a. Select notification icon in Dashboard and click Promote this server to a domain controller
  * b. For Select the deployment operation choose Add a new forest
    - Root domain name: **lab.local**
  * c. Click Change and supply credentials
  * d. Type the Directory Services Restore Mode (DSRM) password: **DSRMpassword1**
  * e. Ignore the authoritative parent zone warning - click Next
  * f. Verify NetBIOS name: **LAB**
  * g. Review your selections and click Install
  * h. OS restarts
6. Log back into the OS and set the correct time zone (EST)
7. Create a **testuser1@lab.local** user in Active Directory Users and Computers as a test
    

### References

Where to get images:

- [RDO Image resources](https://openstack.redhat.com/resources/image-resources/)
- [OpenStack Windows Server 2012 R2 Evaluation Image](https://cloudbase.it/openstack-windows-server-2012-r2-evalution-images/
)
- [https://social.technet.microsoft.com/Forums/en-US/024cce0f-f2f1-4714-abc9-1a4ecf40638a/what-difference-between-primary-dns-suffix-and-connectionspecific-dns-suffix?forum=winserverNIS](https://social.technet.microsoft.com/Forums/en-US/024cce0f-f2f1-4714-abc9-1a4ecf40638a/what-difference-between-primary-dns-suffix-and-connectionspecific-dns-suffix?forum=winserverNIS)


  
  
