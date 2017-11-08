class ShortLink < ApplicationRecord
  has_one :stat, dependent: :destroy

  validates :url, presence: true
  validates :shortcode, uniqueness: true
  validates :shortcode, format: { with: /\A[0-9a-zA-Z_]{6}\z/i }, allow_nil: true

  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split(//)

  before_create { generate_shortcode(:shortcode) }
  after_create :url_encode_date

  def generate_shortcode(shortcode)
    return if valid_preferential_shortcode?(shortcode)
    begin
      self[shortcode] = shortlink_encode
    end while shortcode_exists?(shortcode)
  end

  def shortlink_encode
    encoded_shortcode = []
    base = ALPHABET.length
    uniq_identifier = ShortLink.last.id + 1

    while uniq_identifier > 0
      encoded_shortcode << ALPHABET[uniq_identifier.modulo(base)]
      uniq_identifier = uniq_identifier/base
    end
    encoded_shortcode << 0 while encoded_shortcode.length < 6
    encoded_shortcode.join('').reverse
  end

  def valid_preferential_shortcode?(shortcode)
    !!(self[shortcode] =~ /\A[0-9a-zA-Z_]{6}\z/i) && !shortcode_exists?(shortcode)
  end

  def shortcode_exists?(shortcode)
    ShortLink.exists?(shortcode: self[shortcode])
  end

  def url_encode_date
    Stat.create!(start_date: DateTime.now.in_time_zone('UTC').iso8601, short_link_id: id)
  end
end
