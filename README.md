### Abulafia

### Instalation

1. Make sure, you have ruby 1.9 installed, if not we recommend you to use [RVM](http://rvm.io/ "Ruby Version Manager")

2. Clone source code

  `git clone git://github.com/tataronrails/abulafia.git && cd abulafia`

3. Make config files. Go to `config` dir and make own `*.yml` files from `*.yml.sample`

4. Install gems running command `bundle`

5. Prepare database `bundle exec rake db:create db:migrate db:seed`

6. Start server `bundle exec rails s`

Enjoy it at [http://localhost:3000/](http://localhost:3000/ "Development server")


### Contributing

* Fork, fix, then send me a pull request.
