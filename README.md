# GnipApi

Connect with different Gnip APIs and get data from streams. Currently
Full Archive Search and PowerTrack APIs for Twitter data are implemented.

Documentation about Gnip APIs can be found here[http://support.gnip.com/].

Gnip API status page can be found here[https://status.gnip.com/]

## What is Gnip?

A Twitter division that offers access to Twitter data both historically and in
real time. Gnip is not restricted to Twitter only though, it offers a set of
different data sources you can integrate, Twitter is their main one of course.

# Gnip APIs

## Full Archive Search

It provides historical data with some aggregiations and can fetch both activities
and counts over a period of time. There are some limitations so be sure to 
check the documentation.

Search API could return a 503 Software Error, which to me is just a different
way of a 500 error. Usually this happens on specific situations with specific
queries, however, it's not repeatable 100% of the time. If you encounter this
error, make your script wait for some seconds and retry. Alternatively you
can break down further the rules you're using or the periods. As far as I'm
aware of, it's likely to happen when querying large amounts of data on wide
periods.

## PowerTrack

Provides ways to setup rules that act as filters/matchers and an HTTP stream
endpoint that will send the results to the consumer.

The HTTP stream can suffer from unexpected connection loss.
Sometimes it's intended from Gnip, and sometimes it doesn't seem so. Depending
on what you're doing with the received data, you may be disconnected due to a
slow consumer. Ideally you shouldn't do anything else than read and do processing
on a different process/thread. GnipApi offers a few different methods to deal
with this.

## A word about rules

It can be tricky to define proper rules. Please read the documentation on
each APIs to know how rules work. Search API and PowerTrack both use similar
rule structure, but there are differences between what can each do.

In some cases a rule can match undesired information. This is because Gnip
tokenizes the data and applies the rules to that parsed data. For example,
URLs can be matched by accident, and it won't be clear why exaclty. Gnip
doesn't mention what fields of a source object is considering to match
so be sure to target the matching properly.

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnip_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gnip_api

Use the master branch to get more frequent updates on this gem.

# Usage

## Configure the gem

```ruby
GnipApi.configure |config|
  config.user = 'someone' # Gnip Account Username
  config.password = 'something' # Gnip Password
  config.account = 'myGnipAccount' # Your accounts name
  config.logger = Logger.new('myLog.log') # You can also provide a custom logger
  config.source = 'twitter' # General source, if none defined when quering, this will be used
  config.label = 'mystream' # General stream label, if none defined when quering, this will be used
  config.request_timeout = 120 # Default time out on all requests, defaults to 60
  config.debug = false # Defaults to false, enables/disables debug output on log
  config.log_level = Logger::WARN # Set it to Logger::DEBUG if you have problems to inspect queries and data
  config.buffer_limit = 50000 # Number of chars to limit stream buffer, will show warnings if excedded
end
```

Put the avobe code in an initializer if you're using Rails, or somewhere else if you aren't. After that you can interact with Gnip APIs.

Note that you'll need a source and a label. Source is the data source within Gnip, such as Twitter, and label is the identifier of your stream.

## Search API


### Some notes

While using the Full Archive Search or FAS as we call it we faced some issues that you may encounter as 
well if you use it. The most notorious one is the 503 "You encountered a problem in our software" which 
is mentioned avobe. Upon troubleshooting this error, the client side "solution" or workaround to better 
put it, is to iterate from the client the period. Instead of letting GNIP paginate the data build smaller 
periods of time. For example, instead of requesting from year 2016 to 2017, do 12 requests of 1 month each.
We found that making this period size smaller and smaller ends up making it work. A higher process built
using this gem splits any given period in smaller ones and iterates over the data, re running missing periods
split further to fill in missing data. The smalles period that seems to have 100% chances of success is 1 hour.
If you wonder who came up with this ugly solution, the answer is GNIP itself, upon talking to their support
area about this. It doesn't seem proper to include this on the gem since this errors is not supposed to happen,
but it may eventually be included as an alternative querying to mitigate the problem. 

### Overview

The Search API allows you to get counts or activities in a time period, with a maximum period size of 30 days per request. PowerTrack rules are used as query parameter, but be careful **PowerTrack operators may not be supported on Search API or could behave differently**. Read the Gnip docs to make sure.
To access the Search API you will need a rule first, you can use PowerTrack Rule object for it:

```ruby
rule = GnipApi::PowerTrack::Rule.new :value => 'keyword1 OR keyword2'
```

Then you can query the search endpoint to get counts or activities. For counts:

```ruby
results = GnipApi::Search.new.counts :rule => rule
```

For activities:

```ruby
results = GnipApi::Search.new.activities :rule => rule
```

Responses are parsed, so you can then use the output normally as any other Ruby object. For the case of activities, they get converted to Gnip::Activity objects, and have all the rest parsed as they would came from stream.

You can set different parameters:

```ruby
results = GnipApi::Search.new.counts :rule => rule, :from_date => DateTime.parse('2016-01-01 00:00'), :to_date => DateTime.parse('2016-05-01 22:00'), :bucket => 'day'
```

For activities, there are a few extra considerations:

- A param ```:max_results``` indicates how many activities to return on a response, valid values are from 10 to 500, default is 100, this param does not work on counts.
- As you noticed, you pass a ```GnipApi::PowerTrack::Rule``` object to the search endpoint, and as you may also know, these objects have mostly 2 things: value (actual rule), and tag. When querying activities on the Search API, you can optionally use a tag that is returned on the activity, along with the rule. This tag is deduced from the rule object you pass, in other words, if you want a tag, add it on the ```GnipApi::PowerTrack::Rule``` object, it's not a valid param for the method.
- The ```:bucket``` option is only for counts.

When you query for more than 30 days or more activities than ```:max_results```, the results will include a ```:next``` token to iterate over the remaining pages. You can instantly feed this token to a following request with same parameters:

```ruby
results = GnipApi::Search.new.counts :rule => rule, :from_date => DateTime.parse('2016-01-01 00:00'), :to_date => DateTime.parse('2016-05-01 22:00'), :bucket => 'day', :next_token => 'token_from_previous_request'
```

## PowerTrack

PowerTrack API has various functions. You can upload, delete and get rules and you can stream the activities. To create rules you need to create the rule objects:

```ruby
rules = [] 
rules << GnipApi::PowerTrack::Rule.new :value => 'keyword1 OR keyword2', :tag => 'first_rule'
rules << GnipApi::PowerTrack::Rule.new :value => 'keyword3 keyword4', :tag => 'second_rule'
```

Once you have your rule objects set, you can put them into an array and feed them to the PowerTrack Rules API:

```ruby
GnipApi::PowerTrack::Rules.new.create rules
```

That will upload the rules to the stream. The endpoint doesn't return anything on success but it will validate rules before applying and any syntax error will be raised as an error.

To get a list of rules defined in the stream:

```ruby
GnipApi::PowerTrack::Rules.new.list
```

That will return an array of GnipRule::PowerTrack::Rule objects. In the same way as the upload the delete method removes 1 or more rules:

```ruby
GnipApi::PowerTrack::Rules.new.delete rules
```

Same as upload, no response from Gnip when deleting.
**Important**: There's no mapping between PowerTrack Rules and the rules you create, and they do not generate any identifier. Gnip suggests to generate an UID including the tag, to create an identifier and keep the mapping. When you delete a rule, the rule you are sending **needs to be exaclty the same you used on upload**, otherwise you would be trying to delete a non-existent rule or deleting a different rule, both cases without error from Gnip alerting this. Running a hash function over the JSON rule should do the trick.

Finally, you can stream the activities and do something with them:

```ruby
GnipApi::PowerTrack::Stream.new.consume do |messages|
  messages.select{|m| m.activity?}.each{|a| puts a.body}
  messages.select{|m| m.system_message?}.each{|s| puts s.message}
end
```

# Documentation

RDoc was integrated for this gem and documents will be included in the repo to browse.
You can execute:

    $ rake rdoc

To regenerate it. Browse doc/rdoc/index.html to inspect the bundled documentation.

# WIP State

Various Gnip features aren't implemented yet and I lack access to them. I could
implement them from documentation alone, but given the experience I have with Gnip,
it might not work at all.

# Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Feel free to ask/suggest ideas or features, or to report any bugs or issues.

This library was constructed with the help of [Armando Andini](https://github.com/antico5) who provided the basis to connect with the Gnip APIs.
