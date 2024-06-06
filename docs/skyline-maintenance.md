# Skyline Maintenance

## Steps:

1. ### Remove Existing Deployment:
    ```
    kubectl delete deploy skyline -n openstack
    kubectl delete svc skyline -n openstack
    kubectl delete svc skyline-apiserver -n openstack
    kubectl delete hpa skyline-apiserver -n openstack
    ```

2. ### Update Skyline Image in Deployment Configuration:
    - Filepath: `/opt/genestack/kustomize/skyline/base/deployment-apiserver.yaml`
    - Replace the image for `skyline-apiserver` and `skyline-apiserver-db-migrate` containers with `ghcr.io/rackerlabs/skyline-rxt:master-ubuntu_jammy-1717659503`.

3. ### Deploy skyline:
    ```
    kubectl --namespace openstack apply -k /opt/genestack/kustomize/skyline/base
    ```

## Expected Output:
```
root@flex-skyline-dont-delete-node-0:~# kubectl get all -n openstack | grep skyline
pod/skyline-5ffffb4bc4-tvwzt                    1/1     Running     0             6h26m
service/skyline                    ClusterIP      10.233.51.108   <none>        80/TCP,443/TCP       6h26m
service/skyline-apiserver          ClusterIP      10.233.4.153    <none>        9999/TCP             6h26m
deployment.apps/skyline                  1/1     1            1           6h26m
replicaset.apps/skyline-5ffffb4bc4                  1         1         1       6h26m
horizontalpodautoscaler.autoscaling/skyline-apiserver   Deployment/skyline-apiserver   <unknown>/50%    3         9         0       6h26m

root@flex-skyline-dont-delete-node-0:~# kubectl get endpoints -n openstack | grep skyline
skyline                    10.233.64.44:443,10.233.64.45:443,10.233.84.123:443 + 3 more...         6h26m
skyline-apiserver          10.233.99.185:9999                                                      6h26m

root@flex-skyline-dont-delete-node-0:~# kubectl get ingress -n openstack | grep skyline
skyline          nginx   skyline,skyline.openstack,skyline.openstack.svc.cluster.local     172.31.1.181,172.31.1.26   80      20d
```
