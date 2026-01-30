FROM ruby:2.3.8

# Fix archived Debian Stretch repositories
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update -qq
RUN apt-get install -y --allow-unauthenticated build-essential libpq-dev nodejs imagemagick gnupg curl locales \
  default-libmysqlclient-dev \
  && mkdir -p /usr/share/man/man1 \
  && mkdir -p /usr/share/man/man7

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV INSTALL_PATH /usr/src/app
ENV RAILS_ENV production
ENV RACK_ENV production

WORKDIR $INSTALL_PATH

# Copiar Gemfile primeiro para cache de layers
COPY Gemfile Gemfile.lock ./

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN bundle install --without development test --deployment --jobs 4

# Copiar todo o código
COPY . .

# Precompilar assets
RUN bundle exec rake assets:precompile RAILS_ENV=production || true

# Criar diretórios necessários
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log public/uploads

EXPOSE 3000

# Dar permissão ao script
RUN chmod +x bin/render-start.sh

# Comando para iniciar
CMD ["bin/render-start.sh"]