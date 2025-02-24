#!/bin/bash
access_token=$(cat access_token.txt)
#PROD_URL="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"
LOCAL_URL="http://127.0.0.1:8000/resource_server/sophia/vllm/v1/chat/completions"
curl -X POST $LOCAL_URL \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "mgoin/Nemotron-4-340B-Instruct-hf",
           "temperature": 0.2,
           "max_tokens": 150,
           "messages": [
             {
               "role": "user",
               "content": "List all proteins that interact with RAD51"
             }
           ]
         }'

