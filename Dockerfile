# ---------------------------------------------
# Overleaf Community Edition (overleaf/overleaf)
# ---------------------------------------------

FROM sharelatex/sharelatex-base:latest

ENV SHARELATEX_CONFIG /etc/sharelatex/settings.coffee


# Checkout Overleaf Community Edition repo
# ----------------------------------------
RUN git clone https://github.com/overleaf/overleaf.git \
	--depth 1 /var/www/sharelatex


# Install dependencies needed to run configuration scripts
# --------------------------------------------------------
COPY root/build/ /
RUN cd /var/www && npm install


# Checkout services
# -----------------
RUN cd /var/www/sharelatex && \
	npm install && grunt install;


# install and compile services
# ----------------------------
RUN bash -c 'cd /var/www/sharelatex && source ./bin/install-services'
RUN bash -c 'cd /var/www/sharelatex && source ./bin/compile-services'


# Links CLSI sycntex to its default location
# ------------------------------------------
RUN ln -s /var/www/sharelatex/clsi/bin/synctex /opt/synctex


# Change application ownership to www-data
# ----------------------------------------
RUN	chown -R www-data:www-data /var/www/sharelatex;


# Copy the run time configuration files
# --------------------------------------------------
COPY root/run/ /


# Stores the version installed for each service
# ---------------------------------------------
RUN cd /var/www && node git-revision > revisions.txt


EXPOSE 80

WORKDIR /

ENTRYPOINT ["/sbin/my_init"]

