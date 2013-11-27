require 'fileutils'

module Jiradwn
  class Downloader

    def initialize(global,options)
      @user = global[:u]
      @pass = global[:p]
      @endpoint = options[:e]
      @storage = options[:s]
      @today = Time.new
    end

    def download_backup
      puts "Downloading file from " + @endpoint

      backupfile = "JIRA-backup-" + @today.strftime("%Y%m%d") + ".zip"
      uri = "https://" + @endpoint + "/webdav/backupmanager/" + backupfile
      location = File.join(@storage,backupfile)
      command = "wget --user=#{@user} --password=#{@pass} -c #{uri} -O #{location}"

      FileUtils.mkdir_p(@storage)
      system(%(#{command}))

      puts command
      puts "#{uri}"
      puts location
    end

    def backup_exists
      return true
    end

    def run!
      if backup_exists
        download_backup
      end
    end

  end
end
