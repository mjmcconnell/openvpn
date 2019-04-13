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
