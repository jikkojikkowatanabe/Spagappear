

class Num

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  # @param name : (変|定)数名
  # @param type : 型
  # @param attr : 修飾子
  # @param is_static : staticかどうか
  #
  def initialize(name, type, attr, is_static, is_final)
    @name = name
    @type = type
    @attr = attr
    @is_static = is_static
    @is_final = is_final
  end

  # </editor-fold>

end