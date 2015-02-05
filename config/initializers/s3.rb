if Rails.env.production?
	S3_CREDENTIALS = { 
		:access_key_id => ENV['AWS_ACCES_KEY_ID'], 
		:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'], 
		:bucket => ENV["PROD_BUCKET_NAME"]
	}
else
	S3_CREDENTIALS = 
	{ :access_key_id => ENV['AWS_ACCES_KEY_ID'],
		:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
		:bucket => ENV["STAGING_BUCKET_NAME"]
	}
end