# kubernetes-assessment

This repository contains a small Kubernetes assessment project with example manifests for a simple e-commerce-like stack: Redis, Postgres, backend, frontend, monitoring agent, priority classes, and a batch job. It also includes example files showing a broken app and a fixed version to help with debugging exercises.

## Quick Summary

- **Purpose:** educational assessment / demonstration of Kubernetes workloads and common issues.
- **Contents:** Kubernetes manifests organized under `manifests/` for each component.

## Prerequisites

- A Kubernetes cluster (minikube, kind, cloud cluster, etc.)
- `kubectl` configured to talk to your cluster
- Optional: `kubectl` plugin tools such as `kubectl-trace`, `stern`, or `k9s` for debugging

## Repository Layout

Top-level files:

- `README.md` — this file
- `deployment.md`, `answers.md` — assessment/deployment notes
- `docs/` — additional documentation and test report
- `manifests/` — Kubernetes manifests (see below)
- `scripts/deploy-ecommerce.sh` — helper script (if present)

manifests/ structure (high level):

- `manifests/redis/` — Redis Deployment & Service
- `manifests/postgres/` — Postgres Deployment & Service
- `manifests/backend/` — Backend Deployment & Service
- `manifests/frontend/` — Frontend Deployment & Service
- `manifests/monitoring/` — monitoring-agent.yaml
- `manifests/priority/` — priority-classes.yaml
- `manifests/batch-job-deployment.yaml` — example batch job
- `manifests/broken-app.yaml` and `manifests/fixed-broken-app.yaml` — broken vs fixed examples for troubleshooting

There is also a `screenshoots/` directory (note: directory name spelled "screenshoots") which may contain visual artifacts from testing.

## What each component is for

- Redis: in-memory data store used as a cache or session store for the app.
- Postgres: relational database for persistent data.
- Backend: application server that talks to Postgres/Redis.
- Frontend: UI service exposing the app to users.
- Monitoring agent: lightweight agent manifest to demonstrate monitoring sidecars/Daemons.
- Priority classes: demonstrates prioritization for pods.
- Batch job: example of a cron/batch workload.

## Deployment (example)

Apply manifests in a sensible order to satisfy dependencies (priority classes first, storage/databases, then apps):

1. Apply priority classes (if required by manifests):

```sh
kubectl apply -f manifests/priority/priority-classes.yaml
```

2. Deploy infrastructure components (Redis, Postgres):

```sh
kubectl apply -f manifests/redis/
kubectl apply -f manifests/postgres/
```

3. Deploy backend and frontend:

```sh
kubectl apply -f manifests/backend/
kubectl apply -f manifests/frontend/
```

4. Deploy monitoring agent and batch-job:

```sh
kubectl apply -f manifests/monitoring/monitoring-agent.yaml
kubectl apply -f manifests/batch-job-deployment.yaml
```

5. (Optional) Example broken/fixed app files for exercises:

```sh
kubectl apply -f manifests/broken-app.yaml    # show failing state
kubectl apply -f manifests/fixed-broken-app.yaml  # apply the fix
```

Notes:
- You can apply a directory directly with `kubectl apply -f <directory>/` and it will apply YAML files contained within.
- If any manifests assume a namespace, ensure you create or switch to the correct namespace (not all manifests may set a namespace).

## Verify deployment

Check resources and basic health:

```sh
kubectl get pods --all-namespaces
kubectl get deploy,svc -A
kubectl describe pod <pod-name>
kubectl logs <pod-name> [-c container-name]
```

To check services and access the frontend (if Service type is NodePort/LoadBalancer):

```sh
kubectl get svc -n default
# for port-forwarding to access a service locally:
kubectl port-forward svc/<frontend-service-name> 8080:80
```

## Tests / Assessment

- See `docs/test-report.md` and `deployment.md` for test results and assessment notes.
- The `manifests/broken-app.yaml` and `manifests/fixed-broken-app.yaml` files are useful to practice debugging and to demonstrate root-cause fixes.

## Automation / Scripts

- `scripts/deploy-ecommerce.sh` may contain a convenience script to apply resources — inspect before running.

## Next steps / Recommendations

- Add a namespace manifest to isolate the assessment environment.
- Add RBAC manifests if testing permissions behavior.
- Add ConfigMaps/Secrets examples showing how to inject configuration and credentials.
- Consider adding a `Makefile` or `README`-embedded commands for common tasks (deploy, teardown, test).

