#!/usr/bin/env bash
set -euo pipefail
# set -x # debug

# For service instances with binding name
SERVICE_STATSD_BINDING_NAME=${SERVICE_STATSD_BINDING_NAME:-datasource}


get_binding_service() {
    local binding_name="${1}"
    jq --arg b "${binding_name}" '.[][] | select(.binding_name == $b)' <<<"${VCAP_SERVICES}"
}


get_vcap_service_statsd() {
    jq '[.[][] | select(.credentials.statsd) ] | first | select (.!=null)' <<<"${VCAP_SERVICES}"
}


set_env_statsd() {
    local datasource="${1}"

    local label=$(jq -r '.label' <<<"${datasource}")
    local host=$(jq -r '.credentials.statsd.host' <<<"${datasource}")
    local port=$(jq -r '.credentials.statsd.port' <<<"${datasource}")
    local proto=$(jq -r '.credentials.statsd.proto | select (.!=null)' <<<"${datasource}")

    echo "*** Defining statsd env vars from service instance ${label} ..."
    export STATSD_HOST="${host}"
    export STATSD_PORT="${port}"
    export STATSD_PROTO="${proto}"
}


statsd() {
    local datasource=$(get_binding_service "${SERVICE_STATSD_BINDING_NAME}")
    [ -z "${datasource}" ] && datasource=$(get_vcap_service_statsd) || true
    [ -n "${datasource}" ] && set_env_statsd "${datasource}" || true
}

# run
statsd
