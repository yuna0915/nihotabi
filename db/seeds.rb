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
[
  "観光地", "自然", "カフェ", "グルメ", "イベント",
  "体験", "寺社仏閣", "美術館・博物館", "動植物・水族館", "その他"
].each do |name|
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

# -------------------------------
# ユーザー（5人）
# -------------------------------
users_data = [
  { last_name: '山田', first_name: '一郎', last_name_kana: 'ヤマダ', first_name_kana: 'イチロウ', nickname: 'いっちゃん', email: 'aa@aa', password: 'aaaaaa', phone_number: '01011111111', prefecture_id: 13 },
  { last_name: '山田', first_name: '二郎', last_name_kana: 'ヤマダ', first_name_kana: 'ジロウ', nickname: 'じろちゃん', email: 'bb@bb', password: 'bbbbbb', phone_number: '01022222222', prefecture_id: 14 },
  { last_name: '山田', first_name: '三郎', last_name_kana: 'ヤマダ', first_name_kana: 'サブロウ', nickname: 'さぶちゃん', email: 'cc@cc', password: 'cccccc', phone_number: '01033333333', prefecture_id: 27 },
  { last_name: '山田', first_name: '四郎', last_name_kana: 'ヤマダ', first_name_kana: 'シロウ', nickname: 'しーちゃん', email: 'dd@dd', password: 'dddddd', phone_number: '01044444444', prefecture_id: 1 },
  { last_name: '山田', first_name: '五郎', last_name_kana: 'ヤマダ', first_name_kana: 'ゴロウ', nickname: 'ごろちゃん', email: 'ee@ee', password: 'eeeeee', phone_number: '01055555555', prefecture_id: 47 },
]

users_data.each do |user|
  users = User.all
  User.find_or_create_by!(email: user[:email]) do |u|
    u.last_name = user[:last_name]
    u.first_name = user[:first_name]
    u.last_name_kana = user[:last_name_kana]
    u.first_name_kana = user[:first_name_kana]
    u.nickname = user[:nickname]
    u.password = user[:password]
    u.password_confirmation = user[:password]
    u.phone_number = user[:phone_number]
    u.prefecture_id = user[:prefecture_id]
  end
end

# -------------------------------
# 投稿（5人分）
# -------------------------------

user1 = User.find_by(email: 'aa@aa')

posts_user1 = [
  {
    title: '苔に包まれた癒しの地蔵',
    body: '静かな境内で出会った苔むしたお地蔵さま。ほっとするひとときでした。',
    location_name: '苔の苑',
    address: '京都府宇治市',
    images: %w[seed1.1.jpg seed1.2.jpg seed1.3.jpg],
    genre: '寺社仏閣',
    lat: 34.884, lng: 135.796, month: 6, hour: 10
  },
  {
    title: '温泉に浸かるサルたち',
    body: '人間みたいに気持ちよさそうにしてて癒されました。',
    location_name: '湯の森どうぶつの里',
    address: '長野県松本市',
    images: %w[seed2.1.jpg],
    genre: 'その他',
    lat: 36.733, lng: 138.464, month: 1, hour: 14
  },
  {
    title: 'カフェラテとチーズケーキ',
    body: '木漏れ日の中で食べるケーキは格別でした。',
    location_name: 'カフェ風樹',
    address: '東京都八王子市',
    images: %w[seed3.1.jpg],
    genre: 'カフェ',
    lat: 35.666, lng: 139.324, month: 11, hour: 15
  },
  {
    title: '遊園地の定番スポット',
    body: '観覧車やメリーゴーランド、レトロな雰囲気が好きです。',
    location_name: 'ファンタジアパーク',
    address: '神奈川県横浜市',
    images: %w[seed4.1.jpg seed4.2.jpg seed4.3.jpg seed4.4.jpg seed4.5.jpg],
    genre: '体験',
    lat: 35.444, lng: 139.638, month: 8, hour: 13
  },
  {
    title: '紅葉の渓谷を歩いて',
    body: '川のせせらぎと色づいた木々に癒やされました。',
    location_name: '渓谷遊歩道',
    address: '長野県木曽郡',
    images: %w[seed5.1.jpg seed5.2.jpg],
    genre: '自然',
    lat: 35.840, lng: 137.690, month: 10, hour: 17
  },
  {
    title: 'ラベンダー畑で深呼吸',
    body: '風に揺れるラベンダーの香りに癒されました。',
    location_name: 'ラベンダーの丘',
    address: '北海道富良野市',
    images: %w[seed6.1.jpg],
    genre: '自然',
    lat: 43.343, lng: 142.383, month: 7, hour: 14
  },
  {
    title: '湖畔の静けさに耳を澄ます',
    body: '湖と森に囲まれて過ごす朝はとても贅沢でした。',
    location_name: '湖畔の森テラス',
    address: '山梨県富士吉田市',
    images: %w[seed7.1.jpg],
    genre: '自然',
    lat: 35.491, lng: 138.765, month: 5, hour: 6
  }
]

user2 = User.find_by(email: 'bb@bb')

posts_user2 = [
  {
    title: 'Wランチで大満足',
    body: '濃厚パスタとスパイシースープ、どちらも絶品でした。',
    location_name: 'カフェ・ラララ',
    address: '東京都世田谷区',
    images: %w[seed8.1.jpg seed8.2.jpg],
    genre: 'グルメ',
    lat: 35.646, lng: 139.653, month: 11, hour: 13
  },
  {
    title: '夕暮れの波音に癒されて',
    body: '潮風と夕焼けの組み合わせが心に染みました。',
    location_name: '潮風ヶ浜',
    address: '静岡県下田市',
    images: %w[seed9.1.jpg],
    genre: '自然',
    lat: 34.672, lng: 138.945, month: 9, hour: 17
  },
  {
    title: 'コク深いチャーシューラーメン',
    body: '厚切りチャーシューと濃厚スープがクセになる味でした。',
    location_name: '麺屋ひなた',
    address: '愛知県名古屋市',
    images: %w[seed10.1.jpg],
    genre: 'グルメ',
    lat: 35.170, lng: 136.908, month: 2, hour: 18
  },
  {
    title: 'クラゲの神秘的な世界',
    body: 'ゆらゆらと漂う姿に見入ってしまいました。',
    location_name: 'アクアリウム月海',
    address: '山形県鶴岡市',
    images: %w[seed11.1.jpg seed11.2.jpg seed11.3.jpg],
    genre: '動植物・水族館',
    lat: 38.727, lng: 139.821, month: 7, hour: 16
  },
  {
    title: '夏の夜に咲く光の花',
    body: '花火が夜空を彩って、会場が歓声で包まれていました。',
    location_name: '宵ノ空花火祭',
    address: '秋田県大仙市',
    images: %w[seed12.1.jpg seed12.2.jpg],
    genre: 'イベント',
    lat: 39.450, lng: 140.478, month: 8, hour: 20
  },
  {
    title: 'チューリップが咲き誇る春の道',
    body: '春の風と花の香りに包まれて散歩しました。',
    location_name: '花の環ガーデン',
    address: '富山県砺波市',
    images: %w[seed13.1.jpg],
    genre: '自然',
    lat: 36.640, lng: 137.003, month: 4, hour: 10
  }
]

user3 = User.find_by(email: 'cc@cc')

posts_user3 = [
  {
    title: '春彩の湖と名峰',
    body: '満開の芝桜と湖面に映る山のコントラストが素晴らしかったです。',
    location_name: '彩咲湖畔公園',
    address: '静岡県花見町',
    images: %w[seed14.1.jpg],
    genre: '自然',
    lat: 35.400, lng: 138.750, month: 4, hour: 9
  },
  {
    title: 'のんびりシカさん',
    body: '芝の上でまどろむ姿に癒されました。',
    location_name: '森の小径広場',
    address: '奈良県緑野市',
    images: %w[seed15.1.jpg],
    genre: '動植物・水族館',
    lat: 34.685, lng: 135.805, month: 5, hour: 12
  },
  {
    title: '赤灯台と曇り空',
    body: '曇天の中で浮かび上がる赤い灯台が印象的でした。',
    location_name: '港あかね灯台',
    address: '兵庫県海影町',
    images: %w[seed16.1.jpg],
    genre: '観光地',
    lat: 34.640, lng: 135.050, month: 2, hour: 16
  },
  {
    title: '山奥の癒し滝',
    body: '緑の中で静かに流れる滝。ずっと眺めていたくなる場所です。',
    location_name: '翠霞の滝',
    address: '岡山県渓音村',
    images: %w[seed17.1.jpg],
    genre: '自然',
    lat: 34.916, lng: 133.815, month: 7, hour: 11
  },
  {
    title: '夜明けの孤木',
    body: '静かな夜明けと一本の木。幻想的な光景でした。',
    location_name: '黎明の丘',
    address: '北海道朝凪町',
    images: %w[seed18.1.jpg],
    genre: '自然',
    lat: 43.030, lng: 141.350, month: 10, hour: 5
  },
  {
    title: '白鳥たちの朝',
    body: '朝日を浴びる白鳥たちの姿に見とれてしまいました。',
    location_name: '白羽湖の水辺',
    address: '新潟県羽島市',
    images: %w[seed19.1.jpg],
    genre: '動植物・水族館',
    lat: 37.920, lng: 139.030, month: 12, hour: 7
  }
]

user4 = User.find_by(email: 'dd@dd')

posts_user4 = [
  {
    title: '湯気まで美味しい点心ランチ',
    body: 'もっちり皮にジューシーな肉汁が最高。お茶との相性も抜群でした。',
    location_name: '翠香茶館',
    address: '東京都新宿区',
    images: %w[seed20.1.jpg],
    genre: 'グルメ',
    lat: 35.693, lng: 139.703, month: 11, hour: 12
  },
  {
    title: '百獣の王',
    body: '迫力満点のライオン、カメラ目線で堂々たる風格でした。',
    location_name: '星空サファリパーク',
    address: '静岡県富士宮市',
    images: %w[seed21.1.jpg seed21.2.jpg],
    genre: '動植物・水族館',
    lat: 35.238, lng: 138.621, month: 7, hour: 13
  },
  {
    title: '海辺の樽サウナでととのう',
    body: '外気浴は海風で。整いすぎて現実に戻れない感覚になりました。',
    location_name: '浜風サウナベース',
    address: '和歌山県白浜町',
    images: %w[seed22.1.jpg seed22.2.jpg],
    genre: '体験',
    lat: 33.678, lng: 135.348, month: 4, hour: 16
  },
  {
    title: '一面の花畑に心が躍る',
    body: '色とりどりの花が広がる景色に、ただただ見惚れました。',
    location_name: '彩りの丘',
    address: '北海道上富良野町',
    images: %w[seed23.1.jpg],
    genre: '自然',
    lat: 43.456, lng: 142.470, month: 7, hour: 11
  },
  {
    title: '茶室で味わう静けさと一服',
    body: 'お茶を点てる所作と空気の張りつめた静けさが心地よかったです。',
    location_name: '月見庵 茶道体験',
    address: '京都府左京区',
    images: %w[seed24.1.jpg],
    genre: '体験',
    lat: 35.058, lng: 135.798, month: 11, hour: 10
  },
  {
    title: 'ぷりっぷりの牡蠣に舌鼓',
    body: '海の旨みが凝縮された牡蠣をたっぷり味わいました。最高のごちそう！',
    location_name: '牡蠣小屋 海の幸亭',
    address: '広島県江田島市',
    images: %w[seed25.1.jpg],
    genre: 'グルメ',
    lat: 34.203, lng: 132.464, month: 2, hour: 18
  }
]

user5 = User.find_by(email: 'ee@ee')

posts_user5 = [
  {
    title: '森に囲まれた秘密の湖',
    body: '木陰に置かれたベンチでのんびり。湖面が風で揺れる音が心地よかったです。',
    location_name: 'ミドリ湖キャンプエリア',
    address: '長野県佐久市',
    images: %w[seed26.1.jpg],
    genre: '自然',
    lat: 36.293, lng: 138.468, month: 7, hour: 10
  },
  {
    title: '色とりどりの大地',
    body: 'パッチワークのように広がる畑が美しくて、つい見とれてしまいました。',
    location_name: 'フラワーファーム丘陵',
    address: '北海道深川市',
    images: %w[seed27.1.jpg],
    genre: '自然',
    lat: 43.716, lng: 142.050, month: 8, hour: 9
  },
  {
    title: '夜の灯火に浮かぶお寺',
    body: '幻想的なライトアップと山の火が合わさって、忘れられない夜になりました。',
    location_name: 'ヒカリア寺と護摩山',
    address: '奈良県高取町',
    images: %w[seed28.1.jpg],
    genre: '寺社仏閣',
    lat: 34.452, lng: 135.853, month: 1, hour: 19
  },
  {
    title: '整えられた松の庭園',
    body: '丁寧に手入れされた松が並び、静けさと気品に満ちた場所でした。',
    location_name: '翠松園',
    address: '東京都府中市',
    images: %w[seed29.1.jpg],
    genre: '自然',
    lat: 35.675, lng: 139.477, month: 3, hour: 11
  },
  {
    title: '目にも美味しい寿司ランチ',
    body: '板前さんのおすすめを堪能。どれも新鮮で、ネタが大きくて感動でした！',
    location_name: 'すし処 海風',
    address: '富山県魚津市',
    images: %w[seed30.1.jpg],
    genre: 'グルメ',
    lat: 36.827, lng: 137.415, month: 6, hour: 12
  },
  {
    title: '灯りに包まれた石畳の小道',
    body: '夕方に訪れると、古民家の灯りと石畳の道がとてもロマンチックでした。',
    location_name: '夜灯の宿通り',
    address: '石川県輪島市',
    images: %w[seed31.1.jpg],
    genre: '観光地',
    lat: 37.397, lng: 136.899, month: 10, hour: 18
  },
  {
  title: '満天の星を仰ぐ山頂',
  body: '街の灯りが届かない山の上で、宇宙の広さを感じました。',
  location_name: '星見峠',
  address: '長野県阿智村',
  images: %w[seed32.1.jpg],
  genre: '自然',
  lat: 35.444, lng: 137.652, month: 8, hour: 22
},
{
  title: '素朴な茶の香りに包まれて',
  body: '手びねりの器で味わうお茶は、心にじんわり沁みました。',
  location_name: '古民家茶房なごみ',
  address: '静岡県掛川市',
  images: %w[seed33.1.jpg],
  genre: '体験',
  lat: 34.770, lng: 137.998, month: 6, hour: 14
},
{
  title: '森に囲まれた静寂の神域',
  body: 'ひんやりとした空気と鳥の声が心を落ち着かせてくれました。',
  location_name: '奥宮参道',
  address: '三重県熊野市',
  images: %w[seed34.1.jpg],
  genre: '寺社仏閣',
  lat: 33.870, lng: 136.137, month: 11, hour: 10
},
{
  title: '海風と夕景のレインボーブリッジ',
  body: '沈む夕日に照らされる東京湾と橋がとても綺麗でした。',
  location_name: 'お台場海浜公園',
  address: '東京都港区',
  images: %w[seed35.1.jpg],
  genre: '観光地',
  lat: 35.628, lng: 139.775, month: 9, hour: 18
},
{
  title: '錦鯉が泳ぐ癒しの水辺',
  body: 'ゆったり泳ぐ姿を見ているだけで時間を忘れました。',
  location_name: '鯉の庭園',
  address: '新潟県長岡市',
  images: %w[seed36.1.jpg],
  genre: '自然',
  lat: 37.448, lng: 138.851, month: 5, hour: 13
},
{
  title: '池に映る和の情景',
  body: '静かな水面に映る茶室が日本の美を感じさせてくれました。',
  location_name: '兼六園 茶室',
  address: '石川県金沢市',
  images: %w[seed37.1.jpg],
  genre: 'その他',
  lat: 36.561, lng: 136.660, month: 10, hour: 15
},
{
  title: 'だし香るほっとする味',
  body: '優しい味のおうどんが旅の疲れを癒してくれました。',
  location_name: 'うどん処こむぎ',
  address: '香川県丸亀市',
  images: %w[seed38.1.jpg],
  genre: 'グルメ',
  lat: 34.292, lng: 133.798, month: 3, hour: 12
},
{
  title: '夜景に映える中之島の橋',
  body: '水面に映る光が幻想的で、しばらく眺めていました。',
  location_name: '中之島公園',
  address: '大阪府大阪市',
  images: %w[seed39.1.jpg],
  genre: '観光地',
  lat: 34.692, lng: 135.502, month: 12, hour: 19
},
{
  title: '屋台の味を公園で',
  body: '地元でも知る人ぞ知る、たこ八のたこ焼き。外で食べたら、その美味しさがさらに引き立ちました。',
  location_name: 'たこ八',
  address: '広島県福山市',
  images: %w[seed40.1.jpg],
  genre: 'グルメ',
  lat: 34.485, lng: 133.364, month: 4, hour: 16
}

]

[user1, posts_user1,
 user2, posts_user2,
 user3, posts_user3,
 user4, posts_user4,
 user5, posts_user5].each_slice(2) do |user, posts|
  posts.each do |data|
    post = Post.new(
      user: user,
      title: data[:title],
      body: data[:body],
      location_name: data[:location_name],
      address: data[:address],
      latitude: data[:lat],
      longitude: data[:lng],
      prefecture_id: Prefecture.find_by(name: data[:address][0..2])&.id || user.prefecture_id,
      visited_month_id: data[:month],
      visited_time_zone_id: VisitedTimeZone.find_by(hour: "#{format('%02d:00', data[:hour])}〜#{format('%02d:00', (data[:hour] + 1) % 24)}")&.id || 1,
      location_genre_id: LocationGenre.find_by(name: data[:genre])&.id || LocationGenre.last.id
    )

    data[:images].each do |filename|
      path = Rails.root.join("app/assets/images/#{filename}")
      post.images.attach(
        io: File.open(path),
        filename: filename,
        content_type: 'image/jpeg'
      )
    end

    post.save!
  end
end

users = [user1, user2, user3, user4, user5]

# -------------------------------
# いいね（各ユーザーが他人の投稿に15件ずつ）
# -------------------------------

users.each do |user|
  liked_posts = Post.where.not(user_id: user.id).sample(15)
  liked_posts.each do |post|
    Favorite.find_or_create_by!(user: user, post: post)
  end
end

# -------------------------------
# コメント（各ユーザーが他人の投稿15件にコメント）
# -------------------------------

sample_comments = [
  "ここ行ってみたいです！",
  "すごく気になります！",
  "参考になります！",
  "とても魅力的ですね！",
  "気分が上がります！",
  "行動してみたくなりました！",
  "素敵な投稿ありがとうございます！",
  "メモしておきます！",
  "こういう場所いいですね！",
  "雰囲気が伝わってきます！",
  "いいですね〜！",
  "写真から楽しさが伝わってきます！",
  "こういう体験してみたいです！",
  "投稿見てワクワクしました！",
  "とても惹かれました！"
]

users.each do |user|
  commented_posts = Post.where.not(user_id: user.id).sample(15)
  commented_posts.each do |post|
    Comment.create!(
      user: user,
      post: post,
      body: sample_comments.sample
    )
  end
end

# -------------------------------
# フォロー（各ユーザーが他のユーザーを3人フォロー）
# -------------------------------

users.each do |follower|
  follow_targets = users.reject { |u| u.id == follower.id }.sample(3)
  follow_targets.each do |followed|
    Relationship.find_or_create_by!(follower: follower, followed: followed)
  end
end

# -------------------------------
# お問い合わせ＆管理者からの返信
# -------------------------------

admin = Admin.first
users.each_with_index do |user, i|
  inquiry = Inquiry.find_or_create_by!(
    user: user,
    title: "お問い合わせ#{i + 1}",
    body: "このアプリの使い方について質問です。#{i + 1}番目のユーザーです。"
  )

  InquiryReply.find_or_create_by!(
    inquiry: inquiry,
    admin: admin,
    body: "お問い合わせありがとうございます。"
  )
end

# -------------------------------
# 通知（いいね・コメント・問い合わせ返信）
# -------------------------------

Favorite.find_each do |fav|
  Notification.find_or_create_by!(
    user_id: fav.user_id,
    notified_user_id: fav.post.user_id,
    post_id: fav.post_id,
    notifiable: fav,
    action: 'like'
  ) do |n|
    n.checked = false
  end
end

Comment.find_each do |comment|
  Notification.find_or_create_by!(
    user_id: comment.user_id,
    notified_user_id: comment.post.user_id,
    post_id: comment.post_id,
    comment_id: comment.id,
    notifiable: comment,
    action: 'comment'
  ) do |n|
    n.checked = false
  end
end

InquiryReply.find_each do |reply|
  Notification.find_or_create_by!(
    user_id: reply.admin_id,
    notified_user_id: reply.inquiry.user_id,
    notifiable: reply,
    action: 'reply'
  ) do |n|
    n.checked = false
  end
end
