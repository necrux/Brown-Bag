# Brown-Bag
A collection of scripts for performing various group troubleshooting exercises. This is intended to be used in conjunction with the RHEL troubleshooting cloud-init scripts; these scripts configure the LAMP stack, install WordPress, install Magento (sample data included), install Joomla, and they automatcially clone this repo.

**HOW TO DEPLOY**

1. Grab the troubleshooting cloud-init script for RHEL 6 or 7 from the cloud-init repo: https://github.com/necrux/cloud-init
2. Modify the cloud-init script with your user specific data: <pre>grep __[a-z-]*__ rhel*_troubleshooting</pre>
3. Use the Nova client or supernova to create a server with your modified cloud-init script.
4. Once the server comes online make certain the cloud-init script completes **before** proceeding further: <code>tail -f /var/log/cloud-init-output.log</code> 
5. After cloud-init completes you can initialize the environment: <code>bash /root/brown-bag/initialize_environment.sh</code>
6. Depending on how you answered the questions presented in step 5 you *may* need to configure either DNS or your hosts file.
7. Visit the URLs on screen to complete the set-up for your CMSs; all required information is displayed in terminal (be sure to read).
8. If you intend on doing the inode exercise then I recommend starting the script in screen as it can take hours to run: <code>screen -S inodes -m bash /root/brown-bag/scripts/inodes.sh</code>
9. As you go through the exercises runs the scripts in /root/brown-bag/scenario* to configure the environment appropriately. More scenarios to come!
10. Profit!


**Troubleshooting Methodology**

1. Replicate the problem.
2. Identify likely causes (view logs).
   * Research solutions.
3. Implement the solution.
4. Test the solution.
5. Document the solution.

Enjoy!
