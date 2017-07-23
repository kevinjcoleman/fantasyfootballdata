class WebDocument
  attr_accessor :doc
  def initialize(url)
    @doc = Nokogiri::HTML(HTTParty.get(url))
  end
end
