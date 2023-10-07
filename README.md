# FfcrmVend

A plugin for Fat Free CRM that provides several endpoints to receive Vend webhooks and update the data in a Fat Free CRM system.

## Installation

Add ```ffcrm_vend``` to your Fat Free CRM application Gemfile and run bundle install.

```gem 'ffcrm_vend', :github => 'crossroads/ffcrm_vend'```

## Setup

Once installated, you should start your Fat Free CRM server and go to the Admin section.
There you can click on the "Vend" tab and set various options.

* Vend ID - this is the id of your vend instance. Used to provide links back to the sales in Vend.
* Token - this is the token that is shared between your app and the webhook provider to authenicate requests. A token is generated for you by default.
* Default User - select a user that will be the owner of requests that come in from the Vend webhook. Not all webhooks include data about who performed the action. In these cases, this user is used.
* Sale prefix - text to use for the name of the opportunity that will be created whenever a sale is made. (more details below)

## Vend Setup

* Login to your Vend instance and goto /setup/api (https://your-vend-id.vendhq.com/setup/api)
* Click "Add webhook"
* Enter the register_sale url
 * E.g. https://your-fat-free-crm-instance.com/vend/register_sale?token=b6ONSq5FnxdbIwRF3lKnlQ
 * You can find this url listed on the admin vend screen (see Setup above)
* Select ```sale.update``` as the webhook type and save.
* Click on "Add webhook" again
* Enter https://your-fat-free-crm-instance.com/vend/customer_update?token=b6ONSq5FnxdbIwRF3lKnlQ as the URL
* Select ```customer.update``` as the webhook type and save.

## Webhook consumers

FfcrmVend provides the following controller actions that consume Vend webhooks.

### RegisterSale

The ```/vend/register_sale``` route responds to the ```sale.update``` payloads from Vend (see http://docs.vendhq.com/api/1.0/register-sale.html).

When a sale webhook comes in, FfcrmVend does the following:

* Determines the user that carried out the action and sets the ```PaperTrail.whodunnit``` field
 * The username of the Vend cashier who made the sale is usually included in the payload. If there is a corresponding user with the same email address or username in Fat Free CRM, then they are selected. Otherwise, the default user (set in the Admin -> Vend tab) is used.
* Checks to see if the customer name is in the exclusion list (see Admin tab -> Vend). If so, halts execution and returns 200 OK.
* Looks for the customer in Fat Free CRM.
 * FfcrmVend adds a Contact custom field called ```cf_vend_customer_id```. If a customer is found with this id, then the sale is associated with this user. If no customer is found, a new contact is created.
* Creates a new ```won``` opportunity and associates this with the customer.
 * The opportunity is named "[sale prefix] XX", where [sale prefix] is set in the Admin -> Vend tab and XX is the Vend invoice number.
 * The opportunity ```closes_on``` value is set to the date of the sale.
 * The opportunity ```amount``` is set to the total value of the sale and the ```probability``` to 100% so that the ```weighted_value``` reports correctly.
* A new ```comment``` is made on the opportunity with the url pointing back to the sale in Vend.
 * This url is constructed using the Vend ID in Admin -> Vend settings.

Note: that the above actions take place inside a transaction. This means that in the event of an error, all the data is rolled back. It's all or nothing!

### Customer

The ```/vend/customer_update``` route responds to Vend's ```customer.update``` webhook. When fired, the following happens:

* Sets the ```PaperTrail.whodunnit``` field to the default user (set in the Admin -> Vend tab).
 * The ```customer_update``` hook from Vend does not include the user who made the update so we always the default user.
* Checks to see if the customer name is in the exclusion list (see Admin tab -> Vend). If so, halts execution and returns 200 OK.
* Looks for the customer in Fat Free CRM.
 * FfcrmVend adds a contact custom field called ```cf_vend_customer_id```. If a contact is found with this id, then the contact update affects this record.
 * If no existing contact is found, the email address is used to search in the ```email``` and ```alt_email``` fields. The first contact to match is used.
 * If no existing contact is found, a new contact record is created.
* Contact update procedure
 * The ```first_name``` and ```last_name``` fields of the contact are overriden
 * The ```phone``` field is overriden
 * If either the contact ```email``` or ```alt_email``` fields already match the new email, no email update occurs
 * If neither the contact ```email``` nor ```alt_email``` match the new email, then it is added to the ```email``` field (if it is empty), otherwise to the ```alt_email``` field
 * If the contact has no ```business_address```, it is filled in with the new data.

Note: data is not overriden if the new value is blank.

## Tests

Run ```rake``` to setup the database and run the specs.

## Manual testing

During development, you can use the code below to simulate an incoming Vend webhook on your local machine.
Note: requires the ```nestful``` gem (https://github.com/maccman/nestful).

Install the nestfull gem (```gem install nestful```), run your rails server and open up an irb session.

* To fire a ```register_sale``` webhook use:

  ```
  require 'nestful'
  token = "your-token"
  payload = File.open('/path/to/ffcrm_vend/spec/requests/fixtures/register_sale.json').read
  Nestful.post 'http://localhost:3000/vend/register_sale', :format => :json, :payload => payload, :token => token
  ```

* To fire a ```customer_update``` webhook use:

  ```
  require 'nestful'
  token = "your-token"
  payload = File.open('/path/to/ffcrm_vend/spec/requests/fixtures/customer_update.json').read
  Nestful.post 'http://localhost:3000/vend/customer_update', :format => :json, :payload => payload, :token => token
  ```

## Bug Fixes / Contributions

Please open issues in the GitHub issue tracker and use pull requests for new features.

## License

Copyright Crossroads Foundation 2013

This is "Charityware" i.e.you can use and copy it as much as you like,
but you are encouraged to make a donation for those in need via the
Crossroads Foundation (the organisation who built this plugin). See http://www.crossroads.org.hk/

Full license pending

## Authors

* Ben Tillman (ben.tillman@gmail.com)
* Steve Kenworthy (steveyken@gmail.com)
