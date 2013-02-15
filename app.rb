# coding: utf-8

require 'sinatra'
require 'open-uri'

get '/' do
  master_path = "/tmp/paperboy-keys-master.txt"

  unless FileTest.exists?(master_path)
    open("https://raw.github.com/paperboy-all/all/master/github/members.txt?login=banyan&token=#{ENV['GITHUB_TOKEN']}") { |f|
      File.write(master_path, f.read)
    }
  end

  accounts = []
  File.readlines(master_path, encoding: Encoding::UTF_8).each do |line|
    accounts << line.split(' ')[0]
  end

  html = ""
  html << '<html><body>'
  html << '<a href="https://github.com/banyan/paperboy-keys><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>'
  accounts.shuffle.each do |account|
    account_path    = "/tmp/keys/paperboy-keys-#{account}.txt"
    account_key_url = "https://github.com/#{account}.keys"

    unless FileTest.exists?(account_path)
      open(account_key_url) { |f|
        File.write(account_path, f.read)
      }
    end
    keys = File.read(account_path)
    html << "<div style=\"font-family: ProFont,Sheldon,Mishawaka,Monaco; \">"
    html << "<br />"
    account.each_char do |char|
      html << "<span style=\"font-size: #{rand(12..500)}px \">#{char}</span>"
    end
    html << "</div>"
    html << "<br />"
    html << "<div style=\"width: #{rand(1200..2000)}px; word-wrap: break-word;\">"
    html << keys
    html << "</div>"
  end
  html << '</body></html>'
  html
end
