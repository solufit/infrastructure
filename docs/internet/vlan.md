
# Define vLans

## Infrastructure vLans

172.16.0.0/12

ID | Range | Description | ACL
--------|--------- | --------- | ---------------
 1 | 172.16.0.64/26 | Native Vlan | same subnet and internet only.
 2 | 172.16.0.0/26 | Router Access | Everyone can Access.
 3 | 172.16.1.0/26 | au-hikari to router | Isolation.

------

--------|--------- | --------- | ---------------
 20 | 172.16.0.128/26 | Ceph | Infrastructure and VMS can access.
 21 | 172.16.0.192/26 | Ubuntu Manage | Infrastructure can access.
 22 | 172.16.1.64/26 | Ceph Cluster | isolation, same subnet only.

## Wifi

172.18.0.0/16

DHCP Range: 172.18.0.0~172.18.0.254

--------|--------- | --------- | ---------------
 10 | 172.18.0.0/24 | Wifi | same subnet only.

## VM

172.17.0.0/16

--------|--------- | --------- | ---------------
 31 | 172.17.2.0/23 | vm | vm only.

172.17.3.0 ~ 172.17.254.254 : Reserved for VMs. (It will be used by SDN.)
