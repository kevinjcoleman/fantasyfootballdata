require 'json'

class ResponseSaver
  def self.save!(data, file)
    File.open(Rails.root.join('tmp', "#{file}.json").to_s, "w+") do |f|
      f << data.to_hash.to_json
    end
  end
end
