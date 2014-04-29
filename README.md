# OpenNebula Windows Contextualization

## Description

This addon produces a Windows Contextualization script to use in Windows Guest VMs running in an OpenNebula Cloud.

Don't forget to add variables on OpenNebula template:

"USERNAME"
"PASSWORD"
"ETH0_IP"
"ETH0_MASK"
"ETH0_MAC"
"ETH0_DNS"
"ETH0_GATEWAY"
"ETH0_NETWORK"
"SET_HOSTNAME"
"INIT_SCRIPTS"

## Authors

* Leader: Jaime Melis jmelis@opennebula.org
* André Monteiro (Universidade de Aveiro)

## Acknowledgements

This addon is largely based upon the work by André Monteiro and Tiago Batista in the [DETI/IEETA Universidade de Aveiro](http://www.ua.pt/). The original guide is available here: [OpenNebula - IEETA](http://wiki.ieeta.pt/wiki/index.php/OpenNebula)
