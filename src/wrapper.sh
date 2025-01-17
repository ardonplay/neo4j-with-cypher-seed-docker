#!/bin/bash

NEO4J_LOGIN=$(echo $NEO4J_AUTH | cut -d "/" -f 1)
NEO4J_PASS=$(echo $NEO4J_AUTH | cut -d "/" -f 2)

# Log the info with the same format as NEO4J outputs
log_info() {
  # https://www.howtogeek.com/410442/how-to-display-the-date-and-time-in-the-linux-terminal-and-use-it-in-bash-scripts/
  printf '%s %s\n' "$(date -u +"%Y-%m-%d %H:%M:%S:%3N%z") INFO  Wrapper: $1"
  return
}

# turn on bash's job control
# https://stackoverflow.com/questions/11821378/what-does-bashno-job-control-in-this-shell-mean/46829294#46829294
set -m

# Start the primary process and put it in the background
/startup/docker-entrypoint.sh neo4j &

# wait for Neo4j
log_info "Waiting until neo4j stats at :7474 ..."
wget --quiet --tries=10 --waitretry=2 -O /dev/null http://localhost:7474

if [ -d "/kb" ]; then
  log_info  "Deleting all relations"
  cypher-shell -u $NEO4J_LOGIN -p $NEO4J_PASS --format plain "MATCH (n) DETACH DELETE n"

  log_info  "Wrapper: Loading cyphers from '/cyphers'"
  for cipherFile in /kb/*.cql; do
      log_info "Running cypher ${cipherFile}"
      contents=$(cat ${cipherFile})
      cypher-shell -a bolt://localhost:7687 -u $NEO4J_LOGIN -p $NEO4J_PASS  "${contents}"
  done
  log_info  "Finished loading all cyphers from '/cyphers'"
fi

TOTAL_CHANGES=$(cypher-shell -u $NEO4J_LOGIN -p $NEO4J_PASS --format  plain "MATCH (n) RETURN count(n) AS count")
# https://stackoverflow.com/questions/15520339/how-to-remove-carriage-return-and-newline-from-a-variable-in-shell-script/15520508#15520508
log_info "Wrapper: Changes $(echo ${TOTAL_CHANGES} | sed -e 's/[\r\n]//g')"

# now we bring the primary process back into the foreground
# and leave it there
fg %1
