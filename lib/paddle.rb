require 'httparty'

class Paddle
  include HTTParty

  PADDLE_VENDOR_ID = Rails.application.credentials.fetch(:paddle_vendor_id).to_i
  PADDLE_VENDOR_AUTH_CODE = Rails.application.credentials.fetch(:paddle_vendor_auth_code)

  base_uri 'https://vendors.paddle.com/api/2.0'

  def self.generate_pay_link(params)
    body = {
        discountable: 0,
        vendor_id: PADDLE_VENDOR_ID,
        vendor_auth_code: PADDLE_VENDOR_AUTH_CODE,
        title: "ScaleChamp $#{params[:passthrough][:price]}",
        prices: ["#{params[:currency].upcase}:#{params[:price]}"],
        quantity_variable: 0,
        customer_email: params[:customer_email],
        custom_message: "Prepay #{params[:project_name]} for $#{params[:passthrough][:price]}",
        image_url: 'https://cloud.scalechamp.com/ScaleChamp.png',
        webhook_url: 'https://cloud.scalechamp.com/paddle/webhook/',
        passthrough: params[:passthrough].to_json
    }
    puts JSON.generate(body)
    post "/product/generate_pay_link", body: body
  end

  def self.transactions(params)
    post "/#{params[:entity]}/#{params[:id]}/transactions", body: {
        vendor_id: PADDLE_VENDOR_ID,
        vendor_auth_code: PADDLE_VENDOR_AUTH_CODE
    }
  end
end
