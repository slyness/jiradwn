require 'fileutils'

module Jiradwn
  class Backup

    def initialize(global,options)
      @user = global[:u]
      @pass = global[:p]
      @endpoint = options[:e]
      @cookie = options[:c]
    end

    def generate_backup
      puts "Execute a Jira backup"

      uri = "https://" + @endpoint + "/rest/obm/1.0/runbackup"

      command = "curl -u " + @user + ":" + @pass + " --cookie " + @cookie + " --header \"X-Atlassian-Token: no-check\" -H \"X-Requested-With: XMLHttpRequest\" -H \"Content-Type: application/json\"  -X POST " + uri + " -d \'{\"cbAttachments\":\"true\" }\'"

      system(%(#{command}))

    end

    def get_cookie
      dashboard = "https://" + @endpoint + "/Dashboard.jspa"
      getcookie = "curl -s -u " + @user + ":" + @pass + " --cookie-jar " + @cookie + " --url " + dashboard + " --output /dev/null"

      system(%(#{getcookie}))
    end

    def clear_cookie
      FileUtils.rm(@cookie)
    end

    def run!
      get_cookie
      generate_backup
      clear_cookie
    end

  end
end
