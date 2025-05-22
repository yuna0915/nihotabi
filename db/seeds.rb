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
  Prefecture.find_or_create_by!(name: name)
end

# -------------------------------
# 訪問月（1〜12月）
# -------------------------------
(1..12).each do |m|
  VisitedMonth.find_or_create_by!(number: "#{m}月")
end

# -------------------------------
# 訪問時間帯（0:00〜24:00を1時間ごと）
# -------------------------------
(0..23).each do |h|
  from = format('%02d:00', h)
  to = format('%02d:00', (h + 1) % 24)
  VisitedTimeZone.find_or_create_by!(hour: "#{from}〜#{to}")
end

# -------------------------------
# 場所ジャンル（固定）
# -------------------------------
["観光地", "カフェ", "自然", "イベント", "温泉", "体験", "その他"].each do |name|
  LocationGenre.find_or_create_by!(name: name)
end

Admin.find_or_create_by!(email: 'aa@aa') do |admin|
  admin.password = 'aaaaaa'
  admin.password_confirmation = 'aaaaaa'
end

# -------------------------------
# 利用規約（初期文を1件のみ登録）
# -------------------------------
Term.find_or_create_by!(id: 1) do |term|
  term.content = <<~TEXT
    ニホタビ（以下、「当サービス」といいます）は、ユーザーの皆さまが旅行の体験やおすすめスポットを共有し、他のユーザーと交流することを目的としたSNSサービスです。当サービスをご利用いただく際は、以下の内容に同意したものとみなします。

    1. アカウントについて  
    ユーザーは正確な情報を登録し、自己の責任においてアカウントを管理してください。第三者による不正利用などに関して、当サービスは責任を負いません。

    2. 投稿内容について  
    投稿する写真・文章などは、ユーザーご自身の著作物または使用許可を得たものに限ります。  
    また、他人への誹謗中傷、差別的な表現、営利目的の広告など、公序良俗に反する内容の投稿は禁止します。

    3. 禁止行為  
    以下の行為は禁止とします。  
    ・他人になりすます行為  
    ・不適切な内容の投稿  
    ・当サービスの運営を妨げる行為

    4. 退会について  
    ユーザーはいつでも自由に退会できます。ただし、退会後に投稿された内容を削除することはできません。必要があれば、退会前にご自身で投稿を削除してください。

    5. 免責事項  
    当サービスは、投稿内容の正確性やユーザー間のトラブルについて一切の責任を負いません。ユーザー同士のトラブルは、当事者間で解決してください。

    6. 規約の変更  
    当サービスは、必要に応じて本規約を変更することがあります。変更後は、最新の利用規約が適用されます。

    ---

    2025年5月 ニホタビ運営
  TEXT
end

