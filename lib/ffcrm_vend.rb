require "ffcrm_vend/engine"

module FfcrmVend

  class << self

    def vend_url
      URI("https://#{vend_id}.vendhq.com/")
    end

    def settings=(options)
      Setting[:ffcrm_vend] = {:vend_id => options[:vend_id], :email => options[:email]}
    end

    def vend_id
      Setting.ffcrm_vend.present? ? Setting.ffcrm_vend[:vend_id] : 'unknown'
    end

    def email
      Setting.ffcrm_vend.present? ? Setting.ffcrm_vend[:email] : 'unknown'
    end

  end # class

end
