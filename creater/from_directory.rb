#!/usr/bin/env ruby -KU


require_relative '../base/creater'

class FromDir < BaseCreater

  #
  # 作成の実行
  #
  # @return : 作成に失敗した場合はCODE_ERRORが返る
  #
  def do

    # 言語と拡張子が同じファイルを全て取得
    files = get_files
    if files.empty?
      puts "#{@lang}に適応したファイルは指定されているPathにはないよ"
      return CODE_ERROR
    end

    # 取得できたファイルをloopし、ファイルを読み込んでいき、結果は変数に放り込む
    sources = []
    files.each do | file |
      # ファイルの読み込みの開始
      reader = Reader.new(file)
      if reader.do == CODE_ERROR
        return CODE_ERROR
      end
      sources.push(reader.result)
    end

    # 読み込んだファイル一覧をloopしてparseしていく
    sources.each do | source |
      puts source.split(/\n/)

      # ファイル内容のParse
      parser = Java.new(source)
      parser.do

      puts parser.resource
    end

    # 成功!!
    CODE_VALID
  end


  #
  # 指定されたPathから指定された言語拡張子のファイル一覧を取得
  #
  # @return : まともな場合はTrueが返る
  #
  private def get_files
    Dir.glob("#{@path}/**/*/*.#{@lang}")
  end

end