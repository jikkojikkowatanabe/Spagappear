#!/usr/bin/env ruby -KU

require_relative '../const'

class Reader

  attr_accessor :result

  #
  # 初期化
  #
  # @param file: ファイルのPath
  #
  def initialize(file)
    @file = file
  end

  #
  # 実行
  #
  # @return 読み込みができているのであればCODE_VALIDが返る
  #
  def do
    begin
      File.open(@file) do | file |
        @result = file.read
      end
    end
  rescue SystemCallError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
    return CODE_ERROR
  rescue IOError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
    return CODE_ERROR
  end
  CODE_VALID
end