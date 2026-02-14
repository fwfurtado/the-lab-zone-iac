.PHONY: kubeconfig

STACK       ?= platform
COMPONENT   ?= talos-cluster
KUBE_DIR    := $(HOME)/.kube
KUBE_CONFIG := $(KUBE_DIR)/config
TALOS_DIR    := $(HOME)/.talos
TALOS_CONFIG := $(TALOS_DIR)/config

kubeconfig:
	@CONTENT=$$(atmos terraform output talos-cluster -s platform --skip-init --logs-level Off --  -raw kubeconfig_raw); \
	mkdir -p "$(KUBE_DIR)"; \
	if [ ! -f "$(KUBE_CONFIG)" ]; then \
		echo "$$CONTENT" | yq eval '.' > "$(KUBE_CONFIG)"; \
	else \
		echo "$$CONTENT" | yq eval-all '. as $$item ireduce({}; . *+ $$item) | .clusters = (.clusters | unique_by(.name)) | .contexts = (.contexts | unique_by(.name)) | .users = (.users | unique_by(.name))' - "$(KUBE_CONFIG)" > "$(KUBE_CONFIG).tmp"; \
		mv "$(KUBE_CONFIG).tmp" "$(KUBE_CONFIG)"; \
	fi; \
	echo "Kubeconfig updated successfully."


talosconfig:
	@CONTENT=$$(atmos terraform output talos-cluster -s platform --skip-init --logs-level Off --  -raw talosconfig); \
	mkdir -p "$(TALOS_DIR)"; \
	echo "$$CONTENT" | yq eval '.' > "$(TALOS_CONFIG)"; \
	echo "Talosconfig updated successfully."
