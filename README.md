### Important: Gnip will be ending support for v1 endpoints on December 1 of 2016. GnipApi will be updated to work with v2, backward compatibility won't be posible after the deadline.

# GnipApi

Connect with different Gnip APIs and get data from streams.

## Recent Changes

- 2.0 APIs implemented partially, more will come soon
- Fixed a memory issue with HTTParty
- Timeout for requests added to fail if API is non responsive, time can be configured
- Search API returns parsed data either for counts or activities, which also makes Search API usable to get activities now
- Removed unused RateLimiter
- Removed unused Mutex
- Added source and label to config as default values
- Added Search API
- All APIs now default their parameters from config, you can still call an API with different label or source
- More docs

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
  config.source = 'twitter' # General source, if none defined when quering, this will be used
  config.label = 'mystream' # General stream label, if none defined when quering, this will be used
  config.request_timeout = 120 # Default time out on all requests, defaults to 60
end
```

Put the avobe code in an initializer if you're using Rails, or somewhere else if you aren't. After that you can interact with Gnip APIs.

Note that you'll need a source and a label. Source is the data source within Gnip, such as Twitter, and label is the identifier of your stream.

### Search API

The Search API allows you to get counts or activities in a time period, with a maximum period size of 30 days per request. PowerTrack rules are used as query parameter, but be careful **PowerTrack operators may not be supported on Search API or could behave differently**. Read the Gnip docs to make sure.
To access the Search API you will need a rule first, you can use PowerTrack Rule object for it:

```ruby
rule = GnipApi::Apis::PowerTrack::Rule.new :value => 'keyword1 OR keyword2'
```

Then you can query the search endpoint to get counts or activities. For counts:

```ruby
results = GnipApi::Apis::Search.new.counts :rule => rule
```

For activities:

```ruby
results = GnipApi::Apis::Search.new.activities :rule => rule
```

Responses are parsed, so you can then use the output normally as any other Ruby object. For the case of activities, they get converted to Gnip::Activity objects, and have all the rest parsed as they would came from stream.

You can set different parameters:

```ruby
results = GnipApi::Apis::Search.new.counts :rule => rule, :from_date => DateTime.parse('2016-01-01 00:00'), :to_date => DateTime.parse('2016-05-01 22:00'), :bucket => 'day'
```

For activities, there are a few extra considerations:

- A param ```:max_results``` indicates how many activities to return on a response, valid values are from 10 to 500, default is 100, this param does not work on counts.
- As you noticed, you pass a ```GnipApi::Apis::PowerTrack::Rule``` object to the search endpoint, and as you may also know, these objects have mostly 2 things: value (actual rule), and tag. When querying activities on the Search API, you can optionally use a tag that is returned on the activity, along with the rule. This tag is deduced from the rule object you pass, in other words, if you want a tag, add it on the ```GnipApi::Apis::PowerTrack::Rule``` object, it's not a valid param for the method.
- The ```:bucket``` option is only for counts.

When you query for more than 30 days or more activities than ```:max_results```, the results will include a ```:next``` token to iterate over the remaining pages. You can instantly feed this token to a following request with same parameters:

```ruby
results = GnipApi::Apis::Search.new.counts :rule => rule, :from_date => DateTime.parse('2016-01-01 00:00'), :to_date => DateTime.parse('2016-05-01 22:00'), :bucket => 'day', :next_token => 'token_from_previous_request'
```

### PowerTrack

PowerTrack API has various functions. You can upload, delete and get rules and you can stream the activities. To create rules you need to create the rule objects:

```ruby
rules = [] 
rules << GnipApi::Apis::PowerTrack::Rule.new :value => 'keyword1 OR keyword2', :tag => 'first_rule'
rules << GnipApi::Apis::PowerTrack::Rule.new :value => 'keyword3 keyword4', :tag => 'second_rule'
```

Once you have your rule objects set, you can put them into an array and feed them to the PowerTrack Rules API:

```ruby
GnipApi::Apis::PowerTrack::Rules.new.create rules
```

That will upload the rules to the stream. The endpoint doesn't return anything on success but it will validate rules before applying and any syntax error will be raised as an error.

To get a list of rules defined in the stream:

```ruby
GnipApi::Apis::PowerTrack::Rules.new.list
```

That will return an array of GnipRule::Apis::PowerTrack::Rule objects. In the same way as the upload the delete method removes 1 or more rules:

```ruby
GnipApi::Apis::PowerTrack::Rules.new.delete rules
```

Same as upload, no response from Gnip when deleting.
**Important**: There's no mapping between PowerTrack Rules and the rules you create, and they do not generate any identifier. Gnip suggests to generate an UID including the tag, to create an identifier and keep the mapping. When you delete a rule, the rule you are sending **needs to be exaclty the same you used on upload**, otherwise you would be trying to delete a non-existent rule or deleting a different rule, both cases without error from Gnip alerting this. Running a hash function over the JSON rule should do the trick.

Finally, you can stream the activities and do something with them:

```ruby
GnipApi::Apis::PowerTrack::Stream.new.consume do |messages|
  messages.select{|m| m.activity?}.each{|a| puts a.body}
  messages.select{|m| m.system_message?}.each{|s| puts s.message}
end
```

There are a few considerations to make when doing this:

- Gnip closes stream sometimes, either for operational reasons or because you can't handle the volume of data
- System messages include compliance notifications you should follow if you save the data locally
- Be careful when putting this into a daemon, closing the stream can be tricky given how this was done
- I've experience issues with a Zlib error that I currently couldn't debug and fix, if you build a daemon for this, be sure to code restart procedures

### Adapters

GnipApi is not dependent of a single adapter (there's a dependency with HTTParty, but shhh... it won't last too long). You can use one of the provided adapters, or you can make your own, using the BaseAdapter class. You only need to implement the desired connector POST, GET and DELETE methods. There's an extra stream_get method, but it's just a variant of GET. Keep in mind that Gnip uses compression, I found out that Excon doesn't decompress responses by default, just to name an example.
The custom adapter does not require to live within the gem files, as long as GnipApi has access to your class, just put it in the config and you're ready to go. See the current adapters for reference.

## WIP State

GnipApi is a WIP. Call it a beta, alpha, gem that has part of the features, whatever. It is currently usable and it's being used by... well.. me. The custom adapter feature is there, and some of the APIs of Gnip were implemented. I'll be coding more things into this, such as other APIs, request retries, error handling, different adapters for known connectors like RestClient or HTTP/net, etc.
In any case, you were warned about it. Feel free to fill my issues list on Github :)

## Gnip documentation for reference

[http://support.gnip.com/](http://support.gnip.com/)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

This library was constructed with the help of [Armando Andini](https://github.com/antico5) who provided the basis to connect with the Gnip APIs.
