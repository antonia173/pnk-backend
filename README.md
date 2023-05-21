# README

* install ruby '3.1.2'

```
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 3.1.2
rbenv global 3.1.2
```

*  clone project repo
```
git clone 
```
*  install gems
```
bundle install
```
* create database from database.yml
```
bundle exec rake db:create
```

* run migrations to create database structure
```
bundle exec rake db:migrate
```
* run server on http://localhost:3000/
```
bundle exec rails s
```
