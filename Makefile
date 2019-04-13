COMPOSE_RUN = docker-compose run --rm

keygen.generate:
	ssh-keygen -b 2048 -t rsa -f ./ubuntu -q -N ""

packer.validate:
	$(COMPOSE_RUN) packer validate packer/openvpn.json
	$(COMPOSE_RUN) packer validate packer/ubuntu.json

packer.build: packer.validate
	$(COMPOSE_RUN) packer build -var-file=packer/secrets.json packer/openvpn.json
	$(COMPOSE_RUN) packer build -var-file=packer/secrets.json packer/ubuntu.json

packer.clean:
	rm manifest.openvpn.json
	rm manifest.ubuntu.json

terraform.set_packer_vars:
	sh ./scripts/set_terraform_vars.sh

terraform.init:
	$(COMPOSE_RUN) terraform init terraform

terraform.validate:
	$(COMPOSE_RUN) terraform validate -check-variables=false terraform

terraform.apply: terraform.set_packer_vars terraform.init
	$(COMPOSE_RUN) terraform apply -var-file="terraform/packer.tfvars" -var-file="terraform/secrets.tfvars" terraform

terraform.deploy: terraform.set_packer_vars terraform.init
	$(COMPOSE_RUN) terraform apply -auto-approve -var-file="terraform/packer.tfvars" -var-file="terraform/secrets.tfvars" terraform

terraform.destroy:
	$(COMPOSE_RUN) terraform destroy -var-file="terraform/packer.tfvars" -var-file="terraform/secrets.tfvars" terraform
