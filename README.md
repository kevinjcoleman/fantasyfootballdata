# Fantasy Football Data

## To install for local development:

1. Setup [Docker](https://docs.docker.com/docker-for-mac/install/).
2. `cd` into your workspace and `git clone` this repo.
3. `cd` into the newly copied repo and run the following commands.
  - `docker-compose build`
  - `docker-compose run app rake db:create db:migrate db:seed`

4. Start the application with `docker-compose up`.
5. The app should now be running at [localhost:3000](localhost:3000)

## Some common rails development commands that you may need to run.

#### Install gems
1. No need for two windows here, just run `docker-compose run app bundle install`

#### To start a rails console session, you will need two windows open in the app directory.
1. In one window run `docker-compose up`. _This will start up the app and the postgres database and run them in that window. Press Ctrl-C to stop these processes*._
2. In the second window run `docker-compose run app rails c`. This will connect to the `app` container, which is the one running the rails app, the `postgres` container is the one that is running postgres.

#### To start a bash session in the app container.
1. Perform step 1 from above, and then run `docker-compose run app bash`, the parameter after `docker-compose run app` is the first command that will be ran upon container boot. If you leave it blank it defaults to running `rails server` you can see that in the [Dockerfile](https://github.com/kevinjcoleman/path-dashboard/blob/master/Dockerfile#L36).

#### Run specs
1. Once again, no reason for two windows, just run `docker-compose run web rspec`, you can optionally specify the name of an individual file like you normally would. IE `docker-compose run app rspec spec/path/to/spec.rb`

#### Tail the development logs to see what's happening in development.
1. Same instructions as starting a rails console session, just run `docker-compose run app tail -f log/development.log` instead.

### Frequently used commands

- `docker-compose up -d` - Bring up services in the background
- `docker-compose logs -f ${service}` - Tail logs for a service
- `docker-compose exec ${service} ${command}` - execute a command in a service
- `docker-compose ps` - list running services
- `docker-compose up -d --scale` ${service}=${n} - scale service to n instances. You can use this to scale down as well.
- `docker-compose port ${service} ${port}` - list port mappings for service, for this to work ports in the compose yaml file must be automatically assigned, i.e. "8080"
- `docker-compose restart ${service}` - restart a service
- `docker-compose run ${service} ${command}` - execute a command in a new container of a service


Use `lvh.me` locally.
