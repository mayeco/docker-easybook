FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        php5-cli \
        git-core \
        curl \
        ssh \
        vim-tiny \
        php5-curl \
        php5-gd \
        php5-imagick \
        php5-intl \
        php5-mcrypt \
        libgif4 \
        software-properties-common \
        python-software-properties \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu trusty multiverse"

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ttf-mscorefonts-installer --quiet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

RUN curl -O http://www.princexml.com/download/prince_10r3-1_ubuntu14.04_amd64.deb \
    && dpkg -i prince_10r3-1_ubuntu14.04_amd64.deb \
    && apt-get -f install \ 
    && rm -f prince_10r3-1_ubuntu14.04_amd64.deb

RUN composer create-project easybook/easybook /easybook

WORKDIR /easybook

VOLUME ["/easybook/doc"]

VOLUME ["/easybook/app/Resources"]

RUN chmod +x book

ENTRYPOINT ["/easybook/book"]
