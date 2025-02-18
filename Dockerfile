# Dockerfile

FROM ruby:3.3.0-alpine

RUN apk --update  add --virtual build-dependencies build-base nodejs npm postgresql-dev git \
                                linux-headers libsass-dev
RUN apk --update add libpq bash libxml2 libxml2-dev libxml2-utils libxslt openssl \
                     git libc6-compat gcompat libass less shared-mime-info tzdata

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN bundle install --jobs 4 --retry 3

ADD . /app/
COPY ./scripts/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

CMD ['rails', 'server', '-b', '0.0.0.0']
