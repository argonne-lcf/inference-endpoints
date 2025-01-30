# 🤖 ALCF Inference Endpoints

> **Unlock Powerful Large Language Model Inference at Argonne Leadership Computing Facility (ALCF)**

## 🌐 Overview

The ALCF Inference Endpoints provide a robust API for running Large Language Model (LLM) inference using [Globus Compute](https://www.globus.org/compute) on ALCF HPC Clusters. 

### 🖥️ Available Clusters

| Cluster | Endpoint |
|---------|----------|
| Sophia  | https://data-portal-dev.cels.anl.gov/resource_server/sophia |

> **🔒 Access Note:**
> * Endpoints are restricted. You must be on Argonne's network (Use VPN, Dash, or SSH to ANL machine).
> * You will need to authenticate with Argonne or ALCF SSO (Single Sign On) using your credentials. See [Authentication](#authentication).

## 🧩 Supported Frameworks

- **[vLLM](https://docs.vllm.ai/en/latest/)** - https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm
- **[Infinity](https://michaelfeil.eu/infinity/main/)** - https://data-portal-dev.cels.anl.gov/resource_server/sophia/infinity

## 🚀 API Endpoints

### Chat Completions
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/chat/completions
```

### Completions
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/completions
```

### Embeddings
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/infinity/v1/embeddings
```

### 
> **📝 Note** 
> Currently embeddings are only supported by the infinity framework.
> See [usage](#-usage-examples) and/or refer to [OpenAI API](https://platform.openai.com/docs/overview) docs for examples

## 📚 Available Models

### 💬 Chat Language Models

#### Qwen Family
- Qwen/Qwen2.5-14B-Instruct
- Qwen/Qwen2.5-7B-Instruct
- Qwen/QwQ-32B-Preview

#### Meta Llama Family
- meta-llama/Meta-Llama-3-70B-Instruct
- meta-llama/Meta-Llama-3-8B-Instruct
- meta-llama/Meta-Llama-3.1-70B-Instruct
- meta-llama/Meta-Llama-3.1-8B-Instruct
- meta-llama/Meta-Llama-3.1-405B-Instruct
- meta-llama/Llama-3.3-70B-Instruct

#### Mistral Family
- mistralai/Mistral-7B-Instruct-v0.3
- mistralai/Mistral-Large-Instruct-2407
- mistralai/Mixtral-8x22B-Instruct-v0.1

#### Nvidia Nemotron Family
- mgoin/Nemotron-4-340B-Instruct-hf

#### Aurora GPT Family
- auroragpt/auroragpt-0.1-chkpt-7B-Base
- auroragpt/auroragpt-0.1-chkpt-7B-IT
- auroragpt/auroragpt-0.1-chkpt-7B-KTO
- auroragpt/auroragpt-0.1-chkpt-7B-DPO

### Deepseek Family
- deepseek-ai/DeepSeek-R1
- deepseek-ai/DeepSeek-V3

### 👁️ Vision Language Models

#### Qwen Family
- Qwen/Qwen2-VL-72B-Instruct (Ranked 1 in [vision leaderboard](https://huggingface.co/spaces/opencompass/open_vlm_leaderboard))

#### Meta Llama Family
- meta-llama/Llama-3.2-90B-Vision-Instruct

### 🧲 Embedding Models

#### Nvidia Family
- nvidia/NV-Embed-v2 (Ranked 1 in [embedding Leaderboard](https://huggingface.co/spaces/mteb/leaderboard))

### 
> **📝 Want to add a model?** 
> Add the HF-compatible, framework-supported model weights to `/eagle/argonne_tpc/model_weights/` and contact [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20new%20endpoint)

## 🧩 Inference Execution

### Performance and Wait Times

When interacting with the inference endpoints, it's crucial to understand the system's operational characteristics:

1. **Initial Model Loading**
   - The first query for a "cold" model takes approximately **10-15 minutes**
   - Loading time depends on the specific model's size
   - A node must first be acquired and the model loaded into memory

2. **Cluster Resource Constraints**
   - These endpoints run on a High-Performance Computing (HPC) cluster as PBS jobs
   - The cluster is used for multiple tasks beyond inference
   - During high-demand periods, your job might be queued
   - You may need to wait until computational resources become available

3. **Job and model running status**
   - To view currently running jobs along with the models served on the cluster you can run `curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/sophia/jobs" -H "Authorization: Bearer ${access_token}"`. See [Authentication](#authentication) for `access_token`
     
> **🚧 Future Improvements:** 
> * The team is actively working on implementing a node reservation system to mitigate wait times and improve user experience.
> * If you’re interested in extended model runtimes, reservations, or private model deployments, please get in touch with us.

### Cluster-Specific Details

#### Sophia Cluster
The models are currently run as part of a **24-hour job** on Sophia. Here's how the endpoint activation works:

- The first query by an authorized user dynamically acquires and activates the endpoints
- Subsequent queries by authorized users will re-use the running job/endpoint

## 🛠️ Prerequisites

### Python SDK Setup

```bash
# Create a new Conda environment
conda create -n globus_env python==3.11.9 --y
conda activate globus_env

# Install Globus SDK (must be at least version 3.46.0)
pip install globus_sdk

# Install optional package
pip install openai
```

### Authentication

Download the script to manage access tokens:
```bash
wget https://raw.githubusercontent.com/argonne-lcf/inference-endpoints/refs/heads/main/inference_auth_token.py
```
Authenticate with your Globus account:
```bash
python inference_auth_token.py authenticate
```
The above command will generate an access token and a refresh token, and store them in your home directory. If you need to re-authenticate from scratch in order to change Globus account, first logout from your account by visiting [https://app.globus.org/logout](https://app.globus.org/logout), and type the following command:
```bash
python inference_auth_token.py authenticate --force
```
View your access token:
```bash
python inference_auth_token.py get_access_token
```
If your current access token is expired, the above command will atomatically generate a new token without human intervention.

> **⏰ Token Validity:** All access tokens are valid for 48 hours, but the refresh token will allow you to acquire new access tokens programatically without needing to re-authenticate. Refresh tokens do not expire unless they are left unused for 6 months or more.
> 
> **🔒 Access Note:**
> * Endpoints are restricted. You must be on Argonne's network (Use VPN, Dash, or SSH to ANL machine).
> * You will need to authenticate with Argonne or ALCF SSO (Single Sign On) using your credentials.

## 💡 Usage Examples

### 🌟 Curl Request Examples

<details>
    <summary>
        List the status of running jobs/endpoints on the cluster
    </summary>
    
```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/sophia/jobs" \
 -H "Authorization: Bearer ${access_token}"
 ```
</details>

<details>
    <summary>
        List all available endpoints
    </summary>
    
```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)


curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/list-endpoints" \
 -H "Authorization: Bearer ${access_token}"
 ```
</details>

<details>
<summary>Chat Completions Curl Example</summary>

```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

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

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

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
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()

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

output = send_chat_request("What is the purpose of life?")
print(output)
```
</details>

<details>
<summary>Using OpenAI Package</summary>

```python
from openai import OpenAI
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()

client = OpenAI(
    api_key=access_token,
    base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1"
)

response = client.chat.completions.create(
    model="meta-llama/Meta-Llama-3.1-8B-Instruct",
    messages=[{"role": "user", "content": "Explain quantum computing"}]
)

print(response)
```
</details>

<details>
<summary>Using Vision Model</summary>

```python
from openai import OpenAI
import base64
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()
    
# Initialize the client
client = OpenAI(
    api_key=access_token,
    base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1"
)

# Function to encode image to base64
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

# Prepare the image
image_path = "scientific_diagram.png"
base64_image = encode_image(image_path)

# Create vision model request
response = client.chat.completions.create(
    model="Qwen/Qwen2-VL-72B-Instruct",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "Describe the key components in this scientific diagram"},
                {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{base64_image}"}}
            ]
        }
    ],
    max_tokens=300
)

# Print the model's analysis
print(response.server_response)
```
</details>

<details>
<summary>Using Embedding Model</summary>

```python
from openai import OpenAI
import base64
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()
 
# Initialize the client
client = OpenAI(
    api_key=access_token,
    base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/infinity/v1"
)

# Create Embeddings
completion = client.embeddings.create(
  model="nvidia/NV-Embed-v2",
  input="The food was delicious and the waiter...",
  encoding_format="float"
)

# Print the model's analysis
print(completion)
```
</details>

## 🚨 Troubleshooting

- **Connection Timeout?** 
  - Regenerate your access token
  - Verify Argonne network access
  - Your job is queued as the cluster has too many pending jobs 

## 📞 Contact Us

- 📧 [Benoit Cote](mailto:bcote@anl.gov?subject=Inference%20Endpoint)
- 📧 [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Inference%20Endpoint)
- 📧 [ALCF Support](mailto:support@alcf.anl.gov?subject=Inference%20Endpoint)
