
## Deploy Windows Cloud Instance on OpenStack Ocata

1. Download the evaulation image for KVM from https://cloudbase.it/windows-cloud-images/.  Decompress the image and save it to the /home/devops/openstack/images directory on the controller.

2. Deploy the downloaded image to Glance 

Perform the following steps on the **controller** with the **admin** environment

```
[root@controller openstack]$ . admin-openrc.sh 
[root@controller openstack]$ cd images/
[root@controller images]$ openstack image create "win2012-r2-std-eval-20170321" \
  --file windows_server_2012_r2_standard_eval_kvm_20170321.qcow2 \
  --disk-format qcow2 --container-format bare \
  --property hypervisor_type=QEMU --property os_type=windows \
  --public
+------------------+------------------------------------------------------+
| Field            | Value                                                |
+------------------+------------------------------------------------------+
| checksum         | a05ead3a04ae663da77eee5d2cb2fa73                     |
| container_format | bare                                                 |
| created_at       | 2017-07-29T17:28:07Z                                 |
| disk_format      | qcow2                                                |
| file             | /v2/images/74cb96cd-1aef-4770-8f87-c6694a372a3b/file |
| id               | 74cb96cd-1aef-4770-8f87-c6694a372a3b                 |
| min_disk         | 0                                                    |
| min_ram          | 0                                                    |
| name             | win2012-r2-std-eval-20170321                         |
| owner            | 049bc1d6c4924390840e3d94ecdff939                     |
| properties       | hypervisor_type='QEMU', os_type='windows'            |
| protected        | False                                                |
| schema           | /v2/schemas/image                                    |
| size             | 12001017856                                          |
| status           | active                                               |
| tags             |                                                      |
| updated_at       | 2017-07-29T17:29:42Z                                 |
| virtual_size     | None                                                 |
| visibility       | public                                               |
+------------------+------------------------------------------------------+
```
   
#### Launch an instance (DHCP)

Perform the following steps on the **controller** with the **admin** environment

```
[root@controller openstack]$ . admin-openrc.sh 
[root@controller openstack]$ openstack server create --flavor m1.medium --image "win2012-r2-std-eval-20170321" \
  --nic net-id=a275e07f-6e11-4ce1-92c1-40c32e764428 \
  --security-group windows-default --key-name devops-key \
   win2012r2-test-1
+-------------------------------------+---------------------------------------------------------------------+
| Field                               | Value                                                               |
+-------------------------------------+---------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                              |
| OS-EXT-AZ:availability_zone         |                                                                     |
| OS-EXT-SRV-ATTR:host                | None                                                                |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                                                |
| OS-EXT-SRV-ATTR:instance_name       |                                                                     |
| OS-EXT-STS:power_state              | NOSTATE                                                             |
| OS-EXT-STS:task_state               | scheduling                                                          |
| OS-EXT-STS:vm_state                 | building                                                            |
| OS-SRV-USG:launched_at              | None                                                                |
| OS-SRV-USG:terminated_at            | None                                                                |
| accessIPv4                          |                                                                     |
| accessIPv6                          |                                                                     |
| addresses                           |                                                                     |
| adminPass                           | sExxFrDB346Q                                                        |
| config_drive                        |                                                                     |
| created                             | 2017-07-29T17:30:35Z                                                |
| flavor                              | m1.medium (3)                                                       |
| hostId                              |                                                                     |
| id                                  | cc70ac8d-d2f8-4c1f-9202-d396b9e54cbd                                |
| image                               | win2012-r2-std-eval-20170321 (74cb96cd-1aef-4770-8f87-c6694a372a3b) |
| key_name                            | devops-key                                                          |
| name                                | win2012r2-test-1                                                    |
| progress                            | 0                                                                   |
| project_id                          | 049bc1d6c4924390840e3d94ecdff939                                    |
| properties                          |                                                                     |
| security_groups                     | name='windows-default'                                              |
| status                              | BUILD                                                               |
| updated                             | 2017-07-29T17:30:35Z                                                |
| user_id                             | a3c712f29e7e4101ba7b7eb1bbb57a28                                    |
| volumes_attached                    |                                                                     |
+-------------------------------------+---------------------------------------------------------------------+
```
  
Wait for the status to go to ACTIVE
```
[root@controller openstack]$ openstack server list
+--------------------------------------+------------------+--------+---------------------+------------------------------+
| ID                                   | Name             | Status | Networks            | Image Name                   |
+--------------------------------------+------------------+--------+---------------------+------------------------------+
| cc70ac8d-d2f8-4c1f-9202-d396b9e54cbd | win2012r2-test-1 | BUILD  | provider=10.0.0.204 | win2012-r2-std-eval-20170321 |
| c08726b5-52c4-4c02-a092-e9e15a83343c | test-instance    | ACTIVE | provider=10.0.0.207 | cirros-0.3.4                 |
+--------------------------------------+------------------+--------+---------------------+------------------------------+
[root@controller openstack]$ openstack server list
+--------------------------------------+------------------+--------+---------------------+------------------------------+
| ID                                   | Name             | Status | Networks            | Image Name                   |
+--------------------------------------+------------------+--------+---------------------+------------------------------+
| cc70ac8d-d2f8-4c1f-9202-d396b9e54cbd | win2012r2-test-1 | ACTIVE | provider=10.0.0.204 | win2012-r2-std-eval-20170321 |
| c08726b5-52c4-4c02-a092-e9e15a83343c | test-instance    | ACTIVE | provider=10.0.0.207 | cirros-0.3.4                 |
+--------------------------------------+------------------+--------+---------------------+------------------------------+
```
** NOTE: The instance tan take some time to fully spin up after entering ACTIVE status**
 
6. Get the Administrator password

```
[root@controller openstack]$ openstack server list
+--------------------------------------+------------------+--------+---------------------+------------------------------+
| ID                                   | Name             | Status | Networks            | Image Name                   |
+--------------------------------------+------------------+--------+---------------------+------------------------------+
| cc70ac8d-d2f8-4c1f-9202-d396b9e54cbd | win2012r2-test-1 | ACTIVE | provider=10.0.0.204 | win2012-r2-std-eval-20170321 |
| c08726b5-52c4-4c02-a092-e9e15a83343c | test-instance    | ACTIVE | provider=10.0.0.207 | cirros-0.3.4                 |
+--------------------------------------+------------------+--------+---------------------+------------------------------+
[root@controller openstack]$ openstack console url show win2012r2-test-1
+-------+---------------------------------------------------------------------------------+
| Field | Value                                                                           |
+-------+---------------------------------------------------------------------------------+
| type  | novnc                                                                           |
| url   | http://controller:6080/vnc_auto.html?token=2bed2a3e-c43d-4003-8383-67f0d4221c66 |
+-------+---------------------------------------------------------------------------------+
[root@controller openstack]$ nova get-password win2012r2-test-1 /home/devops/.ssh/id_rsa
fo0RMXmcfeOQwFsJvojd
```
  
### Using FreeRDP to connect to the Instance

1. Connect to the instance via RDP

```
yum install freerdp
xfreerdp -u Admin 10.0.0.204
```

### Launch an instance with a fixed IP

A dynamic IP is still configured in Internet Protocol Version 4 (TCP/IPv4) Properties as the static IP is managed on the Openstack level and not on the VM level.

1. Create a port

```
[root@controller openstack]$ openstack port create --network provider --fixed-ip subnet=2a20fb19-9150-4878-8f74-6ab44317ad56,ip-address=10.0.0.216 res216
+-----------------------+---------------------------------------------------------------------------+
| Field                 | Value                                                                     |
+-----------------------+---------------------------------------------------------------------------+
| admin_state_up        | UP                                                                        |
| allowed_address_pairs |                                                                           |
| binding_host_id       |                                                                           |
| binding_profile       |                                                                           |
| binding_vif_details   |                                                                           |
| binding_vif_type      | unbound                                                                   |
| binding_vnic_type     | normal                                                                    |
| created_at            | 2017-07-29T20:45:17Z                                                      |
| description           |                                                                           |
| device_id             |                                                                           |
| device_owner          |                                                                           |
| dns_assignment        | None                                                                      |
| dns_name              | None                                                                      |
| extra_dhcp_opts       |                                                                           |
| fixed_ips             | ip_address='10.0.0.216', subnet_id='2a20fb19-9150-4878-8f74-6ab44317ad56' |
| id                    | 72871cef-f511-4414-b731-70afb2ff65ae                                      |
| ip_address            | None                                                                      |
| mac_address           | fa:16:3e:00:59:87                                                         |
| name                  | res216                                                                    |
| network_id            | a275e07f-6e11-4ce1-92c1-40c32e764428                                      |
| option_name           | None                                                                      |
| option_value          | None                                                                      |
| port_security_enabled | True                                                                      |
| project_id            | 049bc1d6c4924390840e3d94ecdff939                                          |
| qos_policy_id         | None                                                                      |
| revision_number       | 5                                                                         |
| security_groups       | fff0ae97-9395-4601-ad9e-199767996ff5                                      |
| status                | DOWN                                                                      |
| subnet_id             | None                                                                      |
| updated_at            | 2017-07-29T20:45:17Z                                                      |
+-----------------------+---------------------------------------------------------------------------+
```

2. Launch instance

```
[root@controller openstack]$ openstack server create --flavor m1.large --image "win2012-r2-std-eval-20170321" \
  --nic port-id=72871cef-f511-4414-b731-70afb2ff65ae \
  --security-group windows-default --key-name devops-key \
   win2012r2-s1
```

### Configure Active Directory and DNS Server

1. Login as Administrator.
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

- [OpenStack Windows Server 2012 R2 Evaluation Image](https://cloudbase.it/openstack-windows-server-2012-r2-evalution-images/
)
- [How to Assign a Private Static IP to an Azure VM](https://social.technet.microsoft.com/wiki/contents/articles/23447.how-to-assign-a-private-static-ip-to-an-azure-vm.aspx)
- [Creating an Instance with a Specific Fixed IP](http://ibm-blue-box-help.github.io/help-documentation/openstack/userdocs/Creating-an-Instance-with-a-Specific-Fixed-IP/)
- [How to Create An Instance With Static IP](http://ibm-blue-box-help.github.io/help-documentation/openstack/userdocs/Creating_Instances_With_Static_IP/)
- [https://social.technet.microsoft.com/Forums/en-US/024cce0f-f2f1-4714-abc9-1a4ecf40638a/what-difference-between-primary-dns-suffix-and-connectionspecific-dns-suffix?forum=winserverNIS](https://social.technet.microsoft.com/Forums/en-US/024cce0f-f2f1-4714-abc9-1a4ecf40638a/what-difference-between-primary-dns-suffix-and-connectionspecific-dns-suffix?forum=winserverNIS)


  
  
