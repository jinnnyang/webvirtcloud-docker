FROM phusion/baseimage:jammy-1.0.1

EXPOSE 80

# apt换本地源
RUN sed -i 's#deb http://archive.ubuntu.com/ubuntu#deb http://nexus.nas.local/repository/ubuntu-jammy#g' /etc/apt/sources.list && \
    apt-get update -y

RUN echo 'APT::Get::Clean=always;' >> /etc/apt/apt.conf.d/99AutomaticClean

RUN apt-get update -qqy \
    && DEBIAN_FRONTEND=noninteractive apt-get -qyy install \
    --no-install-recommends \
    git \
    python3-venv \
    python3-dev \
    python3-lxml \
    python3-pip \
    libvirt-dev \
    zlib1g-dev \
    nginx \
    pkg-config \
    gcc \
    libldap2-dev \
    libssl-dev \
    libsasl2-dev \
    libsasl2-modules \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 更换pip源
RUN pip3 config set --global install.trusted-host devpi.nas.local && \ 
         pip3 config set --global global.index-url http://devpi.nas.local/root/aliyun

COPY . /srv/webvirtcloud
RUN mkdir -p /srv/webvirtcloud/data
RUN chown -R www-data:www-data /srv/webvirtcloud

RUN sed -i "/SECRET_KEY/c\SECRET_KEY = \"$(python3 /srv/webvirtcloud/webvirtcloud/secret_generator.py)\"" /srv/webvirtcloud/webvirtcloud/settings.py

# Setup webvirtcloud
WORKDIR /srv/webvirtcloud
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip3 install -U pip && \
    pip3 install wheel && \
    pip3 install -r requirements.txt && \
    pip3 cache purge && \
    chown -R www-data:www-data /srv/webvirtcloud

RUN . venv/bin/activate && \
    python3 manage.py makemigrations && \
    python3 manage.py migrate && \
    python3 manage.py collectstatic --noinput && \
    chown -R www-data:www-data /srv/webvirtcloud

# Setup Nginx
RUN printf "\n%s" "daemon off;" >> /etc/nginx/nginx.conf && \
    rm /etc/nginx/sites-enabled/default && \
    chown -R www-data:www-data /var/lib/nginx
RUN ln -s /srv/webvirtcloud/webvirtcloud/nginx.conf /etc/nginx/conf.d/webvirtcloud.conf

# Define mountable directories.
VOLUME ["/srv/webvirtcloud/data","/var/www/.ssh"]

WORKDIR /srv/webvirtcloud
COPY entrypoint.sh        /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]