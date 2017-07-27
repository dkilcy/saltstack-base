
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

Perform the following steps on the **controller** with the **demo** environment: `. demo-openrc.sh`
  
3. Add the RDP TCP port to the default security group
  ```
  openstack security group rule create --proto tcp --dst-port 3389 default
  ```

4. Add the public key for the devops user to the key store
  ```
  openstack keypair create --public-key ~/.ssh/id_rsa.pub devops-key
  ```
  
5. Launch the instance
  ```
  openstack server create --flavor m1.medium --image "win2012-r2-std-eval-20170321" \
    --nic net-id=bad3be29-b22a-4e3e-bd6a-fb855d5ad652 \
    --security-group default \
    --key-name devops-key win2012r2-1
    
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
  xfreerdp -u Admin 10.0.0.208
  ```
  
  
