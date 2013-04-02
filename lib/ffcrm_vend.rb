require "ffcrm_vend/engine"

module FfcrmVend

  class << self

    # Used in the admin section to apply settings
    def settings=(options)
      Setting[:ffcrm_vend] = {:vend_id => options[:vend_id],
                              :user_id => options[:user_id],
                              :sale_prefix => options[:sale_prefix],
                              :token => options[:token],
                              :exclude_customers => options[:exclude_customers],
                             }
    end

    # ID of the vend instance in use
    def vend_id
      Setting.ffcrm_vend.present? ? Setting.ffcrm_vend[:vend_id] : ''
    end

    # Helper to return the url to the Vend instance
    def vend_url
      URI("https://#{vend_id}.vendhq.com/")
    end

    # When a sale occurs, this plugin will create opportunities of the form "[prefix] [order number]"
    # Example: if prefix is set to "My Sale", then the opportunity name would be "My Sale 15"
    # Defaults to "Vend Sale" if left blank.
    def sale_prefix
      if Setting.ffcrm_vend.present?
        unless (prefix = Setting.ffcrm_vend[:sale_prefix]).blank?
          return prefix
        end
      end
      'Vend Sale'
    end

    # Vend webhooks don't always supply details about who updated the record
    # We use email below to choose a fallback.
    def user_id
      Setting.ffcrm_vend.present? ? Setting.ffcrm_vend[:user_id] : ''
    end

    # The token is used to authenticate incoming feeds.
    def token
      Setting.ffcrm_vend.present? ? Setting.ffcrm_vend[:token] : nil
    end

    def exclude_customers
      if Setting.ffcrm_vend.present? and !(exclude = Setting.ffcrm_vend[:exclude_customers]).blank?
        exclude.split(/\n+/).compact.uniq
      else
        []
      end
    end

    def default_user
      if Setting.ffcrm_vend.present?
        unless (user_id = Setting.ffcrm_vend[:user_id]).blank?
          return User.where(:id => user_id).first
        end
      end
      nil
    end

    #
    # Checks to see if customer is in the exclusion list.
    # If so, the sale is not registered in FFCRM.
    # Blank names return false, matching names return true
    #
    def is_customer_in_exclusion_list?(first_name, last_name)
      name = [first_name, last_name].join(' ')
      !name.strip.blank? and FfcrmVend.exclude_customers.include?(name)
    end

  end # class

end
