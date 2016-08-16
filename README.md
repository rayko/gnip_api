### Important: Gnip will be ending support for v1 endpoints on December 1 of 2016. GnipApi will be updated to work with v2, backward compatibility won't be posible after the deadline.

# GnipApi

Connect with different Gnip APIs and get data from streams.

## Notes

- Search api will be added for v2 endpoints
- V2 endpoints for stream will be implemented before deadline
- RateLimiter and Mutex dropped due to lack of usage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnip_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gnip_api

## Usage

### Configure the gem

```ruby
GnipApi.configure |config|
  config.user = 'someone' # Gnip Account Username
  config.password = 'something' # Gnip Password
  config.account = 'myGnipAccount' # Your accounts name
  config.adapter_class = SomeAdapter # You can define your own adapter, more in the following section
  config.logger = Logger.new('myLog.log') # You can also provide a custom logger
end
```

Put the avobe code in a initializer if you're using Rails, or somewhere else if you aren't. After that you can interact with Gnip APIs.

Note that you'll need a source and a label. Source is the data source within Gnip, such as Twitter, and label is the identifier of your stream.

### Adapters

GnipApi is not dependent of a single adapter (there's a dependency with HTTParty, but shhh... it won't last too long). You can use one of the provided adapters, or you can make your own, using the BaseAdapter class. You only need to implement the desired connector POST, GET and DELETE methods. There's an extra stream_get method, but it's just a variant of GET.

The custom adapter does not require to live within the gem files, as long as GnipApi has access to your class, just put it in the config and you're ready to go. See the current adapters for reference.

## WIP State

GnipApi is still a WIP. Call it a beta, alpha, gem that has part of the features, whatever. Thing is, that it is currently usable. The custom adapter feature is there, and some of the APIs of Gnip were implemented. I'll be coding more things into this, such as other APIs, more limiters, request retries, error handling, different adapters for known connectors like RestClient or HTTP/net, etc.

In any case, you were warned about it. Feel free to fill my issues list on Github :)


## Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

This library was constructed with the help of [Armando Andini](https://github.com/antico5) who provided the basis to connect with the Gnip APIs.