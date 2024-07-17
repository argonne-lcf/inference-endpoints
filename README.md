# Inference Endpoints
This repository provides examples of using the OpenAI API-based `ALCF Inference API` for running Large Language Models (LLMs).

Currently, our endpoints are running on two clusters, with more to come:

* Sophia  - https://data-portal-dev.cels.anl.gov/resource_server/sophia
* Polaris - https://data-portal-dev.cels.anl.gov/resource_server/polaris

**Note:** You need to be on Argonne's network to access these endpoints. Use VPN, Dash, ssh tunnels if working remotely.

## Supported Frameworks

* vLLM - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm
* llama.cpp - https://data-portal-dev.cels.anl.gov/resource_server/sophia/llama-cpp

## API Endpoints

The OpenAI API chat completions and completions are available, with `batch` processing for non-interactive use cases coming soon.

* chat completions - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions
* completions - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions

## Available Models

* mistral-7B-instruct-v03
* meta-llama-3-8b-instruct
* meta-llama-3-70b-instruct

**Note:** For additional endpoints, add the HF-compatible model to the path `/eagle/argonne_tpc/model_weights/` and contact us at [atanikanti@anl.gov] or raise an issue in this repository and we will add it promptly.

## Prerequisites

* Endpoints are restricted by Globus groups and policy. Contact [Benoit Cote](bcote@anl.gov) or [Aditya Tanikanti](atanikanti@anl.gov) with your Globus ID to be added to the Globus group.

* A Python environment with `globus_sdk` installed:
```bash
conda create -n globus_env python==3.10.12 --y
conda activate globus_env
pip install globus_sdk
```

* Access to Argonne's network. Use VPN or Dash if working remotely.

## Usage

You can use curl or Python to interact with the Inference API.

### Using Curl

First, run [generate_auth_token.py](./generate_auth_token.py) to get the access token. Set the `{access_token}`. For example, to check all available endpoints, run:

```bash
python3 generate_auth_token.py
access_token = "generated_code"
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/list-endpoints" \
     -H "Authorization: Bearer ${access_token}"
```

#### Batch of Inputs

##### chat/completions endpoint:

```bash
#!/bin/bash

# Define the access token
access_token="your_access_token_here"

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"

# Define the model and parameters
model="mistral-7B-instruct-v03"
temperature=0.2
max_tokens=150

# Define an array of messages
messages=(
  "List all proteins that interact with RAD51"
  "What are the symptoms of diabetes?"
  "How does photosynthesis work?"
)

# Loop through the messages and send a POST request for each
for message in "${messages[@]}"; do
  curl -X POST "$base_url" \
       -H "Authorization: Bearer ${access_token}" \
       -H "Content-Type: application/json" \
       -d '{
              "model": "'$model'",
              "temperature": '$temperature',
              "max_tokens": '$max_tokens',
              "messages":[{"role": "user", "content": "'"$message"'"}]
           }'
done
```

##### completions endpoint:

```bash
#!/bin/bash

# Define the access token
access_token="your_access_token_here"

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"

# Define the model and parameters
model="meta-llama-3-8b-instruct"
temperature=0.2
max_tokens=150

# Define an array of prompts
prompts=(
  "List all proteins that interact with RAD51"
  "What are the symptoms of diabetes?"
  "How does photosynthesis work?"
)

# Loop through the prompts and send a POST request for each
for prompt in "${prompts[@]}"; do
  curl -X POST "$base_url" \
       -H "Authorization: Bearer ${access_token}" \
       -H "Content-Type: application/json" \
       -d '{
              "model": "'$model'",
              "temperature": '$temperature',
              "max_tokens": '$max_tokens',
              "prompt":"'"$prompt"'"
           }'
done
```

For more examples see [curl-requests.sh](./curl-request.sh)

### Using Python

Refer to [remote_inference_gateway.ipynb](./remote_inference_gateway.ipynb) for detailed examples and steps to access our endpoints using Python.

## Limitations

* The endpoints on Polaris are set up to run on the debug queue. The first request will take time to acquire the node. Once the node is acquired, you can make requests sequentially for up to an hour.
* The latency for the requests may be slightly higher than making requests directly to the service. We are working on improving this.
* For a new model to be served, contact us to create an endpoint.
