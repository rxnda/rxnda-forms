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

$(OUTPUT):
	mkdir -p $@

$(OUTPUT)/%.md: $(OUTPUT)/%.cform blanks.json | $(COMMONFORM) $(SPELL) $(OUTPUT)
	$(COMMONFORM) render --format markdown --title "RxNDA $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" --hash --blanks blanks.json < $< > $@

$(OUTPUT)/%.docx: $(OUTPUT)/%.cform $(OUTPUT)/%.signatures blanks.json | $(COMMONFORM) $(SPELL) $(OUTPUT)
	$(COMMONFORM) render --format docx --title "RxNDA $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" --hash --indent-margins --number outline --signatures $(OUTPUT)/$*.signatures --blanks blanks.json < $< > $@

$(OUTPUT)/%.cform: master.cftemplate $(OUTPUT)/%.options | $(CFTEMPLATE) $(OUTPUT)
	$(CFTEMPLATE) $< $(OUTPUT)/$*.options > $@

$(OUTPUT)/%.options: options-for-id.js | $(OUTPUT)
	./options-for-id.js $* > $@

$(OUTPUT)/%.json: $(OUTPUT)/%.cform | $(COMMONFORM) $(OUTPUT)
	$(COMMONFORM) render --format native < $< > $@

$(OUTPUT)/%.signatures: signatures-for-id.js | $(OUTPUT)
	./signatures-for-id.js $* > $@

.NOTPARALLEL: %.pdf

%.pdf: %.docx
	doc2pdf $<

$(COMMONFORM) $(CFTEMPLATE) $(SPELL):
	npm install

.PHONY: clean docker lint critique

lint: $(JSON) | $(COMMONFORM)
	for form in $(JSON); do echo $$form; $(COMMONFORM) lint < $$form; done | tee lint.log

critique: $(JSON) | $(COMMONFORM)
	for form in $(JSON); do echo $$form ; $(COMMONFORM) critique < $$form; done | tee critique.log

clean:
	rm -rf $(OUTPUT)

DOCKER_TAG=rxnda-forms

docker:
	docker build -t $(DOCKER_TAG) .
	docker run --name $(DOCKER_TAG) $(DOCKER_TAG)
	docker cp $(DOCKER_TAG):/workdir/$(OUTPUT) .
	docker rm $(DOCKER_TAG)
