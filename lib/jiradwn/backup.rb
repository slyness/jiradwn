require 'fileutils'
require 'json'
require 'net/http'
require 'uri'

module Jiradwn
  class Backup

    def initialize(global,options)
      @user = global[:u]
      @pass = global[:p]
      @endpoint = global[:e]
    end

    def generate_backup
      puts "Execute a Jira backup"

      uri = "https://" + @endpoint + "/rest/obm/1.0/runbackup"
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      request["X-Atlassian-Token"] = "no-check"
      request["X-Requested-With"] = "XMLHttpRequest"
      request.body = { "cbAttachments" => true }.to_json
      request.basic_auth(@user, @pass)

      response = http.request(request)

      case response.code
      when "200"
        puts "Your backup is being generated... Response code: " + response.code
      when "500"
        puts "You must wait 48 hours between backup requests... Response code: " + response.code
      else
        puts "Somthing terrible has happened! Response code: " + response.code
      end

    end

    def run!
      generate_backup
    end

  end
end
