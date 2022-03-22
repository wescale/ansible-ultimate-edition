separator = "********************************************************************************"

.PHONY: prepare-debian
prepare-debian-desc = "Prepare a Debian-based Linux system for project operations"
prepare-debian:
	@echo ""
	@echo $(prepare-debian-desc)
	@echo $(separator)
	@sudo apt-get install direnv python3 python3-venv sshpass

header:
	@[ -n "${AUE_WORKSPACE}" ] || (echo "Please set the AUE_WORKSPACE environment variable." && exit 1)
	@echo "**************************** HASHISTACK PROJECT ********************************"
	@echo ""
	@echo "CURRENT HASHISTACK WORKSPACE => ${AUE_WORKSPACE}"
	@echo ""
	@echo $(separator)

header-env:
	@echo "**************************** HASHISTACK PROJECT ********************************"
	@echo ""
	@echo $(separator)

.PHONY: env
env-desc = "Build local workspace environment"
env: header-env
	@echo ""
	@echo $(separator)
	@echo "==> $(env-desc)"
	@echo $(separator)
	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  OK  ] PIP3" || \
	echo "[FAILED] PIP3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  OK  ] WHEEL" || \
	echo "[FAILED] WHEEL"

	@pip3 install -U setuptools --no-cache-dir --quiet &&\
	echo "[  OK  ] SETUPTOOLS" || \
	echo "[FAILED] SETUPTOOLS"

	@pip3 install -U --no-cache-dir --quiet -r ${PWD}/requirements.txt &&\
	echo "[  OK  ] REQUIREMENTS" || \
	echo "[FAILED] REQUIREMENTS"
	
	@pip3 install -U --no-cache-dir --quiet -r ${PWD}/docs/requirements.txt &&\
	echo "[  OK  ] DOC REQUIREMENTS" || \
	echo "[FAILED] DOC REQUIREMENTS"

	@echo ""
	@echo "************************* IMPORT EXTERNAL ANSIBLE ROLES ************************"
	ansible-galaxy collection install -fr requirements.yml


.PHONY: doc-desc
doc-desc = "Build project static html documentation"
doc:
	@echo ""
	@echo $(doc-desc)
	@echo $(separator)
	@cd docs &&	make html
	@echo $(separator)
	@echo "Static documentation exported:"
	@echo "  file://${PWD}/docs/build/html/index.html"
	@echo $(separator)


.PHONY: clean-doc-desc
clean-doc-desc = "Clean project static html documentation"
clean-doc:
	@echo ""
	@echo $(clean-doc-desc)
	@echo $(separator)
	@cd docs && make clean

