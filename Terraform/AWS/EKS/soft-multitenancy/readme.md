// Stesp: Apply LimitRange
// Go to /k8s/admin/Soft-Multetenancy/limit-range Folder and run, Note: apply if not applied in TF script
kubectl apply -f cpu-constraints.yaml --namespace=soft-multitenancy-check

// Want to check pods which are provisiong are blocked by the contraint applied at namespace level
kubectl apply -f cpu-constraints-pod.yaml --namespace=soft-multitenancy-check

// Expected Output: Error from server (Forbidden): error when creating "cpu-constraints-pod.yaml": pods "constraints-cpu-demo" is forbidden: maximum cpu usage per Container is 100m, but limit is 800M

// check applied request limit range
kubectl get pod constraints-cpu-demo --output=yaml --namespace=soft-multitenancy-check