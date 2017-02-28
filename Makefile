MODULES = jailed
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RedChat
DISPLAY_NAME = RedChat
BUNDLE_ID = com.neo.SingleEmpty

RedChat_FILES = Tweak.xm CBMessageHud.m CBNewestMsgManager.m
RedChat_FRAMEWORKS = UIKit

RedChat_IPA = /Users/neo/WorkSpace/jailbreak/app/wc-6.3.2.ipa

include $(THEOS_MAKE_PATH)/tweak.mk
