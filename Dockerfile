FROM ruby:2.2.3-onbuild

MAINTAINER Matthew Bentley <matthew.t.bentley@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      vim \
      postgresql-client \
      supervisor \
      cron \
      --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN whenever -w
RUN RAILS_ENV=production rake assets:precompile

EXPOSE 3000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
