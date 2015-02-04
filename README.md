# Brown-Bag
A collection of scripts for performing various group troubleshooting exercises. This is intended to be used in conjunction with the RHEL troubleshooting cloud-init scripts; these scripts configure the LAMP stack, install WordPress, install Magento (sample data included), install Joomla, configure Mailgun as a relay for Postix, install/configure Holland, and they clone this repo.

**HOW TO DEPLOY**

1. Grab the troubleshooting cloud-init script for either RHEL 6 or 7 from the cloud-init repo: https://github.com/necrux/cloud-init
2. Modify the cloud-init script with your user specific data. You can run this command to determine what you need to change: ```egrep "__[a-z-]*__|ssh-rsa .*" rhel?_troubleshooting --color```
3. Use Nova or Supernova to create a server with your modified cloud-init script. Lazy install for Nova and Supernova: ```bash <(curl -sk https://necrux.com/supernova.sh)```
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

**Additional Information**
* cloud-init
   - https://developer.rackspace.com/blog/using-cloud-init-with-rackspace-cloud/
   - https://cloudinit.readthedocs.org/en/latest/
* Nova Client
   - http://www.rackspace.com/knowledge_center/article/installing-python-novaclient-on-linux-and-mac-os
* Supernova
   - http://supernova.readthedocs.org/en/latest/
* Github
   - https://try.github.io/levels/1/challenges/1
* Screen
   - http://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/

**Supernova Syntax**

```supernova <environment_name> --flavor <flavor> --image <UUID> <server_name>```

**Supernova Examples**

1GB Performance CentOS 6 Server in DFW with its respective cloud-init script:<br>
```supernova dfw boot --config-drive=true --flavor performance1-1 --image 8aac6fb5-4bd3-4256-bf6e-ff8500bf60cd --user-data rhel6_troubleshooting RHEL-6```<br><br>
1GB Performance CentOS 7 Server in DFW with its respective cloud-init script:<br>
```supernova dfw boot --config-drive=true --flavor performance1-1 --image d6e18edc-d7dc-4639-b55f-56012798df33 --user-data rhel7_troubleshooting RHEL-7```

**Contributing Scenarios**

1. Make a copy of scripts/sceranio_template.skel for the sceranio template.
2. Create your script from the template.
3. Edit scripts/restore_environment.sh as necessary. This script is intended to restore the server back to it's normal, working state and is the first item ran for each scenario.

Enjoy!
