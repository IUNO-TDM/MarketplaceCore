FROM library/postgres

ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB MarketplaceCore

ADD database_init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
