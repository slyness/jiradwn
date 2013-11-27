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
    end

    def run!
      generate_backup
    end

  end
end
