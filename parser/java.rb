#!/usr/bin/env ruby -KU

require_relative '../const'
require_relative '../base/parser'
require_relative '../data/resource'

class Java < Parser

  #
  # 初期化
  #
  # @param file_content: ファイルの内容
  # @param resource: 結果格納先
  #
  def initialize( file_content)
    @content = file_content
    @resource = Resource.new
  end

  #
  # Parse実行
  #
  # @return ParseできているのであればCODE_VALIDが返る
  #
  def do
    split = @content.split("\n")
    puts split
  end


end