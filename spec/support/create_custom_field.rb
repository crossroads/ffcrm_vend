#
# Ensure cf_vend_customer_id exists

RSpec.configure do |config|
  config.before(:suite) do
    unless CustomField.where(name: 'cf_vend_customer_id').size > 0
      field_group = FieldGroup.where(klass_name: "Contact", name: 'custom_fields').first
      field_group ||= FieldGroup.create(name: 'custom_fields', label: 'Custom Fields', klass_name: 'Contact') # doesn't exist in test db
      CustomField.create(as: 'string', name: 'cf_vend_customer_id', label: "Vend Customer ID", field_group: field_group)
    end
  end
end
