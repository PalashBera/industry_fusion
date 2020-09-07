FROM ruby:2.6.6

RUN curl https://deb.nodesource.com/setup_12.x | bash && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get clean && apt-get update &&  apt-get install -y build-essential libpq-dev imagemagick nodejs yarn

RUN mkdir -p /app
WORKDIR /app
COPY . .
# Add app files into docker image

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
# Add bundle entry point to handle bundle cache

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem install bundler -v 2.1.4
# Bundle installs with binstubs to our custom /bundle/bin volume path. Let system use those stubs.

# for yarn just run yarn install on your host machine
