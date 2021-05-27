FROM ruby:2.1.2

RUN apt-get update -qq
RUN apt-get install -y --force-yes build-essential libpq-dev nodejs imagemagick gnupg curl locales \
  && mkdir -p /usr/share/man/man1 \
  && mkdir -p /usr/share/man/man7 \
  && apt-get install -y --force-yes libmysqlclient-dev

# RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
#   && apt-get install -y nodejs

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


ENV INSTALL_PATH /usr/src/app

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN bundle install


VOLUME /bundle

# Add bundle entry point to handle bundle cache
# COPY docker/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/docker-entrypoint.sh"]
# ----------------------------------------

# Add bundle wait-for-postgres
# COPY wait-for-postgres.sh $INSTALL_PATH
# RUN chmod +x /usr/src/app/wait-for-postgres.sh
# ----------------------------------------

RUN apt-get install -y --force-yes curl

EXPOSE 3000
EXPOSE 3035