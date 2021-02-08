FROM ruby:2.2-alpine3.4

ENV APP_HOME=/app \
    COMMENT_DATABASE_HOST=comment_db \
    COMMENT_DATABASE=comments
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN apk --no-cache --update add  \
    build-base=0.4-r1  && \
    bundle install && \
    apk del build-base

COPY . $APP_HOME



CMD ["puma"]
