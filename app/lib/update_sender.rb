class UpdateSender
  def initialize(subject: ,text: , recipients: [])
    @subject = subject
    @text = text
    @recipients = recipients
  end

  def send!
    SparkPostClient.send!(  {content: {
                              from: 'update@fantasyfootballmofo.com',
                              subject: @subject,
                              text: @text,
                            },
                            recipients: recipients})
  end
  def recipients
    @recipients.map {|r| {address: r} }
  end 
end
