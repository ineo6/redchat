MODULES = jailed
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RedChat
DISPLAY_NAME = RedChat
BUNDLE_ID = com.neo.SingleEmpty

SRC = $(wildcard src/*.m)

RedChat_FILES = $(wildcard src/*.m) src/Tweak.xm
RedChat_FRAMEWORKS = UIKit

RedChat_IPA = /Users/neo/WorkSpace/jailbreak/app/wc-6.5.7.ipa

include $(THEOS_MAKE_PATH)/tweak.mk
