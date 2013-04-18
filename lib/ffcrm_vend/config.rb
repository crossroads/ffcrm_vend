module FfcrmVend

  class Config

    attr_accessor :config

    def initialize
      @config = Setting.ffcrm_vend
    end

    #
    # Used in the admin section to apply settings
    def update!(options)
      @config = Setting.ffcrm_vend = {
        :vend_id => options[:vend_id],
        :user_id => options[:user_id],
        :sale_prefix => (options[:sale_prefix] || "").strip,
        :token => options[:token],
        :exclude_customers => options[:exclude_customers],
        :use_logger => options[:use_logger] == '1',
      }
    end

    #
    # ID of the vend instance in use
    def vend_id
      config.present? ? config[:vend_id] : ''
    end

    #
    # When a sale occurs, this plugin will create opportunities of the form "[prefix] [order number]"
    # Example: if prefix is set to "My Sale", then the opportunity name would be "My Sale 15"
    # Defaults to "Vend Sale" if left blank.
    def sale_prefix
      if config.present?
        unless (prefix = config[:sale_prefix]).blank?
          return prefix
        end
      end
      'Vend Sale'
    end

    #
    # Vend webhooks don't always supply details about who updated the record
    # We use email below to choose a fallback.
    def user_id
      config.present? ? config[:user_id] : ''
    end

    #
    # The token is used to authenticate incoming feeds.
    # Generates a random string if not set
    def token
      config.present? ? config[:token] : nil
    end

    #
    # The list of customers we want to ignore when processing updates
    def exclude_customers
      if config.present? and !(exclude = config[:exclude_customers]).blank?
        exclude.split(/\n+/).compact.uniq
      else
        []
      end
    end

    #
    # Used to display correctly on the admin settings page
    def exclude_customers_string
      exclude_customers.join("\n")
    end

    #
    # Should we turn on more verbose logging of actions taken?
    def use_logger?
      config.present? and config[:use_logger] == true
    end

  end

end
