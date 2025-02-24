#!/bin/bash
access_token=$(cat access_token.txt)
#BASE_URL="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"
#BASE_URL_LOCAL="http://127.0.0.1:8000/resource_server/sophia/vllm/v1/completions"
BASE_URL_JOB="http://127.0.0.1:8000/resource_server/sophia/jobs"
BASE_URL_JOB_PROD="https://data-portal-dev.cels.anl.gov/resource_server/sophia/jobs"
curl -X GET $BASE_URL_JOB_PROD -H "Authorization: Bearer ${access_token}"
