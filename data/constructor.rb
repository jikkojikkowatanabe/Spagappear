class Constructor

  # <editor-fold desc="外向きメンバー定義">

  attr_accessor :name,
                :lines

  # </editor-fold>

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  # @name
  #
  def initialize(name)
    @name = name
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