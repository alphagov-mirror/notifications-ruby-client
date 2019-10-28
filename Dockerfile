FROM ruby:2.4-slim

RUN \
	echo "Install Debian packages" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		gcc \
		make \
		curl \
		git \

ENV PATH=/var/project/vendor/bin:$PATH \
    BUNDLE_PATH="/var/project/vendor/bundle" \
    BUNDLE_BIN="/var/project/vendor/bin" \
    BUNDLE_APP_CONFIG="/var/project/.bundle"


WORKDIR /var/project
