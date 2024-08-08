# ALCF Inference Endpoints
This repository provides examples of using the OpenAI API-based `ALCF Inference Endpoints` for running Large Language Models (LLMs) inference built using [Globus Compute](https://www.globus.org/compute).

Currently, our endpoints are running on two clusters, with more to come:

* Sophia  - https://data-portal-dev.cels.anl.gov/resource_server/sophia
* Polaris - https://data-portal-dev.cels.anl.gov/resource_server/polaris

**Note:** Endpoints are restricted by Globus groups and policy. Contact [Benoit Cote](mailto:bcote@anl.gov?subject=Add%20to%20Inference%20Globus%20group) or [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20to%20Inference%20Globus%20group) with your Globus ID to be added to the Globus group.
You need to be on Argonne's network to access these endpoints. You can run from systems within the Argonne networks, or you will need a VPN, Dash, ssh tunnels if working remotely.

- [Supported Frameworks](#supported-frameworks)
- [API Endpoints](#api-endpoints)
- [Available Models](#available-models)
- [Accessing Endpoints](#accessing-alcf-inference-endpoints)
- [Inference Execution](#inference-execution)
- [Prerequisites](#prerequisites)
  * [Python SDK](#python-sdk)
  * [Access Tokens](#access-tokens)
  * [Access Restrictions](#access-restrictions)
- [Usage](#usage)
  * [Using Curl](#using-curl)
  * [Using Python](#using-python)
  * [Using OpenAI Package](#using-openai-package)
- [Troubleshooting/FAQs](#troubleshooting)

## Supported Frameworks

* vLLM - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm
* llama.cpp (under testing)- https://data-portal-dev.cels.anl.gov/resource_server/sophia/llama-cpp

## API Endpoints

The OpenAI API chat completions and completions are available, with `batch` processing for non-interactive use cases coming soon.

* chat completions - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions
* completions - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions

## Accessing ALCF Inference Endpoints
* To access the Inference endpoints, you need to be added to appropriate Globus groups.   Contact [Benoit Cote](mailto:bcote@anl.gov?subject=Add%20to%20Inference%20Globus%20group) or [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20to%20Inference%20Globus%20group) with your Globus email/ID to be added to the Globus group.


## Available Models

* mistral-7B-instruct-v0.3
* meta-llama-3-8b-instruct
* meta-llama-3-70b-instruct
* mixtral-8x22b-instruct-v0.1

**Note:** To add new models/endpoints, please add the HF-compatible model to the path `/eagle/argonne_tpc/model_weights/` and contact [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20new%20endpoint) or raise an issue in this repository or `via slack`, and we will add it promptly. 

## Inference Execution
The models are currently run as part of a 12-hour job on `Sophia`. The endpoints are dynamically acquired and activated when the first query is performed by any group member, and subsequent queries by group members will re-use the running job/endpoint.

The persistence capability for the inference service is available. However, we are internally collecting various usage metrics and will add a persistent endpoint service shortly. 

On `Polaris`, the models are currently run as part of a debug job with a 1-hour duration.

## Prerequisites

### Python SDK
* A Python environment with `globus_sdk` installed:
```bash
conda create -n globus_env python==3.10.12 --y
conda activate globus_env
pip install globus_sdk
```

### Access Tokens
*   Create an access token. This script creates the [access_token.txt](./access_token.txt) file.
```bash
python3 generate_auth_token.py
access_token=$(cat access_token.txt)
```
**Note:** Once an `access_token` is created, it will be active for 24 hours.

### Access Restrictions
* Access to the endpoinsts is restricted to systems on the Argonne's network. Use VPN, Dash or ssh tunnel from the ALCF computes if working remotely.

## Usage

You can use curl or Python to interact with the Inference API.

### Using Curl

After running [generate_auth_token.py](./generate_auth_token.py), to check all available endpoints

```bash
python3 generate_auth_token.py
access_token=$(cat access_token.txt)
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/list-endpoints" \
     -H "Authorization: Bearer ${access_token}"
```


#### chat/completions endpoint:

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

#### completions endpoint:

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

First, ensure you have generated the authentication token by running [generate_auth_token.py](./generate_auth_token.py). 

#### chat/completions endpoint:

```python
import requests
import json

# Define the access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

# Define the base URL
base_url = "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"

# Define the model and parameters
model = "mistralai/Mistral-7B-Instruct-v0.3"
temperature = 0.2
max_tokens = 150

# Define an array of messages
messages = [
    "List all proteins that interact with RAD51",
    "What are the symptoms of diabetes?",
    "How does photosynthesis work?"
]

# Function to send POST requests
def send_request(message):
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    data = {
        "model": model,
        "temperature": temperature,
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": message}]
    }
    response = requests.post(base_url, headers=headers, data=json.dumps(data))
    return response.json()

# Loop through the messages and send a POST request for each
for message in messages:
    response = send_request(message)
    print(response)

```

#### completions endpoint:

```python
import requests
import json

# Define the access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

# Define the base URL
base_url = "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"

# Define the model and parameters
model = "meta-llama/Meta-Llama-3-8B-Instruct"
temperature = 0.2
max_tokens = 150

# Define an array of prompts
prompts = [
    "List all proteins that interact with RAD51",
    "What are the symptoms of diabetes?",
    "How does photosynthesis work?"
]

# Function to send POST requests
def send_request(prompt):
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    data = {
        "model": model,
        "temperature": temperature,
        "max_tokens": max_tokens,
        "prompt": prompt
    }
    response = requests.post(base_url, headers=headers, data=json.dumps(data))
    return response.json()

# Loop through the prompts and send a POST request for each
for prompt in prompts:
    response = send_request(prompt)
    print(response)
```

To run these Python scripts, save each script to a file (e.g., `chat_completions.py` and `completions.py`), then execute them using Python:

```bash
python3 chat_completions.py
python3 completions.py
```

### Using OpenAI Package

First, ensure you have generated the authentication token by running [generate_auth_token.py](./generate_auth_token.py). 

Install the OpenAI package if you haven't already:

```bash
pip install openai
```


#### chat/completions endpoint:

```python
import openai
import os

# Define the access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

# Define the base URL
base_url = "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"

# Define the model and parameters
model = "mistralai/Mistral-7B-Instruct-v0.3"
temperature = 0.2
max_tokens = 150

# Define an array of messages
messages = [
    "List all proteins that interact with RAD51",
    "What are the symptoms of diabetes?",
    "How does photosynthesis work?"
]

# Set the API key for OpenAI
client = OpenAI(
    api_key=access_token,
    base_url=base_url,
)

# Function to send POST requests
def send_request(message):
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": message}],
        temperature=temperature,
        max_tokens=max_tokens
    )
    return response

# Loop through the messages and send a POST request for each
for message in messages:
    response = send_request(message)
    print(response)
```

#### completions endpoint:

```python
import openai
import os

# Define the access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

# Define the base URL
base_url = "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"

# Define the model and parameters
model = "meta-llama/Meta-Llama-3-8B-Instruct"
temperature = 0.2
max_tokens = 150

# Define an array of prompts
prompts = [
    "List all proteins that interact with RAD51",
    "What are the symptoms of diabetes?",
    "How does photosynthesis work?"
]

# Set the API key for OpenAI
client = OpenAI(
    api_key=access_token,
    base_url=base_url,
)

# Function to send POST requests
def send_request(prompt):
    response = client.completions.create(
        model=model,
        prompt=prompt,
        temperature=temperature,
        max_tokens=max_tokens
    )
    return response

# Loop through the prompts and send a POST request for each
for prompt in prompts:
    response = send_request(prompt)
    print(response)
```

To run these Python scripts, save each script to a file (e.g., `chat_completions_openai.py` and `completions_openai.py`), then execute them using Python:

```bash
python3 chat_completions_openai.py
python3 completions_openai.py
```

Refer to [remote_inference_gateway.ipynb](./remote_inference_gateway.ipynb) for more detailed examples.

## Troubleshooting
1. If you see this error. 
```bash
requests.exceptions.ConnectTimeout: HTTPSConnectionPool(host='data-portal-dev.cels.anl.gov', port=443): Max retries exceeded with url: /resource_server/sophia/vllm/v1/chat/completions (Caused by ConnectTimeoutError(<urllib3.connection.HTTPSConnection object at 0x1496ce979550>, 'Connection to data-portal-dev.cels.anl.gov timed out. (connect timeout=None)'))
```
- Check if the access token is expired and regenerate it. If you're using environment variables for the access token, ensure it is correctly set
- Check if you are accessing the API from within the Argonne network.

