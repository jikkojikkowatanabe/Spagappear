#!/usr/bin/env ruby -KU

require_relative '../const'

class Util

  #
  # pumlのAccessorをnumのaccessorによって決定し、それを返す
  #
  # @param lang : 言語
  # @param accessor : (変|定)数のアクセッサー
  #
  def self.gen_num_access(lang ,accessor)
    lang_info = LANG_INFO_MAP[lang]
    if accessor == lang_info[INFO_KEY_ACCESSOR_PUBLIC]
      return "+"
    end
    if accessor == lang_info[INFO_KEY_ACCESSOR_PRIVATE]
      return "-"
    end
    if accessor == lang_info[INFO_KEY_ACCESSOR_PROTECTED]
      return "#"
    end
    ""
  end




end