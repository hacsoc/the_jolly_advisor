FROM ruby:2.2.2-onbuild

RUN apt-get update && apt-get install -y vim --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN RAILS_ENV=production rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]


