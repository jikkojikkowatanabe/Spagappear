

class Resource

  # <editor-fold desc="初期化">

  #
  # 初期化
  #
  def initialize
    @imports = []
    @classes = []
  end

  # </editor-fold>

  # <editor-fold desc="セット系">

  #
  # Package名をセットする
  #
  # @param val : パッケージ
  #
  def set_package(val)
    @package = val
  end

  #
  # importを追加する
  #
  # @param val : import
  #
  def add_import(val)
    @imports.push(val)
  end

  #
  # classを追加する
  #
  # @param val : class
  #
  def add_class(val)
    @classes.push(val)
  end

  # </editor-fold>





end