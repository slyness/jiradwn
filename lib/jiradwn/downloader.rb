require 'fileutils'
require 'net/http'
require 'uri'

module Jiradwn
  class Downloader

    def initialize(global,options)
      @user = global[:u]
      @pass = global[:p]
      @endpoint = global[:e]
      @download_date = options[:d]
      @storage = options[:s]
      @backupfile = "JIRA-backup-" + @download_date + ".zip"
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
            dwn.request(request) do |download|
              File.open(location, 'w') do |incoming|
                download.read_body do |chunk|
                  incoming.write(chunk)
                end
              end
            end
            puts "Download Complete"
          when "401"
            puts "Authorization error. Please check your username and password and try again."
            puts response.body
          end
        end
      rescue Exception => e
        puts "Skipping download. This happened: #{e}"
        puts response.body
        return
      end

    end

    def run!
        download_backup
    end

  end
end
