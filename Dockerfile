FROM ruby:2.3.8

# Fix archived Debian Stretch repositories
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list

# Install dependencies
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated \
    build-essential \
    libpq-dev \
    postgresql-client \
    git \
    imagemagick \
    locales && \
    rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Set Rails env
ENV RAILS_ENV=production
ENV RACK_ENV=production

WORKDIR /app

# Install bundler
RUN gem install bundler -v 1.17.3

# Copy Gemfile and install gems
COPY Gemfile ./
RUN bundle install --without development test --jobs 4 --retry 3

# Copy app code
COPY . .

# Create necessary directories
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log public/uploads

# Precompile assets (skip if DB not available)
RUN bundle exec rake assets:precompile RAILS_ENV=production --trace 2>/dev/null || true

EXPOSE 3000

CMD ["bundle", "exec", "thin", "start", "-p", "3000", "-e", "production", "--threaded"]
