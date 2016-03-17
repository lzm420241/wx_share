json.array!(@users) do |user|
  json.extract! user, :id, :openid, :name
  json.url user_url(user, format: :json)
end
