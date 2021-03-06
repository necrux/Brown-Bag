# Brown-Bag
A collection of scripts for performing various group troubleshooting exercises. This is intended to be used in conjunction with the RHEL troubleshooting cloud-init scripts; these scripts configure the LAMP stack, install WordPress, install Magento (sample data included), install Joomla, configure Mailgun as a relay for Postix, install/configure Holland, and they clone this repo.<br>

**HOW TO DEPLOY**

1. Grab the troubleshooting cloud-init script for either RHEL 6 or 7 from the cloud-init repo: https://github.com/necrux/cloud-init
2. Modify the cloud-init script with your user specific data. You can run this command to determine what you need to change: ```grep "@.*@" rhel?_troubleshooting --color```
3. Use Nova or Supernova to create a server with your modified cloud-init script (reference supernova.md if needed). Lazy install for Nova and Supernova: ```bash <(curl -sk https://necrux.com/supernova.sh)```
4. Once the server comes online make certain the cloud-init script completes **before** proceeding further: ```tail -f /var/log/cloud-init-output.log```
5. After cloud-init completes you can initialize the environment: ```bash /root/brown-bag/initialize_environment.sh```
6. Depending on how you answered the questions presented in step 5 you *may* need to configure either DNS or your hosts file.
7. Visit the URLs on screen to complete the set-up for your CMSs; all required information is displayed in terminal (*read*).
8. If you intend on doing the inode exercise then I recommend starting the script in screen as it can take hours to run: ```screen -S inodes -m bash /root/brown-bag/scripts/inodes.sh```
9. As you go through the exercises run the scripts in /root/brown-bag/scenario* to configure the environment appropriately (scenario objectives and solutions are in the comments at the top of each script).<br>_More scenarios coming soon!_

**Troubleshooting Methodology**

1. Replicate the problem.
2. Identify likely causes (view logs).
   * Research solutions.
3. Implement the solution.
4. Test the solution.
5. Document the solution.

**Contributing Scenarios**

1. Make a copy of scripts/sceranio_template.skel for the sceranio template.
2. Create your script from the template.
3. Edit scripts/restore_environment.sh as necessary. This script is intended to restore the server back to it's normal, working state and is the first item ran for each scenario.

**Quick Build for Veterans**

* CentOS 6 ```bash <(curl -sk https://necrux.com/qbuild6.sh)```
* CentOS 7 ```bash <(curl -sk https://necrux.com/qbuild7.sh)```<br>
**NOTE:** Once the server is built and cloud-init completes run the scripts under /root/brown-bag/scripts as per usual.

**Gotchas**

* All scripts are built for RHEL/CentOS 6 and 7 only.
* root is not permitted to login via SSH.
* The builds *require* SSH keys.

Enjoy!
