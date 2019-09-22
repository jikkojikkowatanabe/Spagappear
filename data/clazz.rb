
class Clazz

  # <editor-fold desc="accessor">

  attr_accessor :inner_classes,
                :name,
                :attr,
                :extends,
                :implement,
                :functions,
                :nums

  # </editor-fold>

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  # @param name : クラス名
  # @param attr : クラス修飾詩
  # @param extends : 親クラス名
  # @param implement : 実装クラス名
  #
  def initialize( name, attr, extends, implement)
    @name = name
    @attr = attr
    @extends = extends
    @implement = implement
    @functions = []
    @nums = []
    @inner_classes = []
  end

  # </editor-fold>

  # <editor-fold desc="内部class">

  #
  # 内部classを追加する
  #
  # @param clazz: 内部class
  #
  def add_inner_class(clazz)
    @inner_classes.push(clazz)
  end

  # </editor-fold>

  # <editor-fold desc="(定|変)数系">

  #
  # (定|変)数を設定する
  #
  # @param nums : (定|変)数の配列
  #
  def set_nums(nums)
    @nums = nums
  end

  #
  # (定|変)数を追加する
  #
  # @param num : (定|変)数
  #
  def add_num(num)
    @nums.push(num)
  end

  # </editor-fold>


  # <editor-fold desc="関数">

  #
  # 関数を設定する
  #
  # @param functions : []関数情報体
  #
  def set_functions(functions)
    @functions = functions
  end

  #
  # 関数を追加する
  #
  # @param function : 関数情報体
  #
  def add_function(function)
    @functions.push(function)
  end
  # </editor-fold>

end
