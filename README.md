# BlueCore Counter

# Development

This project runs locally using compose, to get started run:

```bash
docker compose up -d
``` 

- This will start the application on http://localhost:3000
- Docs are available at http://localhost:3000/docs
- App restarts automatically on code changes

# Testing

Read current counter:
```
curl -v http://127.0.0.1:3000/read
```

Increment counter:
```
curl -XPOST -v http://127.0.0.1:3000/write
```

Port-forward the app to your local machine:
```
kubectl port-forward svc/bluecore-counter 3000:3000
```

# Deploy

Before deploying, make sure you have the CR_USER and CR_PASS env variable set your container registry.
You can use a custom CR if you also set the CR_HOST variable.

You can generate a PAT (Personal Access Token) for your Docker account at https://app.docker.com/settings/personal-access-tokens

```bash
export CR_USER=${CR_USER:-"unclelobs"}
export CR_HOST=${CR_HOST:-"https://index.docker.io/v1/"}
export CR_PASS="YOUR DOCKER PAT"
```

Once you're all set and you have your kubeconfig set up, you can deploy the app with:

```bash
./cicd.sh
```
This script will:
- login to your container registry
- build the image
- push the image to your container registry
- deploy the app to your kubernetes cluster
    - create the namespace
    - create the CR secrets
    - deploy the app and it's dependencies using helm