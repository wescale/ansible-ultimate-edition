separator = "********************************************************************************"

.PHONY: prepare-debian
prepare-debian-desc = "Prepare a Debian-based Linux system for project operations"
prepare-debian:
	@echo ""
	@echo $(prepare-debian-desc)
	@echo $(separator)
	@sudo apt-get install direnv python3 python3-venv sshpass

header:
	@echo "************************ ANSIBLE ULTIMATE EDITION ******************************"
	@echo ""
	@echo $(separator)

.PHONY: prepare
prepare-desc = "Build local workspace environment"
log-file = "${PWD}/.direnv/make-prepare.log"
prepare: header
	@echo "==> $(prepare-desc)"
	@echo $(separator)

	@[ -d "${PWD}/.direnv" ] || (echo "Directory not found: ${PWD}/.direnv" && exit 1)
	@pip3 install -U pip wheel setuptools --no-cache-dir 2>&1 > $(log-file) &&\
	echo "[  OK  ] PIP + WHEEL + SETUPTOOLS" || \
	(echo "[FAILED] PIP + WHEEL + SETUPTOOLS" && echo "Full log: $(log-file)")
	
	@pip3 install -U --no-cache-dir -r ${PWD}/docs/requirements.txt 2>&1 >> $(log-file) &&\
	echo "[  OK  ] DOC REQUIREMENTS" || \
	(echo "[FAILED] DOC REQUIREMENTS" && echo "Full log: $(log-file)")

.PHONY: doc-desc
doc-desc = "==> Build project static html documentation"
doc:
	@echo $(doc-desc)
	@echo $(separator)
	@cd docs &&	make html
	@echo ""
	@echo $(separator)
	@echo "Static documentation exported:"
	@echo "  file://${PWD}/docs/build/html/index.html"
	@echo $(separator)


.PHONY: clean-doc-desc
clean-doc-desc = "==> Clean project static html documentation"
clean-doc:
	@echo $(clean-doc-desc)
	@echo $(separator)
	@cd docs && make clean

