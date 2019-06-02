# Kubernetes Baremetal Lab at Home

## Goals

1. Deploy a full-featured 3-node Kubernetes cluster at home.
2. Deploy an application to the cluster.
3. Expose the application using a self-hosted dynamic DNS service.

## First Try: Mostly Manual Setup

### 1. Buying hardware

I'll be using [HP t610 Flexible Thin Client ](https://support.hp.com/si-en/document/c03235347) machines for our setup. These mini-PCs are based on x86-64 architecture and are widely available, cheap, completely silent (with passive cooling and SSDs), and power-efficient.

As a starting point, I bought three of these machines for 35 € each. Since there are two RAM slots on each machine, I upgraded RAM with an additional 2 GB, and I ended up with the following hardware configuration for my cluster:

- CPU: 3x AMD Dual-Core 1.65 GHz T56N APU with Radeon HD 6320 Graphics
- RAM: 14 GB DDR3 1333Mhz (6 GB + 4 GB + 4 GB)
- Storage: 16+16+4+20+20+20 GB = 96 GB worth of SSDs

(Should add a photo of the setup here)

### 2. Setting up hardware

The first thing I did was download the newest version of BIOS from https://support.hp.com/us-en/drivers/selfservice/hp-t610-flexible-thin-client/5226816.

I then installed Ubuntu Server 16.04 on each machine.

### 3. Using Terraform to set everything up
