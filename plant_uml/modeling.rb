
require_relative 'util'

class Modeling

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  # @param lang: 言語
  # @param resource: ファイルをparseした結果が格納されている
  #
  def initialize(lang, resource)
    @resource = resource
    @lang = lang
  end

  # </editor-fold>

  # <editor-fold desc="Modeling系">

  #
  # Modelingの開始
  #
  def do

    # まずはPackageからModelingする
    generated_package = gen_package(@resource.package)

    # 次にclassをModelingする
    generated_classes = []
    @resource.classes.each do | clazz |
      generated_clazz = gen_class(clazz)
      generated_classes.push(generated_clazz)
    end

    # 生成したclassをPackageに放り込むそれを返す
    generated_package.gsub!("$classes$", generated_classes.join("\n") )
    generated_package
  end

  #
  # data/resource/packageをpumlにする
  #
  # @param package : resourceに格納されているpackage
  #
  private def gen_package( package )
    "package #{package}{\n" <<
    "$classes$\n" <<
    "}\n"
  end

  #
  # data/resource/classをpumlにする
  #
  # @param clazz : resourceに格納されているclass
  #
  private def gen_class( clazz )
    ## 変数をModelingする
    nums = gen_nums(clazz)

    ## 関数をModelingする
    functions = gen_functions(clazz)

    "\tclass #{clazz.name}{\n" <<
    "#{nums}\n" <<
    "#{functions}\n" <<
    "\t}"

  end

  #
  # data/resource/class/numをpumlにする
  #
  # @param clazz : resourceに格納されているclass
  #
  private def gen_nums( clazz )
    nums = []
    nums.push("\t\t")
    clazz.nums.each do | num |
      attr_accessor = Util.gen_num_access(@lang, num.attr)
      num_statement = attr_accessor + num.name

      # staticならばそのことを表現するprefixを追加
      if num.is_static
        num_statement = "{static} "+ num_statement
      end
      nums.push("\t\t" + num_statement)
    end
    nums.join("\n")
  end

  #
  # data/resource/class/functionをpumlにする
  #
  private def gen_functions( clazz )
    functions = []
    functions.push("\t\t")
    clazz.functions.each do | function |
      attr_accessor = Util.gen_num_access(@lang, function.attr)
      function_statement = attr_accessor + function.name + "()"

      # # staticならばそのことを表現するprefixを追加
      # if function.is_static
      #   num_statement = "{static} "+ function_statement
      # end
      functions.push("\t\t" + function_statement)
    end
    functions.join("\n")
  end

  # </editor-fold>

end