module SecretkeyHelper
  def get_secretkey
    file = File.new("config/forgery_secret_key", "r")
    @secretkey = file.gets
  file.close
    @secretkey
  end
end
