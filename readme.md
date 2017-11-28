## Setup

1. Install redis, postgresql, ruby, ruby on rails

2. Install the gems

		bundle install

3. Create the database (configure access to postgresql if necessary)

		bundle exec rake db:create
		bundle exec rake db:migrate

4. Start rails server (you will need to set the enviroment variables see below)

		bundle exec puma


### Enviroment variabls

	- MAIL_ADDRESS
	- MAIL_PASSWORD
	- WEATHER_API_KEY

*Note* `MAIL_ADDRESS` needs to be from mail.com

*Note* `WEATHER_API_KEY` is expected to be in the format of: `&APPID=xxxxxxxxxxxxxxxxxxxxxxxx`
