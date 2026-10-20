include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = catransaction

catransaction_OBJC_FILES = catransaction.m

ADDITIONAL_OBJCFLAGS += -Wall -g -O0 -std=gnu99 -fblocks
ADDITIONAL_CFLAGS += -Wall -g -O0 -std=gnu99
ADDITIONAL_LDFLAGS += -L../../Source/obj -L../../Source/QuartzCore.framework
ADDITIONAL_TOOL_LIBS =  -lgnustep-gui -lGL -lGLU -lopal -lQuartzCore

ADDITIONAL_INCLUDE_DIRS = -I../../Headers

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/tool.make
-include GNUmakefile.postamble
