FROM neo4j:latest

COPY wrapper.sh wrapper.sh

# Where the load the cyphers to seed the database
VOLUME /kb

ENTRYPOINT ["./wrapper.sh"]
