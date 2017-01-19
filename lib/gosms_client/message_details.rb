module GosmsClient
  class MessageDetails

    attr_reader :data

    def initialize(hash)
      @data = hash
    end

    def price
      stats['price']
    end

    def recipients_count
      stats['recipientsCount']
    end

    def number_types
      stats['numberTypes']
    end

    def cz_mobile_count
      number_types['czMobile']
    end

    def cz_other_count
      number_types['czOther']
    end

    def is_test
      @data['sendingInfo']['status'] == 'CONCEPT'
    end

    def to_s
      @data.to_s
    end

    def link
      @data['link']
    end

private

    def stats
      @data['stats']
    end

  end
end
