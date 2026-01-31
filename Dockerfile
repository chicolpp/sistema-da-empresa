FROM ubuntu:16.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libmysqlclient-dev \
    libpq-dev \
    nodejs \
    imagemagick \
    locales \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Install Ruby
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common && \
    add-apt-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ruby2.3 \
    ruby2.3-dev && \
    rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Set Rails env
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Install bundler
RUN gem install bundler -v 1.17.3

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test --jobs 4 --retry 3

COPY . .

RUN mkdir -p tmp/pids tmp/cache tmp/sockets log public/uploads

EXPOSE 3000

CMD ["bundle", "exec", "thin", "start", "-p", "3000", "-e", "production", "--threaded"]
