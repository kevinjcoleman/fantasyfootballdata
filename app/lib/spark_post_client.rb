class SparkPostClient
  def self.send!(properties)
    client.transmissions.create(properties)
  end

  def self.client
    @client ||= SimpleSpark::Client.new(api_key: ENV["spark_post_api_key"])
  end
end
