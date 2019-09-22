#!/usr/bin/env ruby -KU
#
#
#
#
#
require 'optparse'
require_relative 'creater/from_file'
require_relative 'creater/from_directory'

lang = ""
type = ""
path = ""
file = ""
output = ""

# 引数を取得して変数を書き換える
opt = OptionParser.new
opt.on('-l', '--lang [言語]', '依存図作成言語') do |val|
  if val != nil
    lang = val
  end
end
opt.on('-t', '--type [依存図作成タイプ]', 'F or Dで設定してね') do |val|
  if val != nil && (val == "F" or val == "D")
    type = val
  end
end
opt.on('-f', '--file [依存図作成ファイル]', '依存図作成ファイル') do |val|
  if val != nil
    file = val
  end
end
opt.on('-p', '--path [依存図作成Path]', '依存図作成Path') do |val|
  if val != nil
    path = val
  end
end
opt.on('-o', '--output [依存図作成先]', '依存図作成先') do |val|
  if val != nil
    output = val
  end
end
opt.parse(ARGV)

## 最低限の引数チェックをここで行う
if lang == ""
  # 言語が指定されていない
  puts "Not direct language"
  exit(CODE_ERROR)
elsif type == ""
  # タイプが指定されていない
  puts "Not direct type. you must direct XXX which -t XXX or --type XXX"
  exit(CODE_ERROR)
elsif type != "D" and type != "F"
  # タイプはTかF
  puts "Type must be T or F"
  exit(CODE_ERROR)
elsif file == "" and path == ""
  # ファイルかPathかで指定しな
  puts "file and path is empty. you must be direct file or path"
  exit(CODE_ERROR)
end

## タイプに応じてclassを生成し、そこで依存図の作成を開始する
if type == "F"
  # 単一Fileからの生成
  creater = FromFile.new(lang, file)
  exit(creater.do)
elsif type  == "D"
  # Directoryからの生成
  creater = FromDir.new(lang, path)
  exit(creater.do)
end

puts type
puts lang
puts path
puts file
