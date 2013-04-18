require "ffcrm_vend/config"
require "ffcrm_vend/engine"

module FfcrmVend

  class << self

    def config
      FfcrmVend::Config.new
    end

    #
    # Helper to return the url to the Vend instance
    def vend_url
      URI("https://#{config.vend_id}.vendhq.com/")
    end

    #
    # Return the default user who will own created items
    def default_user
      if (user_id = config.user_id).present?
        User.where(:id => user_id).first
      else
        nil
      end
    end

    #
    # Checks to see if customer is in the exclusion list.
    # If so, the sale is not registered in FFCRM.
    # Blank names return false, matching names return true
    def is_customer_in_exclusion_list?(first_name, last_name)
      name = [first_name, last_name].join(' ')
      !name.strip.blank? and config.exclude_customers.include?(name)
    end

    #
    # A logger that can be turned on and off
    def log(message)
      Rails.logger.info("FfcrmVend: #{message}") if config.use_logger?
    end

  end # class

end
