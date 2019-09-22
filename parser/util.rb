
class Util

  #
  # 引数Targetから引数regexに当てはまる文字列を返し、なおかつtargetからあてハマる文字列を削除する
  #
  # @param regex : 正規表現
  # @param target : 対象文字列
  #
  def self.exploit(regex, target)
    ret = target.scan(regex)[0][0]
    target.gsub!(ret, "")
    ret
  end
end