SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
    samesite: {
      lax: true # mark all cookies as SameSite=Lax by default
    }
  }

  config.hsts = "max-age=63072000; includeSubDomains; preload"
  config.x_frame_options = "SAMEORIGIN"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[strict-origin-when-cross-origin]

  config.csp = {
    default_src: %w['self'],
    script_src: %w['self' 'unsafe-inline' 'unsafe-eval'],
    style_src: %w['self' 'unsafe-inline'],
    img_src: %w['self' data:],
    font_src: %w['self' data:],
    connect_src: %w['self'],
    frame_src: %w['self'],
    object_src: %w['none'],
    base_uri: %w['self'],
    form_action: %w['self']
  }
end 