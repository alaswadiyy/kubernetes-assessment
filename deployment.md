# E-commerce Platform Kubernetes Deployment Guide

## Overview
This document details the deployment of a microservices-based e-commerce platform on a 3-node Kubernetes cluster using kubeadm.

## Cluster Architecture
- **Nodes**: 1 Control Plane + 2 Worker Nodes
- **Kubernetes Version**: v1.35
- **Container Runtime**: containerd
- **CNI Plugin**: Calico
- **Namespace**: ecommerce

## Node Configuration

### Worker Node 1 (frontend)
```bash
Labels:
  environment=production
  storage=ssd
  tier=frontend
Taints:
  workload=frontend:NoSchedule