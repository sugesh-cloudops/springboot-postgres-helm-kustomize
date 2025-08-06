# Spring Boot Postgres - Helm & Kustomize Deployment

This project demonstrates a complete GitOps-style deployment of a Spring Boot + PostgreSQL application using **Helm**, **Kustomize**, and **GitHub Actions (CI)**.

---

##  Project Structure


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



 Deployment Strategies

 Kustomize – For Development Environments
	•	Manages environment-specific configurations using overlays (dev, stage, etc.).
	•	Uses patch files (patch-deployment-image.yaml, etc.) to inject settings.
	•	CI builds Docker image and automatically updates Kustomize overlays with the new image tag.
	•	Image tag changes are pushed to a dedicated branch (auto/kustomize-update).

 Helm – For Production
	•	Used for production-grade deployments with templated configuration.
	•	Helm chart located in helm/springboot-postgres-prod.
	•	CI builds and pushes Docker image on main branch updates.
	•	Image tag is updated in values.yaml and pushed to a separate branch (auto/helm-update).

⸻

 Branching Strategy

main
	•	Protected branch for production.
	•	Triggers Helm CI on push.
	•	Only accepts Pull Requests.

development
	•	Integration branch.
	•	Triggers Kustomize CI on push.
	•	Represents the latest working state of development.

feature/*
	•	Feature development.
	•	Merged into development.

auto/kustomize-update
	•	Auto-managed branch.
	•	CI pushes updated image tags to kustomize/overlays/dev/patch-deployment-image.yaml.

auto/helm-update
	•	Auto-managed branch.
	•	CI pushes updated image tag to helm/springboot-postgres-prod/values.yaml.

CI/CD Overview :


 Docker Image
	•	Docker image is built from /app and pushed to DockerHub.
	•	Image tag is dynamically generated in CI.

⸻

 Prerequisites
	•	GitHub PAT with repo scope (for pushing commits via Actions).
	•	DockerHub credentials stored in repository secrets:
	•	DOCKERHUB_USERNAME
	•	DOCKERHUB_TOKEN
	•	Git config secrets:
	•	GIT_USER_NAME
	•	GIT_USER_EMAIL
	•	GH_PAT (used in CI for authenticated pushes)

⸻

 Future Enhancements
	•	Add staging environment overlay in Kustomize.
	•	Implement CD using ArgoCD or Flux.
	•	Add unit and integration tests in CI.
	•	Add Helm chart versioning and publishing.