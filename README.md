# Crew - Scheduling made simple

## Use cases

* Appointments, e.g. hair, photo
* Resource sharing, e.g. conference room, hot desk, bike pool
* Scheduling shifts for workers, e.g. service, retail
* Making sure all shifts and tasks are covered at large events, e.g. fairs, conferences
* Scheduling sales calls, allowing customers to add themselves to your calendar
* Match scheduling: enter teams, venus, available dates

## Status

Still in the planning stages.

## License

Still deciding on a license, but since the business plan is very similar to how [Sentry](https://github.com/getsentry/sentry) operates, [BSL](https://mariadb.com/bsl-faq-adopting/) would be the obvious choice.

The idea would be that the creators alone can offer a paid cloud version, but anyone else can self-host this system for their own use (not reselling the service to other companies). There will eventually be a migration path from self-hosted to cloud for organizations who outgrow their local install. Companies interested in selling a cloud service can inquire about custom licensing terms.

## Development

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributing

Have a use case that's currently not handled or could be handled better? You're probably not the only one.

1. Fork (<https://github.com/anamba/crew/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
