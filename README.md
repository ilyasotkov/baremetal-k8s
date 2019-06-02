# Kubernetes Baremetal Lab

![HP Thin Flexible Client t610 Home Data Center](/assets/hardware-001.jpeg)

*Let's build a cheap home data center (based on x86-64) and run Kubernetes on it!*

Initial targets for this project:

- Build a home data center (private cloud) for under 200 €
- Create a POC solution for hosting apps (with dynamic DNS since my ISP doesn't provide static IP addresses for non-corporate customers)
- Experiment with various tools and technologies, including
    - Terraform 0.12 & Terraform Enterprise Free Tier
    - Linux and various distributions (Ubuntu, CoreOS, RancherOS)
    - kubeadm
    - Kubernetes 1.14
    - Helm 3

## 1. Buying hardware

I'll be using [HP t610 Flexible Thin Client ](https://support.hp.com/si-en/document/c03235347) machines for my cluster setup. These mini-PCs are based on x86-64 architecture and are widely available, cheap, completely silent (with passive cooling and SSDs), and power-efficient.

As a starting point, I bought three of these machines for 35 € each. Since there are two RAM slots on each machine, I upgraded each machine with an additional 2 GB stick of RAM, and I ended up with the following hardware configuration for my cluster:

- CPU: 3x AMD Dual-Core 1.65 GHz T56N APU with Radeon HD 6320 Graphics
- RAM: 14 GB DDR3 1333Mhz (6 GB + 4 GB + 4 GB)
- Storage: 16+16+4+20+20+20 GB = 96 GB worth of SSDs

## 2. Initial (manual) hardware setup

### 2.1. Firmware update

The first thing I did was download the newest version of BIOS from https://support.hp.com/us-en/drivers/selfservice/hp-t610-flexible-thin-client/5226816 Since the resulting download is an `.exe` file, it required me to first create a Windows 10 virtual machine with VirtualBox to extract my `.bin` file and put it on a USB flash drive. I then booted each machine while holding *F10* and upgraded the firmware from BIOS.

### 2.2. Host OS

I used [balenaEtcher](https://github.com/balena-io/etcher) to create a bootable USB drive with Ubuntu Server 16.04, then manually went through the install process. *(Note: this should be automated)*

After the installation, I ran the following commands in order to enable Terraform to do the rest of provisioning as a `root` user:

```sh
sudo passwd root
```
```sh
sudo sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config
```
```sh
sudo service sshd restart
```

## 3. Using Terraform to set everything up

...
