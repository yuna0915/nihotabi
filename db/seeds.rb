# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# -------------------------------
# 都道府県（47都道府県）
# -------------------------------
%w[
  北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県
  茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県
  新潟県 富山県 石川県 福井県 山梨県 長野県
  岐阜県 静岡県 愛知県 三重県
  滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県
  鳥取県 島根県 岡山県 広島県 山口県
  徳島県 香川県 愛媛県 高知県
  福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県 沖縄県
].each do |name|
  Prefecture.create!(name: name)
end

# -------------------------------
# 訪問月（1〜12月）
# -------------------------------
(1..12).each do |m|
  VisitedMonth.create!(number: "#{m}月")
end

# -------------------------------
# 訪問時間帯（0:00〜24:00を1時間ごと）
# -------------------------------
(0..23).each do |h|
  from = format('%02d:00', h)
  to = format('%02d:00', (h + 1) % 24)
  VisitedTimeZone.create!(hour: "#{from}〜#{to}")
end

# -------------------------------
# 場所ジャンル（固定）
# -------------------------------
["観光地", "カフェ", "自然", "イベント", "温泉", "体験", "その他"].each do |name|
  LocationGenre.create!(name: name)
end

Admin.create!(
  email: 'aa@aa',
  password: 'aaaaaa',
  password_confirmation: 'aaaaaa'
)
