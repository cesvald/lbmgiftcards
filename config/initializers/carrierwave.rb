CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     Configuration[:aws_access_key],
    aws_secret_access_key: Configuration[:aws_secret_key]
  }
  config.fog_directory  = Configuration[:aws_bucket]
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end