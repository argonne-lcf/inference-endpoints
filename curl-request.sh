#!/bin/bash
# If access token in file read else paste here
access_token=$(cat access_token.txt)
curl -X POST "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions" \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "mistralai/Mistral-7B-Instruct-v0.3",
           "temperature": 0.2,
           "max_tokens": 150,
           "messages": [
             {
               "role": "user",
               "content": "List all proteins that interact with RAD51"
             }
           ]
         }'

curl -X POST "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions" \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "meta-llama/Meta-Llama-3-8B-Instruct",
           "temperature": 0.2,
           "max_tokens": 150,
           "messages": [
             {
               "role": "user",
               "content": "List all proteins that interact with RAD51"
             }
           ]
         }'

curl -X POST "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions" \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "meta-llama/Meta-Llama-3-70B-Instruct",
           "temperature": 0.2,
           "max_tokens": 150,
           "messages": [
             {
               "role": "user",
               "content": "List all proteins that interact with RAD51"
             }
           ]
         }'