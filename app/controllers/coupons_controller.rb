class CouponsController < ApplicationController
  before_action :set_coupon, only: [:show, :edit, :update, :destroy]
  before_filter :cors_preflight_check
  after_filter :cors_set_headers

  # GET /coupons
  # GET /coupons.json
  def index
    @appid = "wxa6d79104ef591bba"
	 @secret = "777dbf34a800fefe8c14140149cd3633"
	 @coupons = Coupon.all
	 @users = User.all
	 if session[:weixin_openid].blank?
		   code = params[:code]
	 end
	 if code.nil?
		  redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{@appid}&redirect_uri=#{request.url}&response_type=code&scope=snsapi_userinfo&state=#{request.url}#wechat_redirect" 
	 end
    #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
	 begin 
		url    = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{@appid}&secret=#{@secret}&code=#{code}&grant_type=authorization_code"
		# get access_token and openid
		@res = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
		rescue Exception => e
	end
	 #通过access_token 和 openid 来获取用户的信息
	begin																														       @info_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{@res["access_token"]}&openid=#{@res["openid"]}&lang=zh_CN"   
	@userinfo = JSON.parse(Net::HTTP.get_response(URI.parse(@info_url)).body)
	rescue Exception => e   
	end  
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
  end

  # GET /coupons/new
  def new
    @coupon = Coupon.new
  end

  # GET /coupons/1/edit
  def edit
  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = Coupon.new(coupon_params)

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to @coupon, notice: 'Coupon was successfully created.' }
        format.json { render :show, status: :created, location: @coupon }
      else
        format.html { render :new }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coupons/1
  # PATCH/PUT /coupons/1.json
  def update
    respond_to do |format|
      if @coupon.update(coupon_params)
        format.html { redirect_to @coupon, notice: 'Coupon was successfully updated.' }
        format.json { render :show, status: :ok, location: @coupon }
      else
        format.html { render :edit }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon.destroy
    respond_to do |format|
      format.html { redirect_to coupons_url, notice: 'Coupon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def cors_preflight_check
    if request.method == 'OPTIONS'
		 headers['Access-Controll-Allow-Origin'] = '*'
		 headers['Access-Controll-Allow-Methods'] = 'POST, GET, OPTIONS'
		 headers['Access-Controll-Allow-Headers'] = 'X-Requested-With, Content-Type, Accept'
		 headers['Access-Controll-Max-Age'] = '1728000'
		 render :text => '', :content-type => 'text/plain'
	 end
  end
  def cors_set_headers
		headers['Access-Controll-Allow-Origin'] = '*'
		headers['Access-Controll-Allow-Methods'] = 'POST, GET, OPTIONS'
		headers['Access-Controll-Max-Age'] = '1728000'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coupon_params
      params.require(:coupon).permit(:openid, :start_time, :end_time, :price)
    end
end
