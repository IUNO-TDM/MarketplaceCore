FROM library/postgres

ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB MarketplaceCore

ADD patches /docker-entrypoint-initdb.d/

VOLUME /etc/postgresql/data
VOLUME /var/log/postgresql
VOLUME /var/lib/postgresql/data

EXPOSE 5432