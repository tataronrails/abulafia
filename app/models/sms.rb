class SMS

  class Unauthorized < StandardError; end

  API_IP = "http://178.207.18.182:8088/"
  API_SMS = API_IP + 'sms'

  SUCCESS_RESPONSE = %r{^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$}
  FAILURE_RESPONSE = %Q{<title>Unhandled Exception</title>}
  COUNTRY_CODE = '7'

  TRANSLITERATE = false

  ONE_MESSAGE_MAX_SIZE = 100
  MESSAGE_FOOTER_SIZE = 32
  MESSAGE_SIZE_LIMIT = ONE_MESSAGE_MAX_SIZE - MESSAGE_FOOTER_SIZE

  IN_ONE_MESSAGE = true

  include ActiveModel::Validations
  include HTTParty

  base_uri API_SMS
  format :html

  attr_accessor :number, :message
  attr_reader :response, :status

  validates :number,
            presence: true,
            length: { is: 11 }

  validates :message,
            presence: true,
            length: { minimum: 1, maximum: MESSAGE_SIZE_LIMIT }

  validate :validate_phone_number_format

  def initialize(*args)
    @options = args.extract_options!
    self.number  = @options.delete(:number ).presence || nil
    self.message = @options.delete(:message).presence || nil
    self
  end

  def send!
    return false unless valid?
    @response = self.class.post('/send', query: send_options)
    validate_connection
    self
  end

  def success?
    response_uuid.present?
  end

  def status
    get_status!
  end

  def response_uuid
    valid_response_uuid? && self.response.parsed_response
  end

  def number=(value)
    @number = format_phone_number(value)
  end

  def message=(value)
    @message = format_message(value)
  end

  private

  def get_status!
    @status = self.class.get(get_status_url(response_uuid))
  end

  def format_phone_number(value)
    if plausible?(value)
      use_correct_prefix!(value)
      Phony.normalize(value)
    end
  end

  def validate_phone_number_format
    unless plausible?(self.number)
      errors.add(:number, 'Bad phone number format')
    end
  end

  def validate_connection
    raise Unauthorized if self.response.parsed_response.match(FAILURE_RESPONSE).present?
  end

  def plausible?(value)
    Phony.plausible?(value) # , cc: COUNTRY_CODE)
  end

  def valid_response_uuid?
    self.response.parsed_response.match(SUCCESS_RESPONSE).present?
  end

  def use_correct_prefix!(value)
    value.gsub!(%r{^\+?7}, "8")
  end

  def send_options
    {
        number: number,
        message: message,
    }
  end

  def get_status_url(uuid)
    [ nil, 'jobs', uuid.to_s, 'status' ].join('/')
  end

  def format_message(value)
    if TRANSLITERATE
      I18n.locale = :ru
      value = I18n.transliterate( value )
    end
    if IN_ONE_MESSAGE
      value = reduce_message(value)
    end
    value
  end

  def reduce_message(value)
    value.first(MESSAGE_SIZE_LIMIT)
  end

end