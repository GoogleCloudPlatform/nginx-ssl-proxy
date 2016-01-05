# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#
# nginx-ssl-proxy
#
# VERSION   0.0.1

FROM nginx

MAINTAINER Evan Brown <evanbrown@google.com>

RUN rm /etc/nginx/conf.d/*.conf

WORKDIR /usr/src

ADD start.sh /usr/src/
ADD nginx/nginx.conf /etc/nginx/
ADD nginx/proxy*.conf /usr/src/
ADD nginx/default*.conf /usr/src/

RUN mkdir /etc/nginx/snippets/
RUN mkdir -p /tmp/letsencrypt/.well-known/acme-challenge/
RUN echo "OK" > /tmp/letsencrypt/.well-known/acme-challenge/health
ADD nginx/letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf

CMD ["./start.sh"]
