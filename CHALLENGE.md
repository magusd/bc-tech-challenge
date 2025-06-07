# Platform Engineering Code Challenge
This code challenge is for prospective Platform Engineering team members. The goal of this challenge is for candidates to show their ability to receive "loose" requirements, as we often do, and to follow through on implementing those requirements.

## The Challenge
As a Platform Engineer, I need to implement an API that increments a counter persisted in Redis. The endpoints of this API should be `/read` to show the current value, as well as a `/write` endpoint that increments the counter value stored in Redis. This API should be containerized, and written in the language you are most comfortable with. For added context, we primarily use Python or Golang for our services/heavy scripting needs.

We would like this API to be deployed to Kubernetes. Please show us the Kubernetes manifests you would use to deploy the app, as well as the Redis instance to a Kubernetes cluster (Minikube or Kind are fine).
Please also show how you would expose this service to the public internet.

Deliverables include:

1. Application Code
2. Dockerfile
3. Kubernetes Manifests required to deploy the app and dependencies from scratch.
4. Script that will deploy the code
5. Step-by-step instructions on running and configuring your project
6. Any additional files that are required for an operator to test this code challenge locally and in a real Kubernetes cluster


#### Additional Intructions
If time allows, please consider the following before submitting your challenge.
* Please consider security, good documentation practices, and scalability in this challenge
(Preference will be given to a service that looks like it could be ready to go for production with minimal, if any, tweaks)
* How would you scale your service to meet sudden increased demand?
* Does your documentation make it easy or difficult for a more junior engineer to make adjustments/changes to it?

Questions can be submitted via your recruiter. Thank you and good luck! 
