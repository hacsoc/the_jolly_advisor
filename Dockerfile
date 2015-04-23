FROM rails:onbuild

RUN apt-get update && apt-get install -y vim --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN RAILS_ENV=production rake assets:precompile
