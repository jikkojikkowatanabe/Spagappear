#!/usr/bin/env ruby -KU

require_relative '../const'
require_relative '../base/parser'
require_relative '../data/resource'
require_relative '../data/clazz'
require_relative '../data/num'
require_relative '../data/function'
require_relative 'util'

class Java < Parser

  attr_accessor :resource

  # <editor-fold desc="定数">

  JAVA_INFO = LANG_INFO_MAP[LANG_JAVA]

  # </editor-fold>

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  # @param file_content: ファイルの内容
  #
  def initialize( file_content)
    @content = file_content
    @resource = Resource.new
  end

  # </editor-fold>

  # <editor-fold desc="実行系">

  #
  # Parse実行
  #
  # @return ParseできているのであればCODE_VALIDが返る
  #
  def do

    is_commenting = false
    parsing_classes = []
    parsing_function = nil
    block_elements = []
    is_functioning = false

    @content.split(/\n/).each do | line |

      puts line

      # から行の場合は無視
      next if line == ""

      # コメント行の場合は次
      next if is_comment(line)

      # コメントの始まりかを取得する 始まりの場合はflagをあげて次
      if is_start_comment(line)
        is_commenting = true
        next
      end

      # コメントの終わりかを取得する 終わりの場合はflagを下げて次
      if is_end_comment(line)
        is_commenting = false
        next
      end

      # コメント中の場合は次
      next if is_commenting

      # packageの行である場合はresourceにpackageをセットする
      if is_package(line)
        package = get_package(line)
        @resource.set_package(package)
        next
      end

      # importの行である場合はresourceにimportをセットする
      if is_import(line)
        import = get_import(line)
        @resource.add_import(import)
        next
      end

      # classの始まりの行である場合は、処理が二つのパターンに分けられる
      # 現在がclassの読み取り中でない場合はclass中であることにし、読み取り中classをセットする
      # 現在がclassの読み取り中である場合はinner_class中であることにし、読み取り中classにinner_classとしてセットする
      if is_class(line)

        # 現在がclassの読み取り中である場合はclass中であることにし、読み取り中classをセットする
        if block_elements.include?(BLOCK_ELEMENT_CLASS)
          inner_clazz = get_class(line)
          inner_class_label = sprintf(BLOCK_ELEMENT_INNER_CLASS, inner_clazz.name)

          block_elements.push(inner_class_label)
          parsing_classes.push(inner_clazz)
          next
        end

        # 現在がclassの読み取り中でない場合はinner_class中であることにし、読み取り中classにinner_classとしてセットする
        block_elements.push(BLOCK_ELEMENT_CLASS)
        parsing_classes.push(get_class(line))
        next
      end

      # parsing classの最後(現在読み取り中であるもの) に (変|定)数をセットする
      if is_num(line) and !is_block_start(line) and !block_elements.include?(BLOCK_ELEMENT_FUNCTION) and block_elements.include?(BLOCK_ELEMENT_CLASS)
        # parsing classの最後(現在読み取り中であるもの) に (変|定)数をセットする
        parsing_classes.last.add_num(get_num(line))
        next
      end

      # functionの始まりの行である場合はfunction中のフラグをあげ、読み取り中classをセットする
      if is_start_function(line) and !is_if_start(line)
        block_elements.push(BLOCK_ELEMENT_FUNCTION)
        parsing_function = get_function(line)
        is_functioning = true
        next
      end

      # 単一LineのBlockであるかを確認
      is_block_in_line = is_block_in_line(line)

      # blockの始まりの行である場合はBlock情報配列にBlock情報をセットする
      if is_block_start(line) and !is_block_in_line
        block_elements.push(BLOCK_ELEMENT_OTHER)
      end

      # blockの終わりの行である場合は以下のように処理が別れる
      # 保持しているBlock情報体配列の最後の情報体がClassとFunctionのものでない
      #   -> Block情報体配列の最後から削除
      # 保持しているBlock情報体配列の最後の情報体がInnerClassである
      #   -> Block情報体配列の最後から該当Classのものを削除し、なおかつパースしているclass配列からも取り除き、
      #      これをclass配列の最後のものとして追加する
      # 保持しているBlock情報体配列の最後の情報体がClassである
      #   -> Block情報体配列の最後から該当Classのものを削除し、なおかつパースしているclass配列からも取り除き、
      #      これをResourceのClassとして登録する
      # 保持しているBlock情報体配列の最後の情報体がFunctionである
      #   -> パースしているclass配列の最後のものとして追加する
      if is_block_end(line) and !is_block_in_line
        # 保持しているBlock情報体配列の最後の情報体がClassとFunctionのものでない
        if block_elements.last == BLOCK_ELEMENT_OTHER
          block_elements.pop

        # 保持しているBlock情報体配列の最後の情報体がInnerClassである
        elsif block_elements.last.match(/INNER_CLASS_(\w)/)
          block_elements.pop
          parsed_class = parsing_classes.pop
          parsing_classes.last.add_inner_class(parsed_class)

        # 保持しているBlock情報体配列の最後の情報体がClassである
        elsif block_elements.last == BLOCK_ELEMENT_CLASS
          block_elements.pop
          parsed_class = parsing_classes.pop
          @resource.add_class(parsed_class)

        # 保持しているBlock情報体配列の最後の情報体がFunctionである
        elsif block_elements.last == BLOCK_ELEMENT_FUNCTION
          block_elements.pop
          parsing_classes.last.add_function(parsing_function)
          parsing_function = nil
          is_functioning = false
        end
      end

      # function中の行である
      if is_functioning
        parsing_function.add_line(line)
      end

    end
    @resource

  end

  # </editor-fold>


  # <editor-fold desc="コメント系">

  #
  # コメント行かを取得する
  #
  # @param line : 行の文字列
  # @return : そうである場合はTrue
  #
  private def is_comment(line)
    line.match(/^(\s*)\/\//) != nil
  end

  #
  # コメントの始まりの行かを取得する
  #
  # @param line : 行の文字列
  # @return : そうである場合はTrue
  #
  private def is_start_comment(line)
    line.match(/^(\s*)\/\*/) != nil
  end

  #
  # コメントの終わりの行かを取得する
  #
  # @param line : 行の文字列
  # @return : そうである場合はTrue
  #
  private def is_end_comment(line)
    line.match(/^(\s*)\*\//) != nil
  end

  # </editor-fold>

  # <editor-fold desc="Package系">

  #
  # packageの行かを取得する
  #
  # @param line : 行の文字列
  # @return : そうである場合はTrue
  #
  private def is_package(line)
    package = JAVA_INFO[INFO_KEY_PACKAGE]
    line.match(/^(\s*)#{package}(\s*)[a-zA-z0-9]/) != nil
  end

  #
  # 行の文字列からpackageを取得する
  #
  # @param line : 取得する文字列
  # @return Package
  #
  private def get_package(line)
    package = JAVA_INFO[INFO_KEY_PACKAGE]
    line.gsub!(/^(\s*)#{package}(\s*)/, "")
    line.gsub!(";", "")
  end

  # </editor-fold>

  # <editor-fold desc="import系">

  #
  # importの行かを取得する
  #
  # @param line : 行の文字列
  # @return : そうである場合はTrue
  #
  private def is_import(line)
    import = JAVA_INFO[INFO_KEY_IMPORT]
    line.match(/^(\s*)#{import}(\s*)[a-zA-z0-9]/) != nil
  end

  #
  # 行の文字列からimportを取得する
  #
  # @param line
  # @return : importの文字列
  #
  private def get_import(line)
    import = JAVA_INFO[INFO_KEY_IMPORT]
    line.gsub!(/^(\s*)#{import}(\s*)/, "")
    line.gsub!(";", "")
  end

  # </editor-fold>

  # <editor-fold desc="Class系">

  #
  # 行の文字列からclassの行かを取得する
  #
  # @param line : 行の文字列
  #
  private def is_class(line)
    clazz = JAVA_INFO[INFO_KEY_CLASS]
    line.match(/#{clazz}/) != nil
  end

  #
  # 行の文字列からclassの属性と名前と取得し、RubyClassの形に変換して、返す
  #
  # @param line : 行の文字列
  #
  private def get_class(line)
    # 言語仕様を取得
    info_clazz_key = JAVA_INFO[INFO_KEY_CLASSING]
    info_clazz_attr = JAVA_INFO[INFO_KEY_CLASS_ATTR]
    info_clazz_name = JAVA_INFO[INFO_KEY_CLASS_NAME]
    info_clazz_extension = JAVA_INFO[INFO_KEY_CLASS_EXTEND]
    info_clazz_extension_key = JAVA_INFO[INFO_KEY_CLASS_EXTENDING]
    info_clazz_implement = JAVA_INFO[INFO_KEY_CLASS_IMPLEMENTED]
    info_clazz_implement_key = JAVA_INFO[INFO_KEY_CLASS_IMPLEMENTING]

    # 修飾詩を取得 行から削除
    attr_scan = line.scan(/#{info_clazz_attr}/)
    unless attr_scan.nil?
      if attr_scan[0].nil?
        # accessが定義されていないのは全てpublicとみなす
        attr = "public"
      else
        attr = attr_scan[0][0]
        line.sub!(/#{info_clazz_attr}/, "")
      end
    end

    # Class名の取得 行から削除
    name_scan = line.scan(/#{info_clazz_name}/)
    unless name_scan.nil?
      scaned_name = name_scan[0]
      name = scaned_name.gsub!(/#{info_clazz_key}/, "")
      line.sub!(/#{info_clazz_name}/, "")
    end

    # 親Class名の取得　取得後は記述を削除
    extend_scan = line.scan(/#{info_clazz_extension}/)
    unless extend_scan.empty?
      scaned_extend = extend_scan[0]
      extend = scaned_extend.gsub!(/#{info_clazz_extension_key}/, "")
      line.sub!(/#{info_clazz_extension}/, "")
    end

    # 実装しているinterfaceの取得 取得後は行から削除
    implement_scan = line.scan(/#{info_clazz_implement}/)
    unless implement_scan.empty?
      scaned_implement = implement_scan[0]
      implement = scaned_implement.gsub!(/#{info_clazz_implement_key}/, "")
      line.sub!(/#{info_clazz_implement}/, "")
    end

    # classの生成を行い、返す
    Clazz.new(name, attr, extend, implement)
  end

  # </editor-fold>

  # <editor-fold desc="Constructor系">

  #
  # 行の文字列からconstructorの行かを取得する
  #
  #

  # </editor-fold>

  # <editor-fold desc="Num系">

  #
  # 行の文字列から(定|変)数の行かを取得する
  #
  def is_num(line)
    num = JAVA_INFO[INFO_KEY_NUM]
    line.match(/#{num}/) != nil
  end

  #
  # 行の文字列から(定|変)数を取得する
  #
  def get_num(line)
    info_num_attr = JAVA_INFO[INFO_KEY_NUM_ATTR]
    info_num_is_static = JAVA_INFO[INFO_KEY_NUM_IS_STATIC]
    info_num_is_final = JAVA_INFO[INFO_KEY_NUM_IS_FINAL]
    info_num_type = JAVA_INFO[INFO_KEY_NUM_TYPE]
    info_num_name = JAVA_INFO[INFO_KEY_NUM_NAME]

    # (定|変)数の色々を取得

    # access attr
    attr_scan = line.scan(/#{info_num_attr}/)
    unless attr_scan.nil?
      if attr_scan[0].nil?
        # accessが定義されていないのは全てpublicとみなす
        attr = "public"
      else
        attr = attr_scan[0][0]
        line.gsub!(/#{info_num_attr}/, "")
      end
    end

    # static
    is_static_scan = line.scan(/#{info_num_is_static}/)
    unless is_static_scan.empty?
      line.gsub!(/#{info_num_is_static}/, "")
    end
    is_static = !is_static_scan.empty?

    # final
    is_final_scan = line.scan(/#{info_num_is_final}/)
    unless is_final_scan.empty?
      line.gsub!(/#{info_num_is_final}/, "")
    end
    is_final = !is_final_scan.empty?

    # get Type
    type_scan = line[/#{info_num_type}/]
    unless type_scan.nil?
      type = type_scan.delete(" ")
      line.sub!(/#{info_num_type}/, "")
    end

    # get Name
    name_scan = line[/#{info_num_name}/]
    unless name_scan.nil?
      name = name_scan
      line.sub!(/#{info_num_name}/, "")
    end

    # 取得した情報を詰めて返す
    Num.new(name, type, attr, is_static, is_final)
  end

  # </editor-fold>

  # <editor-fold desc="Function系">

  #
  # 行の文字列からfunctionの始まりの行かを取得する
  #
  # @param line : 行の文字列
  #
  private def is_start_function(line)
    function = JAVA_INFO[INFO_KEY_FUNC_START]
    line.match(/#{function}/) != nil
  end

  #
  # 行の文字列から関数の情報を取得する
  #
  # @param line : 行の文字列
  #
  private def get_function(line)
    info_func_attr = JAVA_INFO[INFO_KEY_FUNC_ATTR]
    info_func_type = JAVA_INFO[INFO_KEY_FUNC_TYPE]
    info_func_name = JAVA_INFO[INFO_KEY_FUNC_NAME]

    # 関数の色々を取得する

    # access attr
    attr_scan = line.scan(/#{info_func_attr}/)
    unless attr_scan.nil?
      if attr_scan[0].nil?
        # accessが定義されていないのは全てpublicとみなす
        attr = "public"
      else
        attr = attr_scan[0][0]
        line.sub!(/#{info_func_attr}/, "")
      end
    end

    # ret
    ret_scan = line.scan(/#{info_func_type}/)
    unless ret_scan.nil?
      ret = ret_scan[0]
      line.sub!(/#{info_func_type}/, "")
    end

    # name
    name_scan = line.scan(/#{info_func_name}/)
    unless name_scan.nil?
      name = name_scan[0]
      line.sub!(/#{info_func_name}/, "")
    end
    Function.new(name, ret, attr)
  end

  # </editor-fold>

  # <editor-fold desc="If系">

  #
  # Ifの始まりの行であるかを判定する
  #
  # @param line : 行の文字列
  # @return : Ifの行である場合はTrueを返す
  #
  def is_if_start(line)
    if_start = JAVA_INFO[INFO_KEY_IF_START]
    line.match(/#{if_start}/) != nil
  end

  # </editor-fold>

  # <editor-fold desc="Block系">

  #
  # 単一行のBlockであるかを判定する
  #
  # @param line : 行の文字列
  # @return : 単一行のBlockである場合はtrue
  #
  def is_block_in_line(line)
    block_in_line = JAVA_INFO[INFO_KEY_IS_BLOCK_IN_LINE]
    line.match(/#{block_in_line}/) != nil
  end

  #
  # Blockの始まりの行であるかを判定する
  #
  # @param line : 行の文字列
  # @return : 単一行のBlockである場合はtrue
  #
  def is_block_start(line)
    block_start = JAVA_INFO[INFO_KEY_IS_BLOCK_START]
    line.match(/#{block_start}/) != nil
  end

  #
  # Blockの終わりの行であるかを判定する
  #
  # @param line : 行の文字列
  # @return : 単一行のBlockである場合はtrue
  #
  def is_block_end(line)
    block_end = JAVA_INFO[INFO_KEY_IS_BLOCK_END]
    line.match(/#{block_end}/) != nil
  end

  # </editor-fold>

end