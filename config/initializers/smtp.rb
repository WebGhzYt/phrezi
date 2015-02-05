if Rails.env.staging? || Rails.env.production?
  SMTP_SETTINGS = {
    address: 'smtp.mandrillapp.com',
    authentication: :plain,
    password: ENV.fetch('MANDRILL_APIKEY'),
    port: 587,
    user_name: ENV.fetch('MANDRILL_USERNAME')
  }
end
