# HasUnpublishedPassword

## What is it?

This is a gem which performs offline checks against the [HIBP](https://haveibeenpwned.com/) master list (well, the top 11,000,000 passwords in it).

It can be used to ensure that your users are not using credentials which have previously been leaked.

The checks are performed using a pre-built bloom filter.

### Why not the full list?
There's a tradeoff to be made between the false positive rate, the number of passwords checked, and the amount of disk/network bandwidth used.

The full list is ~11gb compressed, and the smallest bloom filter that'll get an acceptable false positive rate on the full list is ~1gb. This gem is 32mb.

## Status

In use in production on a fairly large site (https://radiopaedia.org).

The released version of this gem includes ~30mb of bloom filter containing the top 11,200,000 most-leaked passwords according to HIBP.

Checking set membership is *fast*, and the false positive rate is about 0.001%.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_unpublished_password'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_unpublished_password

## Usage

### Validation

`validates :password, never_leaked_to_hibp: true`

## Development

### Building the filter

First, download the master list from HIBP (I used the 'ordered by frequency' list) and decompress it.

Then, run `bundle exec data/prepare-and-validate.rb <path-to-master-list-file>`.

This takes quite awhile; it'll print how many lines it's completed periodically.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danielheath/has_unpublished_password. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HasUnpublishedPassword project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/has_unpublished_password/blob/master/CODE_OF_CONDUCT.md).

