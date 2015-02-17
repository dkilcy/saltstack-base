
#### Manual Install from Media

a. Boot from media
a. Under Software, click Software Selection.  The Software Selection page appears.
a. Select Server with GUI, click Done in the upper-left.
a. Under System, click Installation Destination.  The Installer Destiation page appeares. 
a. Under Partitioning, select I will configure partitioning, click Done
a. The Manual Partitioning page appears.
a. Under **New mout points will use the following partitioning scheme** select **Standard Partition**
a. Click +.  The **Add a new mount point** dialog will appear.
a. For Mount Point, select `/boot`. For Desired Capacity enter `512`.  Click **Add Mount Point**
a. Click +. The **Add a new mount point** dialog will appear.
a. For Mount Point, select `swap`.  For Desired Capacity enter `4096`.  Click **Add Mount Point**
a. Click +. The **Add a new mount point** dialog will appear.
a. For Mount Point, select `/`.  Do not enter anything into Desired Capacity.  .  Click **Add Mount Point**
a. Click Done in the upper left.  The Summary of Changes window appears.  Click **Accept Changes**
a. Under System, click **Network & Hostname**
a. Select ethernet interface.  Click slider in upper-right On.  Click Configure in lower-right
a. Click General Tab.  Select **Automatically connect to this network when it is available**
a. Click IPv4 Tab.  Configure the network information
a. Click Begin Installation
