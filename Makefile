export SERVICE = docker-service
export CONTAINER = $(SERVICE)
export DESCRIPTION = A service to provide interface to the docker container <CONTAINER>

export TEMPLATE = docker-service-init

export OUTPUTDIR = build/
export OUTPUT = $(OUTPUTDIR)$(SERVICE)

INSTALLDIR = /etc/init.d/
INSTALL = $(INSTALLDIR)$(SERVICE)

SCRIPT_DIR =

export	PRE_START_SCRIPT		= $(SCRIPT_DIR)PRE_START
export POST_START_SCRIPT		= $(SCRIPT_DIR)POST_START
export	PRE_STOP_SCRIPT			= $(SCRIPT_DIR)PRE_STOP
export POST_STOP_SCRIPT			= $(SCRIPT_DIR)POST_STOP
export	PRE_RESTART_SCRIPT	= $(SCRIPT_DIR)PRE_RESTART
export POST_RESTART_SCRIPT	= $(SCRIPT_DIR)POST_RESTART
export	PRE_PAUSE_SCRIPT		= $(SCRIPT_DIR)PRE_PAUSE
export POST_PAUSE_SCRIPT		= $(SCRIPT_DIR)POST_PAUSE
export	PRE_UNPAUSE_SCRIPT	= $(SCRIPT_DIR)PRE_UNPAUSE
export POST_UNPAUSE_SCRIPT	= $(SCRIPT_DIR)POST_UNPAUSE

SCRIPTS = $(PRE_START_SCRIPT) $(POST_START_SCRIPT) $(PRE_STOP_SCRIPT) $(POST_STOP_SCRIPT) $(PRE_RESTART_SCRIPT) $(POST_RESTART_SCRIPT) $(PRE_PAUSE_SCRIPT) $(POST_PAUSE_SCRIPT) $(PRE_UNPAUSE_SCRIPT) $(POST_UNPAUSE_SCRIPT)

$(OUTPUT) : $(OUTPUTDIR) $(TEMPLATE) subs.sh
	cp $(TEMPLATE) $@
	bash subs.sh

$(OUTPUTDIR) :
	mkdir -p $@

$(INSTALLDIR) :
	mkdir -p $@

$(INSTALL) : $(OUTPUT) $(INSTALLDIR)
	cp $(OUTPUT) $@

ifneq ($(SCRIPT_DIR),)
$(SCRIPT_DIR) :
	mkdir -p $(SCRIPT_DIR)
endif

$(PRE_START_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(POST_START_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(PRE_STOP_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(POST_STOP_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(PRE_RESTART_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(POST_RESTART_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(PRE_PAUSE_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(POST_PAUSE_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(PRE_UNPAUSE_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

$(POST_UNPAUSE_SCRIPT) : $(SCRIPT_DIR)
	echo "# $@ CONTENT" > $@

.PHONY : START_SCRIPTS STOP_SCRIPTS RESTART_SCRIPTS PAUSE_SCRIPTS UNPAUSE_SCRIPTS

START_SCRIPTS : $(PRE_START_SCRIPT) $(POST_START_SCRIPT)

STOP_SCRIPTS : $(PRE_STOP_SCRIPT) $(POST_STOP_SCRIPT)

RESTART_SCRIPTS : $(PRE_RESTART_SCRIPT) $(POST_RESTART_SCRIPT)

PAUSE_SCRIPTS : $(PRE_PAUSE_SCRIPT) $(POST_PAUSE_SCRIPT)

UNPAUSE_SCRIPTS : $(PRE_UNPAUSE_SCRIPT) $(POST_UNPAUSE_SCRIPT)

.PHONY : scripts clean_scripts generate install enable disable uninstall clean

scripts : START_SCRIPTS STOP_SCRIPTS RESTART_SCRIPTS PAUSE_SCRIPTS UNPAUSE_SCRIPTS

clean_scripts :
	rm -f $(SCRIPTS)

generate : $(OUTPUT)

install : $(INSTALL)

enable : install
	update-rc.d $(SERVICE) defaults

disable : $(INSTALL)
	update-rc.d -f $(SERVICE) remove

uninstall : disable
	rm $(INSTALL)

clean :
	rm -r $(OUTPUTDIR)
