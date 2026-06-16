# to-do-app — Deployment

This repository contains a dockerised to-do application (Express frontend, Flask backend). Infrastructure is provisioned with Terraform and the app is configured/deployed with Ansible. The deployment uses AWS (ECR/ECS/VPC) in the current setup; adjust provider and targets as needed.

## High-level flow

1. Provision infrastructure with Terraform (networking, compute, registry, load balancer).
2. Build and push container images to ECR (or other registry).
3. Configure servers / orchestrator and deploy app with Ansible.
4. Verify and monitor the running service.

## Prerequisites

- Git
- Terraform >= 1.0
- Ansible >= 2.9
- Docker (for local image build)
- AWS CLI configured or other cloud provider credentials
- SSH private key for server access
- Python 3.8+ (Ansible control host)

## Setup

1. Clone the repository and change to its root:

   git clone <repo-url>
   cd terraform-ansible-to-do-app-v3

2. Export cloud credentials and common vars (example AWS):

   export AWS_ACCESS_KEY_ID=...
   export AWS_SECRET_ACCESS_KEY=...
   export TF_VAR_region=us-east-1
   export SSH_PRIVATE_KEY=~/.ssh/id_rsa

## Terraform (provision)

1. Change to the Terraform directory (adjust if different):

   cd terraform

2. Initialize and preview changes:

   terraform init
   terraform plan -out=tfplan

3. Apply the plan:

   terraform apply "tfplan"

4. Save outputs for use in Ansible inventory or deployment scripts:

   terraform output -json > tf_outputs.json

Typical outputs: instance IPs, ECR repo URIs, load balancer DNS.

## Build & push images (if using ECR)

1. Build the images (root or docker/ folder):

   docker build -t todo-backend:TAG ./backend
   docker build -t todo-frontend:TAG ./frontend

2. Tag & push to ECR (replace <account>/<repo>):

   docker tag todo-backend:TAG <ecr-uri>/todo-backend:TAG
   docker push <ecr-uri>/todo-backend:TAG

Repeat for frontend.

## Ansible (configure & deploy)

1. Generate or prepare an inventory from Terraform outputs. Example static inventory (/tmp/inventory.ini):

   [app_servers]
   10.0.1.23 ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa

2. Run the playbook:

   cd ansible
   ansible-playbook -i /tmp/inventory.ini site.yml --private-key "$SSH_PRIVATE_KEY"

3. Useful flags:
   - -e "image_tag=TAG"
   - --limit to target hosts
   - -vv for verbose troubleshooting

## Verification

- Curl the load balancer or public IP: curl http://<lb-dns-or-ip>
- SSH to instance and inspect service (systemctl, docker ps, journalctl)
- Check Ansible's output for failed tasks

## Rollback / Teardown

- To remove infrastructure:

   cd terraform
   terraform destroy

- For application rollbacks, keep previous image tags and re-run Ansible with the older tag (e.g., -e "image_tag=previous-tag").

## CI/CD suggestions

- Store credentials in CI secrets (do not commit).
- Use Terraform remote state (S3 + DynamoDB) for team access.
- Automate inventory creation from terraform output and wire it into Ansible runs.

## Troubleshooting

- SSH failures: check security groups and your public IP in allowed rules.
- Terraform auth errors: verify provider credentials and region.
- Ansible task failures: run with -vv and inspect the failing task for details.

## Notes

- Paths and filenames in this README are examples; adapt to your repo structure (e.g., terraform/ vs infra/).
- Keep secrets out of version control; prefer environment variables or a secrets manager.

---

If you want repository-specific commands (exact paths, playbook names, or CI examples), provide the layout or permit me to read the repo and I will update this README accordingly.
