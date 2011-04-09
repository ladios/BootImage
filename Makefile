include config.mk
include version.mk

empty =
space = $(empty) $(empty)
comma = ,

version ?= $(empty)
ifneq ($(version), $(empty))
	version := -$(version)
endif

tmp = $(PWD)/tmp
out = $(PWD)/out
update.zip = $(out)/$(name)$(version).zip
unsigned.zip = $(out)/unsigned-$(name)$(version).zip

dirs = META-INF bootimg
updater-script = META-INF/com/google/android/updater-script

local_module_files = $(wildcard system/lib/modules/*.ko)
ifneq ($(local_module_files),)
    dirs += system
endif
module_files = $(foreach file,$(local_module_files),"/$(file)")
tag_delete_modules = \#\#\#DELETE_FILES\#\#\#
command_delete_modules = delete($(subst $(space),$(comma) ,$(module_files)));

$(update.zip) : clean $(unsigned.zip)
	java -classpath $(jar) testsign $(unsigned.zip) $(update.zip)
	rm -f $(unsigned.zip)
	@cd $(out) && md5sum $(notdir $(update.zip)) | tee $(update.zip).md5

$(updater-script) :
	cat updater-script.template \
| sed 's|$(tag_delete_modules)|$(command_delete_modules)|' \
> $(updater-script)

$(unsigned.zip) : $(updater-script)
	-mkdir -p $(tmp)
	-mkdir -p $(out)
	$(foreach dir,$(dirs),cp -pR $(dir) $(tmp)/;)
	cd $(tmp) && zip -r $(unsigned.zip) *

.PHONY : clean
clean :
	-rm -f $(updater-script)
	-rm -f $(unsigned.zip)
	-rm -f $(update.zip)
	-rm -f $(update.zip).md5
	-rm -rf $(tmp)

