FROM ruby:3.1.2

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . .

CMD bundle exec thin start -p 3000
