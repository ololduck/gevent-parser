# GeventParser (Gerrit event Parser)

This is mainly a script to describe what's happening on
[gerrit](https://code.google.com/p/gerrit/)'s `stream-events`.
It makes `stream-events` human-readable with pretty colors !

## Installation

This won't go on rubygems. It's too useless. So install it by hand :D

    $ git clone https://github.com/paulollivier/gevent-parser
    $ cd gevent-parser
    $ rake install

## Usage

Simply pipe the output of Gerrit's `stream-events` in the provided binary,
`gevent-parser`.

    $ ssh -p 29418 gerrit.example.com gerrit stream-events | gevent-parser

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

You are very welcome to improve the unit tests. I could learn a lot.

Bug reports and pull requests are welcome on GitHub at
https://github.com/paulollivier/gevent_parser. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

I mean, you can't seriously be a jerk with a project this small and fun, do
you?

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

