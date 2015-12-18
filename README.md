# Spektrix client library for Ruby
This is a client library for the [Spektrix ticketing platform](https://www.spektrix.com/). You'll need a user account / client name, a private/public keypair and an API ID.

This library covers most of the stuff you might need to do to pull events and prices from the database to include on your own website. It doesn't write back to the API, and doesn't include other endpoints (although feel free to add these and send us a PR!).

# Setup

## Installation

You can either install using [bundler](http://bundler.io) or just from the command line.

### Bundler
Include this in your gemfile

`gem 'spektrix'`

That's it! this is in active development so you might prefer:

`gem 'spektrix', github: "errorstudio/spektrix"`
 
### Using Gem
As simple as:

`gem install spektrix`

## Configuration
You need to configure spektrix with a block, like this:

```
Spektrix.configure do |config|
  config.client_name = "yourclientname"
  config.client_key_path = File.join(Rails.root,"config","certs","your.private.key") # don't commit this into version control.
  config.client_cert_path = File.join(Rails.root,"config","certs","your.signed.cert.crt") #the cert you get back from the Spektrix team
  config.api_key = "your API key from the spektrix interface"
  # config.proxy = "https://localhost:9998" #a proxy if you want to use it.  Proxies don't usually forward client certs so YMMV.
  # config.base_url = "http://localhost:8000" #if you don't want to hit the Spektrix API for some reason - e.g. locally hosted XML for testing.
  # config.api_path = "" # defaults to /api/v2 - only here for testing really.
end
```

# Use

## Events, instances and prices
Events have instances, which in turn have seating plans and a price list. Seating plans aren't catered for, but bands and ticket types are.

```
include Spektrix #You don't have to do this, just prefix all the calls with `Spektrix::` otherwise
Events::Event.first #get the first event in the list
e = Events::Event.find(123) #or get a specific event by ID
instances = e.instances # A list of Spektrix::Event::Instance objects
i = instance.first
i.prices #a list of Spektrix::Ticket::Price objects
p = i.prices.first #a Price object
p.band #a Spektrix::Tickets::Band object - this just has a name
p.ticket_type #a Spektrix::Tickets::Type object - this just has a name
p.price #a string representation of the price
```

### Getting a list of lower-level objects directly
Because the API doesn't follow REST, we actually make a bunch of HTTP calls in the example above. That has an advantage that you can call a collection of lower-level entities without having to get the 'parent'.

```
Spektrix::Tickets::Band.all #a collection of bands
Spektrix::Tickets::PriceList.where(event_id: 123) #the prices for event 123, without calling the Event itself.
```

## Custom Attributes
Spektrix allows you to set custom attributes for various objects. This library handles these automatically, and they're accessible as instance variables on your objects.

# Contributing
We'd love to have your input if you're making use of this:

1. Fork the repo
2. Make any changes in a branch
3. Squash your changes into sensible commits
4. Make a PR on your fork

# Licence
Licensed under MIT - see LICENCE.txt. Have fun!








