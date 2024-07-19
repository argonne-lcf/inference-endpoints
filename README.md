# ALCF Inference Endpoints
This repository provides examples of using the OpenAI API-based `ALCF Inference Endpoints` for running Large Language Models (LLMs) inference.

Currently, our endpoints are running on two clusters, with more to come:

* Sophia  - https://data-portal-dev.cels.anl.gov/resource_server/sophia
* Polaris - https://data-portal-dev.cels.anl.gov/resource_server/polaris

**Note:** Endpoints are restricted by Globus groups and policy. Contact [Benoit Cote](bcote@anl.gov) or [Aditya Tanikanti](atanikanti@anl.gov) with your Globus ID to be added to the Globus group.
You need to be on Argonne's network to access these endpoints. You can run this from systems within the Argonne networks, or you will need a VPN, Dash, ssh tunnels if working remotely.

- [Supported Frameworks](#supported-frameworks)
- [API Endpoints](#api-endpoints)
- [Available Models](#available-models)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  * [Using Curl](#using-curl)
  * [Using Python](#using-python)

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

* A Python environment with `globus_sdk` installed:
```bash
conda create -n globus_env python==3.10.12 --y
conda activate globus_env
pip install globus_sdk
```

* Access to Argonne's network. Use VPN or Dash if working remotely.
* Endpoints are restricted by Globus groups and policy. Contact [Benoit Cote](bcote@anl.gov) or [Aditya Tanikanti](atanikanti@anl.gov) with your Globus ID to be added to the Globus group.

## Usage

You can use curl or Python to interact with the Inference API.

### Using Curl

First, run [generate_auth_token.py](./generate_auth_token.py) to obtain the access token. This script creates the [access_token.txt](./access_token.txt) file. For example, to check all available endpoints, run:

```bash
python3 generate_auth_token.py
access_token=$(cat access_token.txt)
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/list-endpoints" \
     -H "Authorization: Bearer ${access_token}"
```

**Note:** Once an `access_token` is created it will be active for 24 hours.

#### Batch of Inputs

##### chat/completions endpoint:

```bash
#!/bin/bash

# Define the access token
access_token=$(cat access_token.txt)

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"

# Define the model and parameters
model="mistralai/Mistral-7B-Instruct-v0.3"
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
access_token=$(cat access_token.txt)

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"

# Define the model and parameters
model="meta-llama/Meta-Llama-3-8B-Instruct"
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
  echo "'"$prompt"'"
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

* The endpoints on Sophia are set up to run on the `single-node` queue. The first request will take 5-10 minutes to launch a job that will run for 12 hours.
* For a new model to be served, contact us to create an endpoint.
