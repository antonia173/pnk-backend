## README
Project for Information Systems course at FER-UniZg. 
Key Features:
* Master-Detail Form
* Three-Tier Architecture

## Setup

* install ruby '3.1.2'

```
sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev                                                       
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 3.1.2
rbenv global 3.1.2
```
* install bundler
```
gem install bundler
```
* install rails
```
gem install rails -v 7.0.4
```

*  clone project repo 
```
git clone git@github.com:antonia173/pnk.git
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

## Running tests
```
bundle exec rspec
```