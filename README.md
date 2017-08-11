# D2lImporter

D2L Importer is a simple plugin for Canvas that imports the most useful 
bits of D2L courses into Canvas.  This is meant to be loaded into Canvas
LMS via the plugin architecture.

## Installation

Download the source tree, unzip it, and stick it in the canvas plugins directory at `gems/plugins/`.
Then you'll want to add the following line to `/app/views/content_migrations/index.html.erb` to get started
`  js_bundle :content_migration, plugin: :d2l_importer`

## Usage

Ideally once this is all working you'll be able to import things from D2L
by using the built in converter.

## Development

Development is really similar to developing for Canvas.  Check out [their docs](https://github.com/instructure/canvas-lms/tree/stable/doc)
to get started developing this. Once that's all setup, you're not far from having a real development environment.

There's a couple ways to do this depending on how much RAM you have.  16GB is not enough for the high RAM setup.

### Low RAM setup
In this project, setup ruby and get all the gems, then run specs.

```
bundle install
bundle exec rspec spec
```

#### spec_canvas
The first time will be really slow, but after that things will be quite fast to rerun, just don't exit the docker worker.
```
docker-compose run --rm web bash
spring rspec gems/plugins/d2l_importer/spec_canvas/ 
```

### High RAM setup
Do all the above, and then execute `docker-compose up` in another terminal.  You'll have to manually restart this 
for every code change.
