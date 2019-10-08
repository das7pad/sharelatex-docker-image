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
RUN cd /var/www \
&&    npm install \
  \
# Checkout services
# -----------------
&&  cd /var/www/sharelatex \
&&    npm install \
&&    grunt install \
  \
# install and compile services
# ----------------------------
&&  cd /var/www/sharelatex \
&&    bash ./bin/install-services \
&&    bash ./bin/compile-services \
  \
# Stores the version installed for each service
# ---------------------------------------------
&&  cd /var/www \
&&    node git-revision > revisions.txt


# Links CLSI sycntex to its default location
# ------------------------------------------
RUN ln -s /var/www/sharelatex/clsi/bin/synctex /opt/synctex


# Change application ownership to www-data
# ----------------------------------------
RUN	chown -R www-data:www-data /var/www/sharelatex;


# Copy the run time configuration files
# --------------------------------------------------
COPY root/run/ /


EXPOSE 80

WORKDIR /

ENTRYPOINT ["/sbin/my_init"]

