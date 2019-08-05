#!/usr/bin/env ruby -KU
#
#
#

# Code
CODE_VALID = 0
CODE_ERROR = 1


# 対応言語種類
LANG_JAVA = "java"
LANG_KOTLIN = "kotlin"
LANG_SWIFT = "swift"
LANG_OBJECTIVE_C = "objective_c"
LANG_PHP = "php"

# 言語仕様Key
INFO_KEY_INTERFACE = "interface"
INFO_KEY_CLASS = "class"
INFO_KEY_EXTEND = "extends"
INFO_KEY_PUBLIC = "public"
INFO_KEY_FUNC = "*()"
INFO_KEY_CALL = "*()"

# Java言語仕様Map
JAVA_INFO = {
  INFO_KEY_INTERFACE => "interface",
  INFO_KEY_CLASS => "class",
  INFO_KEY_EXTEND => "extends",
  INFO_KEY_PUBLIC => "public",
  INFO_KEY_FUNC => "*()",
  INFO_KEY_CALL => "*()",
}

# 言語仕様Map
LANG_INFO_MAP = {
    LANG_JAVA => JAVA_INFO
}