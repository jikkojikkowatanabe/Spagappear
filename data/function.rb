
class Function

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  # @param name : 関数名
  # @param ret : 返却型
  # @param attr : Access
  #
  def initialize(name, ret, attr)
    @name = name
    @ret = ret
    @attr = attr
    @lines = []
  end

  # </editor-fold>

  # <editor-fold desc="行">

  #
  # lineを追加する
  #
  # @param line : 行の文字列
  #
  def add_line(line)
    # 空文字は無視する
    if line == ""
      return
    end
    @lines.push(line)
  end

  # </editor-fold>

end
