# Copyright 2016 Samsung SDS Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.2

ENV NETWORK_HOST=_site_


RUN bin/elasticsearch-plugin install io.fabric8:elasticsearch-cloud-kubernetes:5.5.2
ADD elasticsearch.yml /usr/share/elasticsearch/config/
USER root
RUN yum install -y sudo && \
    yum clean all && \
    echo "elasticsearch ALL= NOPASSWD: /usr/bin/chgrp -R 1000 /usr/share/elasticsearch/data" > /etc/sudoers.d/elasticsearch && \
    chmod 0440 /etc/sudoers.d/elasticsearch

RUN sed -i '/exclude=java-1.8.0-openjdk*/d' /etc/yum.conf  && \
    yum install -y java-1.8.0-openjdk-headless nss-sysinit nss nss-tools && \
    yum remove -y wget && \
    chown elasticsearch:elasticsearch config/elasticsearch.yml



USER elasticsearch

# Modify permissions of /usr/share/elasticsearch/data before we start elasticsearch
RUN sed -i '$isudo /usr/bin/chgrp -R 1000 /usr/share/elasticsearch/data' /usr/share/elasticsearch/bin/es-docker
