#!/usr/bin/env ruby -KU
#
#

require_relative '../base/creater'
require_relative '../const'
require_relative '../function/reader'
require_relative '../parser/java'
require_relative '../plant_uml/modeling'
require 'fileutils'

#
#
#
class FromFile < BaseCreater

  #
  # 作成の実行
  #
  # @return : 作成に失敗した場合はCODE_ERRORが返る
  #
  def do

    # 実行する前にまともどうかのチェック
    if validate == CODE_ERROR
      return CODE_ERROR
    end

    # ファイルの読み込みの開始
    reader = Reader.new(@file)
    if reader.do == CODE_ERROR
      return CODE_ERROR
    end

    # ファイル内容のParse
    parser = Java.new(reader.result)
    parser.do

    # plant umlの生成の開始
    modeler = Modeling.new(@lang ,parser.resource)
    generate_file = modeler.do

    # templateを取得
    over_view = get_template

    # 全体図に生成したClass図を書き込む
    over_view.gsub!("$CLASS$", generate_file)

    # 結果を格納
    @result = over_view

    # 成功!!
    CODE_VALID
  end


  #
  # メンバー変数がまともかどうか
  #
  # @return : まともな場合はTrueが返る
  #
  private def validate()
    # .で分割し、拡張子がlangと一緒であるかを確認する
    split_file = @file.split(".")
    if split_file.count < 2
      puts "file is invalid, file extension is not found"
      return CODE_ERROR
    end
    if split_file[1] != @lang
      puts "file is invalid, you input #{@lang}, but file extension is #{split_file[1]}"
      return CODE_ERROR
    end

    CODE_VALID
  end

end