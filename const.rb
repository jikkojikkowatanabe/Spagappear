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
INFO_KEY_PACKAGE = "INFO_KEY_PACKAGE"
INFO_KEY_IMPORT = "INFO_KEY_IMPORT"

## 言語仕様Key - class
INFO_KEY_CLASS = "INFO_KEY_CLASS"
INFO_KEY_CLASSING = "INFO_KEY_CLASSING"
INFO_KEY_CLASS_ATTR = "INFO_KEY_CLASS_ATTR"
INFO_KEY_CLASS_NAME = "INFO_KEY_CLASS_NAME"
INFO_KEY_CLASS_EXTEND = "INFO_KEY_CLASS_EXTEND"
INFO_KEY_CLASS_EXTENDING = "INFO_KEY_CLASS_EXTENDING"
INFO_KEY_CLASS_IMPLEMENTED = "INFO_KEY_CLASS_IMPLEMENTED"
INFO_KEY_CLASS_IMPLEMENTING = "INFO_KEY_CLASS_IMPLEMENTING"

## 言語仕様Key - interface
INFO_KEY_INTERFACE = ""
INFO_KEY_INTERFACING = ""
INFO_KEY_INTERFACE_ATTR = ""
INFO_KEY_INTERFACE_NAME = ""

## 言語仕様Key - num
INFO_KEY_NUM = "INFO_KEY_NUM"
INFO_KEY_NUM_ATTR = "INFO_KEY_NUM_ATTR"
INFO_KEY_NUM_IS_STATIC = "INFO_KEY_NUM_IS_STATIC"
INFO_KEY_NUM_IS_FINAL = "INFO_KEY_NUM_IS_FINAL"
INFO_KEY_NUM_TYPE = "INFO_KEY_TYPE"
INFO_KEY_NUM_NAME = "INFO_KEY_NAME"

## 言語仕様Key - constructor
INFO_KEY_CONSTRUCTOR = "INFO_KEY_CONSTRUCTOR"
INFO_KEY_CONSTRUCTOR_ATTR = "INFO_KEY_CONSTRUCTOR_ATTR"

## 言語仕様Key - function
INFO_KEY_FUNC_START = "INFO_KEY_FUNC_START"
INFO_KEY_FUNC_ATTR = "INFO_KEY_FUNC_ATTR"
INFO_KEY_FUNC_IS_OVERRIDE = "INFO_KEY_FUNC_IS_OVERRIDE"
INFO_KEY_FUNC_TYPE = "INFO_KEY_FUNC_TYPE"
INFO_KEY_FUNC_NAME = "INFO_KEY_FUNC_NAME"

## 言語仕様Key - Annotation
INFO_KEY_ANNOTATION = "INFO_KEY_IS_ANNOTATION"

## 言語仕様Key - if
INFO_KEY_IF_START = "INFO_KEY_IF_START"

# 言語仕様Key - block
INFO_KEY_IS_BLOCK_IN_LINE = "INFO_KEY_IS_BLOCK_IN_LINE"
INFO_KEY_IS_BLOCK_START = "INFO_KEY_IS_BLOCK_START"
INFO_KEY_IS_BLOCK_END = "INFO_KEY_IS_BLOCK_END"

INFO_KEY_EXTEND = "INFO_KEY_EXTEND"
INFO_KEY_PUBLIC = "INFO_KEY_PUBLIC"

INFO_KEY_CALL = "INFO_KEY_CALL"

# 言語仕様Key - accessor
INFO_KEY_ACCESSOR_PUBLIC = "INFO_KEY_ACCESSOR_PUBLIC"
INFO_KEY_ACCESSOR_PRIVATE = "INFO_KEY_ACCESSOR_PRIVATE"
INFO_KEY_ACCESSOR_PROTECTED = "INFO_KEY_ACCESSOR_PROTECTED"

# Block属性
BLOCK_ELEMENT_CLASS = "CLASS"
BLOCK_ELEMENT_INNER_CLASS = "INNER_CLASS_%s"
BLOCK_ELEMENT_FUNCTION = "FUNCTION"
BLOCK_ELEMENT_CONSTRUCTOR = "CONSTRUCTOR"
BLOCK_ELEMENT_OTHER = "OTHER"

# Java言語仕様Map
JAVA_INFO = {
    ## Common
    INFO_KEY_PACKAGE => "package",
    INFO_KEY_IMPORT => "import",
    INFO_KEY_INTERFACE => "interface",

    ## Interface
    INFO_KEY_INTERFACE => "\s*interface\s*[A-Za-z0-9]+\s*",
    INFO_KEY_INTERFACING => "\s*interface\s*",
    INFO_KEY_INTERFACE_ATTR => "\s*(public|protected|private)\s*",
    INFO_KEY_INTERFACE_NAME => "\s*interface\s*[A-Za-z0-9]+",

    ## Class
    INFO_KEY_CLASSING => "\s*class\s*",
    INFO_KEY_CLASS => "\s*class\s*[A-Za-z0-9]+\s*",
    INFO_KEY_CLASS_ATTR => "\s*(public|protected|private)\s*",
    INFO_KEY_CLASS_NAME => "\s*class\s*[A-Za-z0-9]+",
    INFO_KEY_CLASS_EXTENDING => "\s*extends\s*",
    INFO_KEY_CLASS_EXTEND => "\s*extends\s*[A-Za-z0-9]+",
    INFO_KEY_CLASS_IMPLEMENTING => "\s*implements\s*",
    INFO_KEY_CLASS_IMPLEMENTED => "\s*implements\s*[A-Za-z0-9]+",

    ## Num
    INFO_KEY_NUM => "\s*(private|public|protected|\s*)\s*(static|\s*)\s*(final|\s*)\s*[A-Za-z0-9]+\s*[A-Za-z0-9]+\s*",
    INFO_KEY_NUM_ATTR => "\s*(private|public|protected)\s*",
    INFO_KEY_NUM_IS_STATIC => "\s*static\s*",
    INFO_KEY_NUM_IS_FINAL => "\s*final\s*",
    INFO_KEY_NUM_TYPE => "\s*[A-Za-z0-9_\\-]+\s*",
    INFO_KEY_NUM_NAME => "\s*[A-Za-z0-9_\\-]+\s*",

    ## Func
    INFO_KEY_FUNC_START => "\s*(public|private|protected|\s*)\s*[A-Za-z0-9.]+\s*[A-Za-z0-9]+\\(.*\\)\s*(throws\s*.*|\s*)\s*{\s*",
    INFO_KEY_FUNC_ATTR => "\s*(public|protected|private)\s*",
    INFO_KEY_FUNC_TYPE => "\s*[A-Za-z0-9.]+\s*",
    INFO_KEY_FUNC_NAME => "\s*[A-Za-z0-9_\\-]+\s*",

    # Annotation
    INFO_KEY_ANNOTATION => "\s*\\@[A-Za-z0-9]+",

    ## if and for and while
    INFO_KEY_IF_START => "\s*if\s*\\(.*\\)\s*{",

    ##
    INFO_KEY_IS_BLOCK_IN_LINE => ".*{.*}.*",
    INFO_KEY_IS_BLOCK_START => "\s*{",
    INFO_KEY_IS_BLOCK_END => "}\s*",

    ##
    INFO_KEY_CALL => "*()",

    ## Accessor
    INFO_KEY_ACCESSOR_PUBLIC => "public",
    INFO_KEY_ACCESSOR_PRIVATE => "private",
    INFO_KEY_ACCESSOR_PROTECTED => "protected",
}

# 言語仕様Map
LANG_INFO_MAP = {
    LANG_JAVA => JAVA_INFO
}