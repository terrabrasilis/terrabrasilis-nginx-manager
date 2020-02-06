# To build image for this dockerfile use this command:
#   docker build -t terrabrasilis/nginx-manager:v0.3 -f Dockerfile .
#
# To run without compose and without shell terminal use this command:
#   docker run -d --rm --name terrabrasilis_nginx -v /tmp/nginx:/var/log/nginx terrabrasilis/nginx-manager:v0.3
#
FROM nginx:latest

LABEL "br.inpe.dpi"="INPE/DPI-TerraBrasilis"
LABEL br.inpe.dpi.terrabrasilis="NGINX Master"
LABEL version="v0.3"
LABEL main.author="Jether Rodrigues"
LABEL main.author.email="jetherrodrigues@gmail.com"
LABEL author="Andre Carvalho"
LABEL author.email="andre.carvalho@inpe.br"

RUN apt-get update && apt-get -y install cron tzdata && apt-get clean

RUN rm -f /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/403.html /usr/share/nginx/html/403.html

# Copy task.cron file to the cron.d directory
COPY config/task.cron /etc/cron.d/task.cron
COPY config/logrotate.sh /bin/logrotate.sh
COPY startup.sh /bin/startup.sh

# Give execution rights
RUN chmod 0644 /etc/cron.d/task.cron
RUN chmod +x /bin/logrotate.sh
RUN chmod +x /bin/startup.sh

# Apply cron job
RUN crontab /etc/cron.d/task.cron && \
    touch /var/log/cron.log && \
    service cron stop && \
    service cron start

EXPOSE 80 443

ENTRYPOINT ["bin/startup.sh"]

# Parametros extras para o entrypoint
#CMD ["-g", "daemon off;"]

