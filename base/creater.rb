#!/usr/bin/env ruby -KU
#
# 作成class base
#

require_relative '../function/reader'

class BaseCreater

  attr_accessor :result

  #
  # 初期化
  #
  # _lang_ : 依存図作成言語
  # _file_ : 依存図作成ファイル
  #
  def initialize( lang, file )
    @lang = lang
    @file = file
  end

  #
  # plant umlのテンプレートの取得
  #
  def get_template
    # 生成したClass図を書き込む全体図のテンプレートを取得
    unless File.exist?(CURRENT_DIR + "/template/overview.puml")
      puts "全体図のテンプレートがないよ！！"
      exit(CODE_ERROR)
    end

    # テンプレートから全体図となる物を取得する
    reader = Reader.new(CURRENT_DIR + "/template/overview.puml")
    if reader.do == CODE_ERROR
      exit(CODE_ERROR)
    end
    reader.result
  end

end