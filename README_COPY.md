# 🤖 ALCF Inference Endpoints

> **Unlock Powerful Large Language Model Inference at Argonne National Laboratory**

## 🌐 Overview

The ALCF Inference Endpoints provide a robust API for running Large Language Model (LLM) inference using [Globus Compute](https://www.globus.org/compute) and different Inference frameworks. 

### 🖥️ Available Clusters

| Cluster | Endpoint |
|---------|----------|
| Sophia  | https://data-portal-dev.cels.anl.gov/resource_server/sophia |
| Polaris | https://data-portal-dev.cels.anl.gov/resource_server/polaris |

> **🔒 Access Note:** Endpoints are restricted. You'll need Argonne or ALCF credentials and be on Argonne's network.

## 🧩 Supported Frameworks

- **vLLM** - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm
- **llama.cpp** (under testing) - https://data-portal-dev.cels.anl.gov/resource_server/sophia/llama-cpp

## 🚀 API Endpoints

### Chat Completions
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions
```

### Completions
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions
```

# 🤖 ALCF Inference Endpoints

> **Unlock Powerful Large Language Model Inference at Argonne National Laboratory**

## 🌐 Overview

The ALCF Inference Endpoints provide a robust API for running Large Language Model (LLM) inference using [Globus Compute](https://www.globus.org/compute). 

### 🖥️ Available Clusters

| Cluster | Endpoint |
|---------|----------|
| Sophia  | https://data-portal-dev.cels.anl.gov/resource_server/sophia |
| Polaris | https://data-portal-dev.cels.anl.gov/resource_server/polaris |

> **🔒 Access Note:** Endpoints are restricted. You'll need Argonne or ALCF credentials and be on Argonne's network.

## 🧩 Supported Frameworks

- **vLLM** - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm
- **llama.cpp** (under testing) - https://data-portal-dev.cels.anl.gov/resource_server/sophia/llama-cpp

## 🚀 API Endpoints

### Chat Completions
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions
```

### Completions
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions
```

## 🧩 Inference Execution

### Sophia Cluster
The models are currently run as part of a **24-hour job** on Sophia. Here's how the endpoint activation works:

- The first query by an authorized user dynamically acquires and activates the endpoints
- Subsequent queries by authorized users will re-use the running job/endpoint

> **🔍 Persistence Note:** 
> - Persistence capability for the inference service is available
> - Internal usage metrics are being collected
> - A persistent endpoint service will be added shortly

### Polaris Cluster
On Polaris, the models are currently run as part of a **debug job** with a **1-hour duration**.

## 📚 Available Models

<details>
<summary>Click to expand model list</summary>

- Qwen/QwQ-32B-Preview
- Qwen/Qwen2-VL-72B-Instruct
- Qwen/Qwen2.5-14B-Instruct
- Qwen/Qwen2.5-7B-Instruct
- meta-llama/Meta-Llama-3-70B-Instruct
- meta-llama/Meta-Llama-3-8B-Instruct
- meta-llama/Meta-Llama-3.1-405B-Instruct
- meta-llama/Meta-Llama-3.1-70B-Instruct
- meta-llama/Meta-Llama-3.1-8B-Instruct
- mgoin/Nemotron-4-340B-Instruct-hf
- mistralai/Mistral-7B-Instruct-v0.3
- mistralai/Mistral-Large-Instruct-2407
- mistralai/Mixtral-8x22B-Instruct-v0.1

> **📝 Want to add a model?** 
> Add the HF-compatible model to `/eagle/argonne_tpc/model_weights/` and contact [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20new%20endpoint)
</details>

## 🛠️ Prerequisites

### Python SDK Setup

```bash
# Create a new Conda environment
conda create -n globus_env python==3.11.9 --y
conda activate globus_env

# Install required package
pip install globus_sdk
```

### Authentication

1. Generate an access token:
```bash
python3 generate_auth_token.py
access_token=$(cat access_token.txt)
```
> **⏰ Token Validity:** Active for 48 hours

## 💡 Usage Examples

## 🌟 Curl Request Examples

<details>
    <summary>
        List Endpoints
    </summary>
    
```bash
    #!/bin/bash

    # Define the access token
    access_token=$(cat access_token.txt)

    
    curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/list-endpoints" \
     -H "Authorization: Bearer ${access_token}"
 ```
</details>

<details>
<summary>Chat Completions Curl Example</summary>

```bash
#!/bin/bash

# Define the access token
access_token=$(cat access_token.txt)

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"

# Define the model and parameters
model="meta-llama/Meta-Llama-3.1-8B-Instruct"
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

</details>

<details>
<summary>Completions Curl Example</summary>

```bash
#!/bin/bash

# Define the access token
access_token=$(cat access_token.txt)

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions"

# Define the model and parameters
model="meta-llama/Meta-Llama-3.1-8B-Instruct"
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
</details>

### 🐍 Python Implementations

<details>
<summary>Using Requests</summary>

```python
import requests
import json

# Load access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

# Chat Completions Example
def send_chat_request(message):
    url = "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions"
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    data = {
        "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
        "messages": [{"role": "user", "content": message}]
    }
    response = requests.post(url, headers=headers, data=json.dumps(data))
    return response.json()
```
</details>

<details>
<summary>Using OpenAI Package</summary>

```python
from openai import OpenAI

client = OpenAI(
    api_key=access_token,
    base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1"
)

response = client.chat.completions.create(
    model="meta-llama/Meta-Llama-3.1-8B-Instruct",
    messages=[{"role": "user", "content": "Explain quantum computing"}]
)
```
</details>

## 🚨 Troubleshooting

- **Connection Timeout?** 
  - Regenerate your access token
  - Verify Argonne network access

## 📞 Contact Us

- 📧 [Benoit Cote](mailto:bcote@anl.gov?subject=Inference%20Endpoint)
- 📧 [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Inference%20Endpoint)
- 📧 [ALCF Support](mailto:support@alcf.anl.gov?subject=Inference%20Endpoint)
