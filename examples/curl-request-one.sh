#!/bin/bash
access_token=$(cat access_token.txt)
BASE_URL="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"
#BASE_URL_LOCAL="http://127.0.0.1:8000/resource_server/sophia/vllm/v1/completions"
curl -X POST $BASE_URL \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "Qwen/QwQ-32B-Preview",
           "temperature": 0.8,
	   "max_tokens": 1000,
	   "prompt": "What is the meaning of life"
         }'
