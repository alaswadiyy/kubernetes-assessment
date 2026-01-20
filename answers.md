
# Assessment Answers

This file contains the assessment answers formatted as Markdown. Each Part corresponds to the original assessment sections.

## Part 1 — Node labels & taints

Q: Node labels applied?

- `worker-node-1`: `environment=production`, `storage=ssd`, `tier=frontend`
- `worker-node-2`: `environment=production`, `storage=hdd`, `tier=backend`

Q: Taints applied?

- `worker-node-1`: `workload=frontend:NoSchedule`
- `worker-node-2`: `workload=backend:NoSchedule`

## Part 2 — PostgreSQL scheduling & service exposure

Q1: PostgreSQL pod scheduled where?

- On `worker-node-2` (has `tier=backend` label and matches toleration).

Q2: Remove toleration effect?

- Pod stays `Pending` — cannot schedule on the tainted node without toleration.

Q3: Access DB externally?

- No — the Postgres service is `ClusterIP` (internal only).

## Part 3 — Redis affinity and scaling

Q1: Redis pods on different nodes?

- Yes — pod anti-affinity is used to spread Redis pods across nodes for high availability.

Q2: Scale to 3 replicas with 2 nodes?

- The third pod remains `Pending` because the anti-affinity rule prohibits colocating two pods on the same node.

Q3: `preferredDuringScheduling` vs `requiredDuringScheduling`?

- **required**: hard rule — pod will not schedule if violated.
- **preferred**: soft rule — scheduler tries to satisfy but will schedule anyway if not possible.

## Part 4 — Backend scheduling and DB/cache connectivity

Q1: Backend pods scheduled where?

- On `worker-node-2` (requires `tier=backend`; prefers SSD but does not require it).

Q2: Required vs Preferred scheduling?

- **Required**: must satisfy, otherwise the pod will not schedule.
- **Preferred**: scheduler attempts to satisfy; weight indicates strength of preference.

Q3: Backend communicate with DB/cache?

- Yes — verified with `nslookup` and `curl` from a test pod.

## Part 5 — Frontend placement, scaling, and NodePort

Q1: Frontend pods scheduled where?

- On `worker-node-1` (matches `tier=frontend` and has the matching toleration).

Q2: Scale to 10 replicas on one node?

- Some pods go `Pending` due to insufficient resources on the single node.

Q3: NodePort traffic distribution?

- Traffic is handled by `kube-proxy` (iptables/ipvs). Distribution is effectively round-robin/random depending on mode.

Q4: Browser access works?

- Yes — `http://<NODE_IP>:30080` serves the frontend (example NodePort).

## Part 6 — Static pods and monitoring agent

Q1: Delete static pod result?

- The static pod is recreated by the kubelet if its manifest still exists on the node.

Q2: Actually remove static pod?

- Delete the manifest from `/etc/kubernetes/manifests/` on the node to permanently remove it.

Q3: Static pod appears where?

- In the `kube-system` namespace with a name like `monitoring-agent-<node-name>`.

Q4: Static pod use cases

- Control plane components
- Node-specific daemons
- Monitoring agents
- When the API server is unavailable

## Part 7 — Draining nodes and diagnosing broken deployments

Q1: Draining effect on pods?

- User pods are evicted and rescheduled; static pods are ignored by `kubectl drain`.

Q2: All pods rescheduled?

- No — static pods remain on the node (they are node-bound).

Q3: Static pod after drain?

- It remains on the node and may show `Terminating` if deletion is attempted.

Q4: Broken deployment issue?

- Fault: resource requests too high (example: `cpu: 5000m`, `memory: 10Gi`).

Q5: Diagnostic commands?

- `kubectl describe pod <pod-name>`
- `kubectl get events`

Q6: Fix for broken deployment?

- Reduce resource requests to realistic values (example: `cpu: 200m`, `memory: 256Mi`).

## Part 8 — Priority classes and preemption

Q1: High-priority pods need resources?

- Lower-priority pods are evicted (preempted) to make room for higher-priority pods.

Q2: Which pods evicted first?

- Pods with the lowest priority class are evicted first; QoS class and resource usage are also considered.

Q3: Priority effect on scheduling?

- Priority determines scheduling order and enables preemption for critical workloads.

## Part 10 — Architecture decisions

- **Taints/Tolerations:** workload isolation (dedicated frontend/backend nodes).
- **Anti-Affinity:** improves availability for stateful components like Redis.
- **Node Affinity:** optimizes placement for performance (SSD vs HDD preference).
- **Priority Classes:** protect critical workloads and allow preemption when needed.


