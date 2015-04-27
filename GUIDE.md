# Using the BitPay Ruby Client Library
## Prerequisites
You must have a BitPay merchant account to use this library.  It's free to [sign-up for a BitPay merchant account](https://bitpay.com/start).

Once you have a BitPay merchant account, you will need [a working BitPay Access Token](/api/getting-access.html) – this can be done either [via the library](#pairing) or manually in [the BitPay Dashboard](https://bitpay.com/tokens).

## Quick Start
### Installation
```bash
gem install bitpay-rails
```

In your Gemfile:

```ruby
gem 'bitpay-rails', :require => 'bit_pay_rails'
```

### Configuration

The most basic configuration is to first run the migration for the gem, then configure the routes, then generate a controller for the BitPayClient model and set your environment variables.

#### Installing the model

```bash
$ bundle
$ rake bit_pay_rails_engine:install:migrations  
$ rake db:migrate
```

#### The routes

Add `resources :bit_pay_clients` to your `config/routes` file.

#### Controller
```bash
$ rails g scaffold_controller BitPayClient api_uri
$ export BPSECRET="this string can be almost anything but it is important that it is known"
$ export BPSALT="likeabove"
$ rails s
```

### Creating a New Client

After the last step, the rails server is running, so navigate to `http://localhost:3000/bit_pay_clients` and you should see a page with a link to create a new client. Click the link, and you should see the new client form, with one entry for the api\_uri. This is the address of the BitPay server that you want to use, either https://test.bitpay.com or https://bitpay.com. If you have a test.bitpay.com account, you can confirm that the plugin is working by creating your new client with "https://test.bitpay.com" as the uri.

#### Testing the client 

Open up a rails console. It's important that your environment variables are set in this terminal as well, or you will not be able to use the client.

```bash
$ rails c
2.2.2 :003 > client = BitPayClient.last
 => #<BitPayClient id: 1, api_uri: "https://test.bitpay.com", pem: "Sm1KQ2hhRnVYb3NET0JzOVQwT1RsUFpoRTB2YS9LWERsQ1NJV2...", facade: "merchant", created_at: "2015-04-27 17:33:52", updated_at: "2015-04-27 17:33:52"> 
2.2.2 :005 > client.get_pairing_code 
 => "BXyXLoV" 
```

At this point, in a browser, navigate to [https://test.bitpay.com/dashboard/merchant/api-tokens](https://test.bitpay.com/dashboard/merchant/api-tokens) and approve the pairing code that has been returned. Returning to our rails console:

```bash
2.2.2 :006 > client.create_invoice(price: 100, currency: "USD")
 => {"url"=>"https://test.bitpay.com/invoice?id=KsZaFPGbeP1fU3vwyqjSLD", "status"=>"new", "btcPrice"=>"0.450593", "btcDue"=>"0.450593", "price"=>100, "currency"=>"USD", "exRates"=>{"USD"=>221.93}, "invoiceTime"=>1430156419974, "expirationTime"=>1430157319974, "currentTime"=>1430156420024, "guid"=>"8044be4f-5e33-4f2a-92a7-e852f171eb3a", "id"=>"KsZaFPGbeP1fU3vwyqjSLD", "btcPaid"=>"0.000000", "rate"=>221.93, "exceptionStatus"=>false, "transactions"=>[], "flags"=>{"refundable"=>false}, "paymentUrls"=>{"BIP21"=>"bitcoin:mpjEFaaGsz6CFckdVmYquyhBFgRp2DK8hs?amount=0.450593", "BIP72"=>"bitcoin:mpjEFaaGsz6CFckdVmYquyhBFgRp2DK8hs?amount=0.450593&r=https://test.bitpay.com/i/KsZaFPGbeP1fU3vwyqjSLD", "BIP72b"=>"bitcoin:?r=https://test.bitpay.com/i/KsZaFPGbeP1fU3vwyqjSLD", "BIP73"=>"https://test.bitpay.com/i/KsZaFPGbeP1fU3vwyqjSLD"}, "token"=>"5qP6MeqxQmMfwRKdrEzH6jLLGnDW2fShxJZae7swPicQ6psa1YGqiruRKFfWKETc6E", "buyer"=>{}} 
```

The client generates a new invoice on test.bitpay.com and returns a map. When converting the map to your own invoice type or adding information to an existing invoice, the key piece of information from the invoice returned is the id, which is the best means of retrieving the invoice from bitpay if you want to issue refunds or watch for IPNs coming from the BitPay server. 
