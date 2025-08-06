# Spring Boot Postgres - Helm & Kustomize Deployment

This project demonstrates a GitOps-style Continuous Integration (CI) pipeline for a **Spring Boot + PostgreSQL** application, leveraging:

	•	 Kustomize and Helm for Kubernetes manifests management
	•	 GitHub Actions for building, testing, tagging, and pushing images
	•	 DockerHub as the image registry

 The current focus is **CI only** — with clear automation of image updates through Git. **ArgoCD-based Continuous Deployment (CD)** will be implemented in the next stage.
---

##  Project Structure

```
.
├── app                          # Spring Boot application (Dockerized)
├── helm                        # Helm chart for production deployments
│   └── springboot-postgres-prod
│       ├── Chart.yaml
│       └── templates/...
├── kustomize                   # Kustomize overlays for different environments
│   ├── base
│   ├── overlays/
│   │   ├── dev
│   │   └── stage
├── .github/workflows           # CI pipelines for Kustomize & Helm
│   ├── helm-ci.yaml
│   └── kustomize-ci.yaml
└── dependabot.yaml             # Dependency automation
```

---

##  Deployment Strategies

###  Kustomize – For Development Environments
- Manages environment-specific configurations using overlays (`dev`, `stage`, etc.).
- Uses patch files (`patch-deployment-image.yaml`, etc.) to inject settings.
- CI builds Docker image and automatically updates Kustomize overlays with the new image tag.
- Image tag changes are pushed to a dedicated branch (`auto/kustomize-update`).

###  Helm – For Production
- Used for production-grade deployments with templated configuration.
- Helm chart located in `helm/springboot-postgres-prod`.
- CI builds and pushes Docker image on `main` branch updates.
- Image tag is updated in `values.yaml` and pushed to a separate branch (`auto/helm-update`).

---

##  Branching Strategy

### `main`
-  Protected branch for production.
- Triggers **Helm CI** on push.
- Only accepts Pull Requests.

### `development`
-  Integration branch.
- Triggers **Kustomize CI** on push.
- Represents the latest working state of development.

### `feature/*`
-  Feature development.
- Merged into `development`.

### `auto/kustomize-update`
-  Auto-managed branch.
- CI pushes updated image tags to `kustomize/overlays/dev/patch-deployment-image.yaml`.

### `auto/helm-update`
-  Auto-managed branch.
- CI pushes updated image tag to `helm/springboot-postgres-prod/values.yaml`.

---

##  CI/CD Overview

| Tool              | Purpose                                      | Trigger Branches         |
|-------------------|----------------------------------------------|---------------------------|
| `kustomize-ci.yaml` | Builds Docker image, updates dev overlay   | `feature/*`, `development`|
| `helm-ci.yaml`      | Builds Docker image, updates Helm chart    | `main`                    |

- Docker image is tagged as: `branchname-<shortsha>`, e.g., `feature-login-abc1234`.

---

##  Docker Image

- Docker image is built from `/app` and pushed to DockerHub.
- multi-stage build for efficient image size.
- Image tag is dynamically generated in CI.

---

##  Prerequisites

- GitHub PAT with `repo` scope (for pushing commits via Actions).
- DockerHub credentials stored in repository secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN`
- Git config secrets:
  - `GIT_USER_NAME`
  - `GIT_USER_EMAIL`
  - `GH_PAT` (used in CI for authenticated pushes)

---

##  Future Enhancements

- Add staging environment overlay in Kustomize.
- Implement CD using ArgoCD or Flux.
- Add unit and integration tests in CI.
- Add Helm chart versioning and publishing.

---

## Output screenshots

GitHub Actions CI Output
![alt text](/snapshots/image-2.png)


kubectl Get Pods
![alt text](/snapshots/image-1.png)

kubectl Describe Secret (from ESO)
![alt text](/snapshots/image.png)

Git Push to Auto Branch
![alt text](/snapshots/image-3.png)

DockerHUb
![alt text](/snapshots/image-4.png)