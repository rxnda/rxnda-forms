COMMONFORM=node_modules/.bin/commonform
CFTEMPLATE=node_modules/.bin/cftemplate
SPELL=node_modules/.bin/reviewers-edition-spell
OUTPUT=build
GIT_TAG=$(strip $(shell git tag -l --points-at HEAD))
EDITION=$(if $(GIT_TAG),$(GIT_TAG),Development Draft)
BLANK="______________________________"

IDS=$(shell ./ids.js)
FORMS=$(basename $(IDS))
DOCX=$(addprefix $(OUTPUT)/,$(addsuffix .docx,$(FORMS)))
PDF=$(addprefix $(OUTPUT)/,$(addsuffix .pdf,$(FORMS)))
MD=$(addprefix $(OUTPUT)/,$(addsuffix .md,$(FORMS)))
JSON=$(addprefix $(OUTPUT)/,$(addsuffix .json,$(FORMS)))
HTML=$(addprefix $(OUTPUT)/,$(addsuffix .html,$(FORMS)))
TARGETS=$(DOCX) $(PDF) $(MD) $(JSON)

all: docx pdf md json html

docx: $(DOCX)

pdf: $(PDF)

md: $(MD)

json: $(JSON)

html: $(HTML)

manifest: $(OUTPUT)/manifest.json

.PHONY: google-drive

google-drive: $(addprefix $(OUTPUT)/google-drive/,$(addsuffix .docx,$(FORMS)))

$(OUTPUT) $(OUTPUT)/google-drive:
	mkdir -p $@

$(OUTPUT)/%.md: $(OUTPUT)/%.cform | $(COMMONFORM) $(SPELL) $(OUTPUT)
	$(COMMONFORM) render --format markdown --title "RxNDA Form $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" < $< > $@

$(OUTPUT)/%.html: $(OUTPUT)/%.cform header.html | $(COMMONFORM) $(SPELL) $(OUTPUT)
	cat header.html | sed 's!TITLE!RxNDA Form $*!' | sed 's!EDITION!$(shell echo "$(EDITION)" | $(SPELL))!' > $@
	$(COMMONFORM) render --format html5 --title "RxNDA Form $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" < $< >> $@
	echo '</body></html>' >> $@

$(OUTPUT)/%.docx: $(OUTPUT)/%.cform $(OUTPUT)/%.signatures | $(COMMONFORM) $(SPELL) $(OUTPUT)
	$(COMMONFORM) render --format docx --blank-text "$(BLANK)" --title "RxNDA Form $*" --edition "$(shell echo "$(EDITION)" | $(SPELL))" --indent-margins --number outline --signatures $(OUTPUT)/$*.signatures < $< > $@

$(OUTPUT)/%.cform: master.cftemplate $(OUTPUT)/%.options | $(CFTEMPLATE) $(OUTPUT)
ifeq ($(EDITION),Development Draft)
	$(CFTEMPLATE) $< $(OUTPUT)/$*.options | sed "s!PUBLICATION!This is a development draft of RxNDA Form $*.!" > $@
else
	$(CFTEMPLATE) $< $(OUTPUT)/$*.options | sed "s!PUBLICATION!RxNDA LLC published this form as RxNDA Form $*, $(shell echo "$(EDITION)" | $(SPELL)).!" > $@
endif

$(OUTPUT)/%.options: options-for-id.js | $(OUTPUT)
	./options-for-id.js $* > $@

$(OUTPUT)/%.json: $(OUTPUT)/%.cform | $(COMMONFORM) $(OUTPUT)
	$(COMMONFORM) render --format native < $< > $@

$(OUTPUT)/%.signatures: signatures-for-id.js | $(OUTPUT)
	./signatures-for-id.js $* > $@

$(OUTPUT)/manifest.json: $(JSON) build-manifest.js
	./build-manifest.js "$(EDITION)" > $@

$(OUTPUT)/google-drive/%.docx: $(OUTPUT)/%.docx | $(OUTPUT)/google-drive
	cp $< $@

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
