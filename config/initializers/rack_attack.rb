module ActionDispatch
  class Request
    alias :remote_ip_orig :remote_ip

    def remote_ip
      @remote_ip ||= (@env['HTTP_CF_CONNECTING_IP'] || remote_ip_orig)
    end
  end
end

Rack::Attack.throttle("requests by ip", limit: 1000, period: 60) do |request|
  request.env['action_dispatch.remote_ip']
end

Rack::Attack.throttled_response = lambda do |env|
  match_data = env['rack.attack.match_data']
  now = match_data[:epoch_time]

  headers = {
      'RateLimit-Limit' => match_data[:limit].to_s,
      'RateLimit-Remaining' => '0',
      'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s
  }

  [429, headers, ["Throttled\n"]]
end
