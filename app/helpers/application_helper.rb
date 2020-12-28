module ApplicationHelper
  def title
    current_page = Rails.application.routes.router.recognize(request) do |route, _|
      break route.name
    end

    case current_page
    when nil
      'ScaleChamp | 404'
    when 'root'
      'ScaleChamp | Projects'
    else
      page = current_page.split(/[-_]/).map(&:capitalize).map { |part|
        case part
        when 'vpcs'
          'VPC'
        when 'Api'
          'API'
        when 'Otp'
          'OTP'
        else
          part
        end
      }.join(' ')
      "ScaleChamp | #{page}"
    end
  end
end
