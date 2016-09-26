# For building the murano package as a zip file

source_files = \
	manifest.yaml \
	Classes/Walma.yaml \
	Resources/Deploy.template \
	Resources/scripts/deploy.sh \
	UI/ui.yaml

compile=zip -r
RM=rm -f
CAT=cat
SED=sed
ECHO=echo "\n"

targets = DemoWalma.zip 

all: $(targets)
	-@$(ECHO) "*** Build complete"

DemoWalma.zip: $(source_files) 
	-@$(ECHO) "*** Building murano zip package"
	$(compile) $@ $^

.PHONY: clean
clean:
	-@$(ECHO) "*** Removing $(targets)"
	-@ $(RM) $(targets)


