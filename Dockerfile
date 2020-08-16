FROM ruby:2.6.6

RUN curl https://deb.nodesource.com/setup_12.x | bash && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get clean && apt-get update &&  apt-get install -y build-essential libpq-dev imagemagick nodejs yarn

WORKDIR /app

ADD . /app

RUN gem install bundler -v 2.1.4 && bundle install --jobs 20 --retry 5 && yarn install

ENTRYPOINT ["bundle", "exec"]
