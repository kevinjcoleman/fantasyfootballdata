require 'json'

class SavedResponseOpener
  def self.read!(file)
    File.open(Rails.root.join('tmp', "#{file}.json").to_s) do |f|
      JSON.parse(f.read)
    end
  end
end
