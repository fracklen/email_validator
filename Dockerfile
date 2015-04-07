FROM lokalebasen/rubies:2.2.0
MAINTAINER Martin Neiiendam mn@lokalebasen.dk
ENV REFRESHED_AT 2015-04-07

WORKDIR /var/www/app/release

ENV ETCD_ENV email_validator
ENV RACK_ENV production

ADD Gemfile /var/www/app/release/Gemfile
ADD Gemfile.lock /var/www/app/release/Gemfile.lock

RUN bundle install --deployment --without development test && \
    mkdir -p /var/www/app/shared/pids                      && \
    mkdir -p /var/log/email_validator

ENV BUNDLE_GEMFILE /var/www/app/release/Gemfile

ADD build.tar /var/www/app/release

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/var/www/app/release/config/supervisord.conf"]
