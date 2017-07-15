COMMONFORM=node_modules/.bin/commonform
CFTEMPLATE=node_modules/.bin/cftemplate
SPELL=node_modules/.bin/reviewers-edition-spell
OUTPUT=build
GIT_TAG=$(strip $(shell git tag -l --points-at HEAD))
EDITION=$(if $(GIT_TAG),$(GIT_TAG),Development Draft)

IDS=$(shell ./ids.js)
FORMS=$(basename $(IDS))
DOCX=$(addprefix $(OUTPUT)/,$(addsuffix .docx,$(FORMS)))
PDF=$(addprefix $(OUTPUT)/,$(addsuffix .pdf,$(FORMS)))
MD=$(addprefix $(OUTPUT)/,$(addsuffix .md,$(FORMS)))
JSON=$(addprefix $(OUTPUT)/,$(addsuffix .json,$(FORMS)))
TARGETS=$(DOCX) $(PDF) $(MD) $(JSON)

all: docx pdf md json

docx: $(DOCX)

pdf: $(PDF)

md: $(MD)

json: $(JSON)

manifest: $(OUTPUT)/manifest.json

$(OUTPUT):
	mkdir -p $@

$(OUTPUT)/%.md: $(OUTPUT)/%.cform | $(COMMONFORM) $(SPELL) $(OUTPUT)
	$(COMMONFORM) render --format markdown --title "RxNDA $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" --hash < $< > $@

$(OUTPUT)/%.docx: $(OUTPUT)/%.cform $(OUTPUT)/%.signatures | $(COMMONFORM) $(SPELL) $(OUTPUT)
	$(COMMONFORM) render --format docx --title "RxNDA $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" --hash --indent-margins --number outline --signatures $(OUTPUT)/$*.signatures < $< > $@

$(OUTPUT)/%.cform: master.cftemplate $(OUTPUT)/%.options | $(CFTEMPLATE) $(OUTPUT)
	$(CFTEMPLATE) $< $(OUTPUT)/$*.options > $@

$(OUTPUT)/%.options: options-for-id.js | $(OUTPUT)
	./options-for-id.js $* > $@

$(OUTPUT)/%.json: $(OUTPUT)/%.cform | $(COMMONFORM) $(OUTPUT)
	$(COMMONFORM) render --format native < $< > $@

$(OUTPUT)/%.signatures: signatures-for-id.js | $(OUTPUT)
	./signatures-for-id.js $* > $@

$(OUTPUT)/manifest.json: $(JSON) build-manifest.js
	./build-manifest.js "$(EDITION)" > $@

.NOTPARALLEL: %.pdf

%.pdf: %.docx
	doc2pdf $<

$(COMMONFORM) $(CFTEMPLATE) $(SPELL):
	npm install

.PHONY: clean docker test lint critique

test: lint critique

lint: $(JSON) | $(COMMONFORM)
	for form in $(JSON); do $(COMMONFORM) lint < $$form | awk -v prefix="$$(basename $$form .json): " '{print prefix $$0}'; done | tee lint.log

critique: $(JSON) | $(COMMONFORM)
	for form in $(JSON); do $(COMMONFORM) critique < $$form | awk -v prefix="$$(basename $$form .json): " '{print prefix $$0}'; done | tee critique.log

clean:
	rm -rf $(OUTPUT)

DOCKER_TAG=rxnda-forms

docker:
	docker build -t $(DOCKER_TAG) .
	docker run --name $(DOCKER_TAG) $(DOCKER_TAG)
	docker cp $(DOCKER_TAG):/workdir/$(OUTPUT) .
	docker rm $(DOCKER_TAG)
