#!/bin/bash
# deploy-ecommerce.sh

# 1. Create namespace
kubectl create namespace ecommerce
kubectl config set-context --current --namespace=ecommerce

# 2. Deploy database
kubectl apply -f manifests/postgres/

# 3. Deploy cache
kubectl apply -f manifests/redis/

# 4. Deploy backend
kubectl apply -f manifests/backend/

# 5. Deploy frontend
kubectl apply -f manifests/frontend/

# 6. Deploy priority classes
kubectl apply -f manifests/priority-classes.yaml

# 7. Verify deployment
kubectl get all
kubectl get pods -o wide

# 8. Test access
echo "Access frontend at: http://<WORKER_NODE_IP>:30080"