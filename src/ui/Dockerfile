FROM ruby:2.2-alpine3.4

ENV APP_HOME=/app \
    POST_SERVICE_HOST=post \
    POST_SERVICE_PORT=5000 \
    COMMENT_SERVICE_HOST=comment \
    COMMENT_SERVICE_PORT=9292

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN apk --no-cache --update add  \
    build-base=0.4-r1  && \
    bundle install && \
    apk del build-base

COPY . $APP_HOME



CMD ["puma"]
