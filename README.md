# TfL Discord bot

A Discord bot too fetch TfL (Transport for London) data through their
public API (https://api.tfl.gov.uk).

This program is not affiliated in any way with TfL.

## Running the bot

You need:
* a client id and a bot token for discord itself, you can get them by
  registering the application on Discord.
* an application id and key by registering on the TfL API website

Then the bot can be run with (assuming you've set it up it with `bundler`):

    env DISCORD_CLIENT_ID='<your client id>' \
        DISCORD_TOKEN='<your bot token>' \
        TFL_APPLICATION_ID='<your tfl app id>' \
        TFL_APPLICATION_KEY='<your tfl app key>' \
        bundle exec ruby ./app.rb

Once started the bot will announce its invite URL. Follow that link to invite
the bot into channels you administer.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The application is available as open source under the terms of the
[GPLv3 licence](http://opensource.org/licenses/GPL-3.0).
