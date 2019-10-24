# qq939549054/openjdk11-openj9-fixfont:latest
# from https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/11/jdk/ubuntu/Dockerfile.openj9.releases.full
# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ubuntu:18.04
#not work ENV LANG='zh_CN.UTF-8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.UTF-8'
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

#RUN apt-get install -y
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 68818C72E52529D4
#NOT WORK RUN sed -i "s/archive.ubuntu.com/mirrors.cloud.tencent.com/g" "/etc/apt/sources.list"
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" "/etc/apt/sources.list"
RUN sed -i "s/security.ubuntu.com/mirrors.aliyun.com/g" "/etc/apt/sources.list"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates fontconfig locales ttf-dejavu  \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8

ENV JAVA_VERSION jdk-11.0.4+11_openj9-0.15.1

#BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.4%2B11_openj9-0.15.1/OpenJDK11U-jdk_x64_linux_openj9_11.0.4_11_openj9-0.15.1.tar.gz';
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       ppc64el|ppc64le) \
         ESUM='89b5efe77b690f5c0b304095b5e6548a03c7cf45b927a30676c1a891ded90560'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.4%2B11_openj9-0.15.1/OpenJDK11U-jdk_ppc64le_linux_openj9_11.0.4_11_openj9-0.15.1.tar.gz'; \
         ;; \
       s390x) \
         ESUM='8b63bca7ccf48faea6184e3539eda636ab6904cd7877ba8d1672e6c7e3f60412'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.4%2B11_openj9-0.15.1/OpenJDK11U-jdk_s390x_linux_openj9_11.0.4_11_openj9-0.15.1.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='b1099cccc80a3f434728c9bc3b8a90395793b625f4680ca05267cf635143d64d'; \
         BINARY_URL='https://temp-1255437190.cos.ap-guangzhou.myqcloud.com/OpenJDK11U-jdk_x64_linux_openj9_11.0.4_11_openj9-0.15.1.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
ENV JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle"

CMD ["jshell"]
