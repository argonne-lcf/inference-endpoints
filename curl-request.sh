#!/bin/bash
access_token=$(python inference_auth_token.py get_access_token)
curl -X POST "https://inference-api.alcf.anl.gov/resource_server/sophia/vllm/v1/chat/completions" \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
           "temperature": 0.2,
           "max_tokens": 150,
           "messages": [
             {
               "role": "user",
               "content": "List all proteins that interact with RAD51"
             }
           ]
         }'

