#!/bin/bash
access_token=$(cat access_token.txt)
BASE_URL="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"
BASE_URL_LOCAL="http://127.0.0.1:8000/resource_server/sophia/vllm/v1/completions"
MODEL_NAME="meta-llama/Meta-Llama-3.1-405B-Instruct"
curl -X POST $BASE_URL_LOCAL \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "meta-llama/Meta-Llama-3.1-405B-Instruct",
	   "max_tokens": 0,
	   "temperature": 0.0,
           "echo": true,
	   "prompt": "What is the meaning of life",
	   "logprobs": 1
         }'
