FROM debian:bookworm-slim

RUN apt-get update -y

# pre-reqs and dependencies for Mongodb community server
RUN apt-get install -y gnupg curl
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
RUN echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
RUN apt-get update -y

# Mongodb
RUN apt-get install -y mongodb-org

# pre-reqs and dependencies for unifi
RUN apt-get install -y binutils openjdk-17-jre-headless logrotate procps

# Download from https://ui.com/download and copy in current dir before running `podman-compose build`
COPY unifi_sysvinit_all.deb /var/tmp/
RUN dpkg -i /var/tmp/unifi_sysvinit_all.deb

# Change startup, see README
RUN sed -i '/^if /,/^fi$/d' /etc/init.d/unifi

CMD exec /bin/bash -c "/etc/init.d/unifi start ; trap '/etc/init.d/unifi stop' TERM INT; sleep infinity & wait"
