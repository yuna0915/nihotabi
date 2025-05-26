# JSONのルートキー「data」を作成
json.data do

  # 「items」キーの中に投稿一覧（配列）を格納
  json.items do
    # 投稿一覧を配列として出力
    json.array!(@posts) do |post|

      # 投稿ID
      json.id post.id

      # 投稿者情報（ニックネームとプロフィール画像）
      json.user do
        json.name post.user.nickname

        # プロフィール画像のURL（画像がある場合のみ出力）
        json.image url_for(post.user.profile_image) if post.user.profile_image.attached?
      end

      # 投稿画像のURL（画像がある場合のみ出力）
      json.image url_for(post.image) if post.image.attached?

      # 投稿に紐づく情報（位置情報や本文など）
      json.location_name post.location_name   # スポット名（例：○○山、△△公園など）
      json.caption post.body                  # 本文（説明・感想）
      json.address post.address               # 住所（地図用）
      json.latitude post.latitude             # 緯度（Google Maps等に利用）
      json.longitude post.longitude           # 経度
    end
  end
end
