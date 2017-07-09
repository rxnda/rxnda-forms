COMMONFORM=node_modules/.bin/commonform
CFTEMPLATE=node_modules/.bin/cftemplate
OUTPUT=build

IDS=$(shell ./ids.js)
FORMS=$(basename $(IDS))
DOCX=$(addprefix $(OUTPUT)/,$(addsuffix .docx,$(FORMS)))
PDF=$(addprefix $(OUTPUT)/,$(addsuffix .pdf,$(FORMS)))
MD=$(addprefix $(OUTPUT)/,$(addsuffix .md,$(FORMS)))
JSON=$(addprefix $(OUTPUT)/,$(addsuffix .json,$(FORMS)))
TARGETS=$(DOCX) $(PDF) $(MD) $(JSON)

all: $(TARGETS)

$(OUTPUT):
	mkdir -p $@

$(OUTPUT)/%.md: $(OUTPUT)/%.cform blanks.json | $(COMMONFORM) $(OUTPUT)
	$(COMMONFORM) render --format markdown --title "$*" --blanks blanks.json < $< > $@

$(OUTPUT)/%.docx: $(OUTPUT)/%.cform $(OUTPUT)/%.signatures blanks.json | $(COMMONFORM) $(OUTPUT)
	$(COMMONFORM) render --format docx --title "$*" --number outline --signatures $(OUTPUT)/$*.signatures --blanks blanks.json < $< > $@

$(OUTPUT)/%.cform: master.cftemplate $(OUTPUT)/%.options | $(CFTEMPLATE) $(OUTPUT)
	$(CFTEMPLATE) $< $(OUTPUT)/$*.options > $@

$(OUTPUT)/%.options: | $(OUTPUT)
	./options-for-id.js $* > $@

$(OUTPUT)/%.json: $(OUTPUT)/%.cform | $(COMMONFORM) $(OUTPUT)
	$(COMMONFORM) render --format native < $< > $@

$(OUTPUT)/%-B2B.signatures: B2B.signatures.json | $(OUTPUT)
	cp $< $@

$(OUTPUT)/%-B2I.signatures: B2I.signatures.json | $(OUTPUT)
	cp $< $@

$(OUTPUT)/%-I2B.signatures: I2B.signatures.json | $(OUTPUT)
	cp $< $@

%.pdf: %.docx
	doc2pdf $<

$(COMMONFORM) $(CFTEMPLATE):
	npm install

.PHONY: clean docker

clean:
	rm -rf $(OUTPUT)

DOCKER_TAG=rxnda-forms

docker:
	docker build -t $(DOCKER_TAG) .
	docker run --name $(DOCKER_TAG) $(DOCKER_TAG)
	docker cp $(DOCKER_TAG):/workdir/$(OUTPUT) .
	docker rm $(DOCKER_TAG)
