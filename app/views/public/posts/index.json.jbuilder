json.data do
  json.items do
    json.array!(@posts) do |post|
      json.id post.id
      json.user do
        json.name post.user.nickname
        json.image url_for(post.user.profile_image) if post.user.profile_image.attached?
      end
      json.image url_for(post.image) if post.image.attached?
      json.shop_name post.location_name
      json.caption post.body
      json.address post.address
      json.latitude post.latitude
      json.longitude post.longitude
    end
  end
end
