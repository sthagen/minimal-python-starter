.DEFAULT_GOAL := all
isort = isort main.py test_main.py
black = black -S -l 120 --target-version py39 main.py test_main.py
pytest = pytest --asyncio-mode=strict --cov=main --cov-report term-missing:skip-covered --cov-branch --log-format="%(levelname)s %(message)s"

.PHONY: install
install:
	pip install -r test/requirements.txt

.PHONY: install-all
install-all: install
	pip install -r test/requirements-dev.txt

.PHONY: format
format:
	$(isort)
	$(black)

.PHONY: lint
lint:
	flake8 main.py test_main.py
	$(isort) --check-only --df
	$(black) --check --diff

.PHONY: mypy
mypy:
	mypy main.py test_main.py

.PHONY: test
test: clean
	$(pytest)

.PHONY: testcov
testcov: test
	@echo "building coverage html"
	@coverage html

.PHONY: all
all: lint mypy testcov

.PHONY: clean
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf .cache build htmlcov *.egg-info
	@rm -rf .benchmarks .hypothesis .*_cache
	@rm -f .coverage .coverage.* *.log .DS_Store


.PHONY: name
name:
	@printf "Release '%s'\n\n" "$$(git-release-name "$$(git rev-parse HEAD)")"
	@printf "%s revision.is(): sha1:%s\n" "-" "$$(git rev-parse HEAD)"
	@printf "%s name.derive(): '%s'\n" "-" "$$(git-release-name "$$(git rev-parse HEAD)")"

.PHONY: dlstats
dlstats:
	pypistats python_minor --json --monthly $(package) > etc/monthly-downloads.json
	rq '$$.data..*.downloads' etc/monthly-downloads.json | paste -sd+ - | bc
	jq . etc/monthly-downloads.json > etc/tempaway && mv etc/tempaway etc/monthly-downloads.json
