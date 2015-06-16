# GnipApi

You can connect with Gnip APIs with this gem and operate data. For now there's only a basic set of apis implemented, but I plan to include more in the future.
The PowerTrack stream consumer is available as well as the listing of rules. Full rules operation will be included later.
Also the gem will support different adapters, currently it's dependent of HTTParty, but I plan to remove this dependency and let the user choose which adapter to use, which can be a custom one of course. You will be able to define your own adapter to handle the http connections. 

## Notes

- Can't access Search API currently, so implementation will be directed by docs only.
- Rules endpoint are now rate limited.
- A simple rate limiter was implemented.
- You can configure the gem's mutex outside the gem if you plan to have concurrency. Very experimental for now.

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
  config.mutex = Mutex.new # Experimental thread safty, more below
end
```

Put the avobe code in a initializer if you're using Rails, or somewhere else if you aren't. After that you can interact with Gnip APIs.

Note that you'll need a source and a label. Source is the data source within Gnip, such as Twitter, and label is the identifier of your stream.

### Adapters

GnipApi is not dependent of a single adapter (there's a dependency with HTTParty, but shhh... it won't last too long). You can use one of the provided adapters, or you can make your own, using the BaseAdapter class. You only need to implement the desired connector POST, GET and DELETE methods. There's an extra stream_get method, but it's just a variant of GET.

The custom adapter does not require to live within the gem files, as long as GnipApi has access to your class, just put it in the config and you're ready to go. See the current adapters for reference.

### Mutex and Thread Safety

GnipApi has this feature in experimental stage, using a simple mutex to interact with the RateLimiter. The limiters are very simple, and should prevent your code executing more requests than it should. Depending where you are defining the mutex, you can elevate the coverage. GnipApi only requires an instance of Mutex, which you can place somewhere else for it to use.

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