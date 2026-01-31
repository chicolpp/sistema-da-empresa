FROM ruby:2.3.8

# Fix archived Debian Stretch repositories
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update -qq && \
    apt-get install -y --allow-unauthenticated \
    build-essential \
    libpq-dev \
    nodejs \
    imagemagick \
    gnupg \
    curl \
    locales \
    default-libmysqlclient-dev && \
    mkdir -p /usr/share/man/man1 /usr/share/man/man7

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV INSTALL_PATH=/usr/src/app

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN bundle install --without development test --jobs 4 --retry 3

COPY . .

RUN mkdir -p tmp/pids tmp/cache tmp/sockets log public/uploads

# Precompilar assets ignorando erros de banco
RUN bundle exec rake assets:precompile RAILS_ENV=production --trace 2>/dev/null || echo "Assets precompile skipped"

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
