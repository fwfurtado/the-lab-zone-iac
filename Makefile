.PHONY: kubeconfig talosconfig

STACK        ?= platform
COMPONENT    ?= talos-cluster
KUBE_DIR     := $(HOME)/.kube
KUBE_CONFIG  := $(KUBE_DIR)/config
TALOS_DIR    := $(HOME)/.talos
TALOS_CONFIG := $(TALOS_DIR)/config
OP_VAULT     := homelab

kubeconfig:
	@CONTENT=$$(atmos terraform output $(COMPONENT) -s $(STACK) --skip-init --logs-level Off --  -raw kubeconfig_raw); \
	FORMATTED=$$(echo "$$CONTENT" | yq eval '.'); \
	mkdir -p "$(KUBE_DIR)"; \
	if [ ! -f "$(KUBE_CONFIG)" ]; then \
		echo "$$FORMATTED" > "$(KUBE_CONFIG)"; \
	else \
		echo "$$FORMATTED" | yq eval-all '. as $$item ireduce({}; . *+ $$item) | .clusters = (.clusters | unique_by(.name)) | .contexts = (.contexts | unique_by(.name)) | .users = (.users | unique_by(.name))' - "$(KUBE_CONFIG)" > "$(KUBE_CONFIG).tmp"; \
		mv "$(KUBE_CONFIG).tmp" "$(KUBE_CONFIG)"; \
	fi; \
	if op document get "Talos $(STACK) kubeconfig" --vault "$(OP_VAULT)" > /dev/null 2>&1; then \
		echo "$$FORMATTED" | op document edit "Talos $(STACK) kubeconfig" --vault "$(OP_VAULT)" --file-name "$(STACK)-kubeconfig.yaml" -; \
	else \
		echo "$$FORMATTED" | op document create --vault "$(OP_VAULT)" --title "Talos $(STACK) kubeconfig" --file-name "$(STACK)-kubeconfig.yaml" -; \
	fi; \
	echo "Kubeconfig for $(STACK) updated successfully."

talosconfig:
	@CONTENT=$$(atmos terraform output $(COMPONENT) -s $(STACK) --skip-init --logs-level Off --  -raw talosconfig); \
	FORMATTED=$$(echo "$$CONTENT" | yq eval '.'); \
	mkdir -p "$(TALOS_DIR)"; \
	echo "$$FORMATTED" > "$(TALOS_CONFIG)"; \
	if op document get "Talos $(STACK) talosconfig" --vault "$(OP_VAULT)" > /dev/null 2>&1; then \
		echo "$$FORMATTED" | op document edit "Talos $(STACK) talosconfig" --vault "$(OP_VAULT)" --file-name "$(STACK)-talosconfig.yaml" -; \
	else \
		echo "$$FORMATTED" | op document create --vault "$(OP_VAULT)" --title "Talos $(STACK) talosconfig" --file-name "$(STACK)-talosconfig.yaml" -; \
	fi; \
	echo "Talosconfig for $(STACK) updated successfully."
