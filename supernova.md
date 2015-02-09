**Supernova Syntax**

```supernova <environment_name> --flavor <flavor> --image <UUID> <server_name>```

**Supernova Examples**

1GB Performance CentOS 6 (PVHVM) server in DFW with its respective cloud-init script:<br>
```supernova dfw boot --config-drive=true --flavor performance1-1 --image 8aac6fb5-4bd3-4256-bf6e-ff8500bf60cd --user-data rhel6_troubleshooting RHEL-6```<br><br>
1GB Performance CentOS 7 (PVHVM) server in DFW with its respective cloud-init script:<br>
```supernova dfw boot --config-drive=true --flavor performance1-1 --image d6e18edc-d7dc-4639-b55f-56012798df33 --user-data rhel7_troubleshooting RHEL-7```

**Additional Reading**

* Nova Client
   - http://www.rackspace.com/knowledge_center/article/installing-python-novaclient-on-linux-and-mac-os
* Supernova
   - http://supernova.readthedocs.org/en/latest/
