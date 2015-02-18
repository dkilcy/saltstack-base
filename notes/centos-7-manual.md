
#### Manual Install from Media

Overview


Work in progress.  Some steps missing

1. Boot from media
2. Keyboard and Language 
2. Under Software, click Software Selection.  The Software Selection page appears.
3. Select Server with GUI, click Done in the upper-left.
4. Under System, click Installation Destination.  The Installer Destiation page appeares. 
5. Under Partitioning, select **I will configure partitioning**, click **Done**
6. The Manual Partitioning page appears.
7. Under **New mout points will use the following partitioning scheme** select **Standard Partition**
8. Click +.  The **Add a new mount point** dialog will appear.
9. For Mount Point, select `/boot`. For Desired Capacity enter `512`.  Click **Add Mount Point**
10. Click +. The **Add a new mount point** dialog will appear.
11. For Mount Point, select `swap`.  For Desired Capacity enter `4096`.  Click **Add Mount Point**
12. Click +. The **Add a new mount point** dialog will appear.
13. For Mount Point, select `/`.  Do not enter anything into Desired Capacity.  .  Click **Add Mount Point**
14. Click Done in the upper left.  The Summary of Changes window appears.  Click **Accept Changes**
15. Under System, click **Network & Hostname**
16. Select ethernet interface.  Click slider in upper-right On.  Click Configure in lower-right
17. Click General Tab.  Select **Automatically connect to this network when it is available**
18. Click IPv4 Tab.  Configure the network information
19. Click Begin Installation
20. Add devops user
21. Set root password
22. Reboot
23. Accept the License agreement
24. Reboot and login to GNOME3 as devops user

