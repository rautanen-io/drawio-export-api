# Kubernetes Deployment

This directory contains Kubernetes manifests for deploying the drawio-export-api service.

## Prerequisites

- Kubernetes cluster
- `kubectl` configured to access your cluster
- Access to the Docker image at `docker.io/hirvi0/drawio-export-api`
- SSL certificates for HTTPS

## Deployment Steps

1. Create a namespace (optional, replace `<namespace>` with your desired namespace):
   ```bash
   kubectl create namespace <namespace>
   ```

2. Update the secrets:
   - Edit `secret.yaml` and replace:
     - `your-token-here` with your actual API token
     - `YOUR_BASE64_ENCODED_FULLCHAIN_PEM` with your base64 encoded fullchain.pem
     - `YOUR_BASE64_ENCODED_PRIVKEY_PEM` with your base64 encoded privkey.pem
   
   To encode your certificates:
   ```bash
   base64 -i nginx/certs/dev-fullchain.pem | tr -d '\n'
   base64 -i nginx/certs/dev-privkey.pem | tr -d '\n'
   ```

   Apply the secrets:
   ```bash
   kubectl apply -f secret.yaml -n <namespace>
   ```

3. (Optional) Customize nginx configuration:
   - Edit `nginx-config.yaml` to modify nginx settings

4. (Optional) Customize supervisor configuration:
   - Edit `supervisor-config.yaml` to modify supervisor settings

5. Deploy the service:
   ```bash
   # Apply all manifests
   kubectl apply -f . -n <namespace>
   
   # Or apply them individually
   kubectl apply -f deployment.yaml -n <namespace>
   kubectl apply -f service.yaml -n <namespace>
   ```

6. Verify the deployment:
   ```bash
   kubectl get pods -n <namespace>
   kubectl get services -n <namespace>
   ```

## Configuration

The deployment includes:
- A Deployment resource
- A ClusterIP Service exposing port 443
- Environment variables for Python path and API token
- Uses the `docker.io/hirvi0/drawio-export-api` Docker image from Docker Hub
- SSL certificates mounted from Kubernetes secrets
- A Secret resource for storing the API token and SSL certificates
- A ConfigMap for customizable nginx configuration

You can modify the resource limits and requests in `deployment.yaml` according to your needs.

## Customizing Nginx Configuration

The nginx configuration is stored in a ConfigMap and can be customized by editing `nginx-config.yaml`. After making changes to the configuration:

1. Apply the updated ConfigMap:
   ```bash
   kubectl apply -f nginx-config.yaml -n <namespace>
   ```

2. Restart the deployment to apply the changes:
   ```bash
   kubectl rollout restart deployment drawio-export-api -n <namespace>
   ```

## Customizing Supervisor.d Configuration

The supervisor configuration is used to manage the Uvicorn and Nginx processes. The configuration is stored in a ConfigMap defined in `supervisor-config.yaml`. You can customize the supervisor configuration by editing this file.


After making changes to the configuration:
```bash
kubectl apply -f supervisor-config.yaml -n <namespace>
kubectl rollout restart deployment drawio-export-api -n <namespace>
```
