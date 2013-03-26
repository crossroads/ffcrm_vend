# FfcrmVend

An endpoint that receives the vendhq.com webhooks and updates data in a Fat Free CRM system.

## Installation

Add ffcrm_vend to your Fat Free CRM application Gemfile and run bundle install.

```gem 'ffcrm_vend', :github => 'crossroads/ffcrm_vend'```
  
## Setup

Once installated, you should start your Fat Free CRM server and go to the Admin section. There you can click on the "Vend" tab
and set various options.

* Vend ID - this is the id of your vend instance. Used to provide links back to the sales in Vend.
* Default User - select a user that will be the owner of requests that come in from the Vend webhook. Not all webhooks include data about who performed the action. In these cases, this user is used.
* Sale prefix - text to use for the name of the opportunity that will be created whenever a sale is made. (more details below)

## Vend Setup

* Login to your Vend instance and goto /setup/api (https://your-vend-id.vendhq.com/setup/api)
* Click "Add webhook"
* Enter "https://your-fat-free-crm-instance.com/vend/register_sale" as the URL
* Select 'sale.update' as the webhook type and save.

Repeat the above for the 'customer.update' webhook, using https://your-fat-free-crm-instance.com//vend/customer as the URL.

## Endpoints

FfcrmVend provides the following endpoints to consume Vend webhooks.

### RegisterSale

This responds to the 'sale.update' payloads from Vend (see http://docs.vendhq.com/api/1.0/register-sale.html).

When a sale webhook comes in, FfcrmVend does the following:

* Determines the user that carried out the action.
 * The email address of the Vend user (cashier) who made the sale is usually included in the payload. If there is a corresponding user with the same email address in Fat Free CRM, then they are selected. Otherwise, the default user (set in the Admin -> Vend tab) is used.
* Looks for the customer in Fat Free CRM.
 * FfcrmVend adds a Contact custom field called 'cf_vend_customer_id'. If a customer is found with this id, then the sale is associated with this user. If no customer is found, a new contact is created.
* Creates a new 'won' opportunity and associates this with the customer.
 * The opportunity is named "[sale prefix] XX", where [sale prefix] is set in the Admin -> Vend tab and XX is the Vend invoice number.
 * The opportunity 'closes_on' value is set to the date of the sale.
 * The amount is set to the value of the sale and the probability to 100% so that the weighted_value reports correctly.
* A new comment is made on the opportunity with the url pointing back to the sale in Vend.
 * This url is constructed using the Vend ID in Admin -> Vend settings.

### Customer

This responds to the 'customer.update' webhook. When fired, the following happens:

* Details to follow

### Bug Fixes

Please open issues in the GitHub issue tracker.

## Tests

Run ```rake``` to setup the database and run the specs.
