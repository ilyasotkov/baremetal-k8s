# Kubernetes Baremetal Lab

> ⚠️ This is a work in progress ⚠️

![HP Thin Flexible Client t610 Home Data Center](/assets/hardware-002.jpeg)

*Let's build a cheap home data center (based on x86-64) and run Kubernetes on it!*

Initial targets for this project:

- Build a home data center (private cloud) for under 200 €
- Create a POC solution for hosting apps (with dynamic DNS since my ISP doesn't provide static IP addresses for non-corporate customers)
- Experiment with various tools and technologies, including
    - Terraform 0.12 & Terraform Enterprise Free Tier
    - Linux and various distributions (Ubuntu, CoreOS, RancherOS)
    - kubepsray and Ansible
    - kubeadm
    - Kubernetes 1.14
    - Helm 3

## 1. Buying hardware

I'll be using [HP t610 Flexible Thin Client ](https://support.hp.com/si-en/document/c03235347) machines for my cluster setup. These mini-PCs are based on x86-64 architecture and are widely available, cheap, completely silent (with passive cooling and SSDs), and power-efficient.

As a starting point, I bought three of these machines for 35 € each. Since there are two RAM slots on each machine, I upgraded each machine with an additional 2 GB stick of RAM, and I ended up with the following hardware configuration for my cluster:

- CPU: 3x AMD Dual-Core 1.65 GHz T56N APU with Radeon HD 6320 Graphics
- RAM: 14 GB DDR3 1333Mhz (6+4+4 GB)
- Storage: 96 GB worth of SSDs (4+20+16+20+16+20 GB)

## 2. Initial (manual) hardware setup

### 2.1. Firmware update

The first thing I did was download the newest version of BIOS from https://support.hp.com/us-en/drivers/selfservice/hp-t610-flexible-thin-client/5226816 Since the resulting download is an `.exe` file, it required me to first create a Windows 10 virtual machine with VirtualBox to extract my `.bin` file and put it on a USB flash drive. I then booted each machine while holding *F10* and upgraded the firmware from BIOS.

### 2.2. Host OS

I used [balenaEtcher](https://github.com/balena-io/etcher) to create a bootable USB drive with Ubuntu Server 16.04, then manually went through the install process. *(Note: this could and should be automated)*

### 3. Kubernetes cluster setup

We'll use kubespray to create a Kubernetes cluster from our Ubuntu nodes. I cloned the latest release of kubespray and removed all files and directories that we won't be using (except that I left the `roles` directory intact).

(describe changes to default variables)

```sh
dc build && dc run --rm controller ansible-playbook -v cluster.yml
```

*...to be continued...*

### 4. Access the Kubernetes Dashboard

1. Create a service account and cluster role binding for the dashboard:
    ```sh
    docker-compose run --rm controller bash
    ```
    ```sh
    kubectl apply -f hack/dashboard.yaml
    ```
2. Get the token to sign in to the dashboard:
    ```sh
    kubectl -n kube-system describe secret \
        $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
    ```
3. From the controller host (not Docker container):
```sh
docker-compose up -d
```

4. Go to https://localhost:9443

## Troubleshooting

### How to setup kubeconfig file on master node

```sh
sudo cp /etc/kubernetes/admin.conf $HOME/ \
    && sudo chown $(id -u):$(id -g) $HOME/admin.conf \
    && export KUBECONFIG=$HOME/admin.conf
```

From https://github.com/kubernetes-sigs/kubespray/issues/1615#issuecomment-453118963

*TODO: Automatically copy kubeconfig file to a local directory after `cluster.yml`*

### Kubernetes master NotReady after reboot

Bad unproven solution: flush iptables

(must investigate further how to handle hard reboot of the master)

```sh
dc build && dc run --rm controller ansible-playbook -v reset.yml --tag iptables -l master-node
```
From: https://github.com/kubernetes-sigs/kubespray/issues/2348
