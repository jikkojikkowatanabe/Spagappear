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
    generate_files = []
    sources.each do | source |
      puts source.split(/\n/)

      # ファイル内容のParse
      parser = Java.new(source)
      parser.do

      # plant umlの生成の開始
      modeler = Modeling.new(@lang ,parser.resource)
      generate_file = modeler.do
      generate_files.push(generate_file)
    end

    # templateを取得
    over_view = get_template

    # 全体図に生成したClass図を書き込む
    over_view.gsub!("$CLASS$", generate_files.join("\n\n\n"))

    # 結果を格納
    @result = over_view

    # 成功!!
    CODE_VALID
  end


  #
  # 指定されたPathから指定された言語拡張子のファイル一覧を取得
  #
  # @return : まともな場合はTrueが返る
  #
  private def get_files
    Dir.glob("#{@file}/**/*.#{@lang}")
  end

end