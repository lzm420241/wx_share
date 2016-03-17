json.array!(@coupons) do |coupon|
  json.extract! coupon, :id, :openid, :start_time, :end_time, :price
  json.url coupon_url(coupon, format: :json)
end
