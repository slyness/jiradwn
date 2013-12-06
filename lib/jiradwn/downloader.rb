require 'fileutils'
require 'net/http'
require 'uri'

module Jiradwn
  class Downloader

    def initialize(global,options)
      @user = global[:u]
      @pass = global[:p]
      @endpoint = global[:e]
      @storage = options[:s]
      @today = Time.new
      @backupfile = "JIRA-backup-" + @today.strftime("%Y%m%d") + ".zip"
    end

    def download_backup

      location = File.join(@storage,@backupfile)

      unless File.directory?(@storage)
        FileUtils.mkdir_p(@storage)
      end

      uri = "https://" + @endpoint + "/webdav/backupmanager/" + @backupfile
      uri = URI.parse(uri)
      puts "Downloading: #{uri}"
      puts "To: #{location}"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      begin
        http.start do |dwn|
          request = Net::HTTP::Get.new(uri.request_uri)
          request.basic_auth(@user, @pass)
          response = dwn.request(request)
          case response.code
          when "200"
            dwn.request(request) do |response|
              File.open(location, 'w') do |incoming|
                response.read_body do |chunk|
                  incoming.write(chunk)
                end
              end
            end
            puts "Download Complete"
          when "401"
            puts "Authorization error. Please check your username and password and try again."
          end
        end
      rescue Exception => e
        puts "Skipping download. This happened: #{e}"
        return
      end

    end

    def run!
        download_backup
    end

  end
end
