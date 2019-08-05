#!/usr/bin/env ruby -KU
#
#

require_relative '../const'
require_relative '../function/reader'
require_relative '../parser/java'

#
#
#
class FromFile

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