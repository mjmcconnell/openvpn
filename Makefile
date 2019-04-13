COMPOSE_RUN = docker-compose run --rm

.PHONY: keygen.generate
keygen.generate:
	ssh-keygen -b 2048 -t rsa -f ./ubuntu -q -N ""

.PHONY: packer.validate
packer.validate:
	$(COMPOSE_RUN) packer validate packer/openvpn.json
	$(COMPOSE_RUN) packer validate packer/ubuntu.json

.PHONY: packer.build
packer.build: packer.validate
	$(COMPOSE_RUN) packer build -var-file=packer/secrets.json packer/openvpn.json
	$(COMPOSE_RUN) packer build -var-file=packer/secrets.json packer/ubuntu.json

.PHONY: packer.clean
packer.clean:
	rm manifest.openvpn.json
	rm manifest.ubuntu.json

.PHONY: terraform.set_packer_vars
terraform.set_packer_vars:
	sh ./scripts/set_terraform_vars.sh

.PHONY: terraform.init
terraform.init:
	$(COMPOSE_RUN) terraform init terraform

.PHONY: terraform.validate
terraform.validate:
	$(COMPOSE_RUN) terraform validate -check-variables=false terraform

.PHONY: terraform.apply
terraform.apply: terraform.set_packer_vars terraform.init
	$(COMPOSE_RUN) terraform apply -var-file="terraform/packer.tfvars" -var-file="terraform/secrets.tfvars" terraform

.PHONY: terraform.deploy
terraform.deploy: terraform.set_packer_vars terraform.init
	$(COMPOSE_RUN) terraform apply -auto-approve -var-file="terraform/packer.tfvars" -var-file="terraform/secrets.tfvars" terraform

.PHONY: terraform.destroy 
terraform.destroy:
	$(COMPOSE_RUN) terraform destroy -var-file="terraform/packer.tfvars" -var-file="terraform/secrets.tfvars" terraform
