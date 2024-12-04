# 🤖 ALCF Inference Endpoints

> **Unlock Powerful Large Language Model Inference at Argonne National Laboratory**

## 🌐 Overview

The ALCF Inference Endpoints provide a robust API for running Large Language Model (LLM) inference using [Globus Compute](https://www.globus.org/compute) and different Inference frameworks. 

### 🖥️ Available Clusters

| Cluster | Endpoint |
|---------|----------|
| Sophia  | https://data-portal-dev.cels.anl.gov/resource_server/sophia |
| Polaris | https://data-portal-dev.cels.anl.gov/resource_server/polaris |

> **🔒 Access Note:** Endpoints are restricted. You'll need Argonne or ALCF credentials to authenticate and be on Argonne's network (Use VPN, Dash, or SSH to ANL machine).

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

## 📚 Available Models

### 💬 Conversational Language Models

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

#### Mistral Family
- mistralai/Mistral-7B-Instruct-v0.3
- mistralai/Mistral-Large-Instruct-2407
- mistralai/Mixtral-8x22B-Instruct-v0.1

#### Nvidia Nemotron Family
- mgoin/Nemotron-4-340B-Instruct-hf

### 👁️ Vision Language Models

#### Qwen Family
- Qwen/Qwen2-VL-72B-Instruct (Best vision model https://huggingface.co/spaces/opencompass/open_vlm_leaderboard)

#### Meta Llama Family
(Coming soon)

### 🧲 Embedding Models
*(Coming Soon)*
- Semantic vector representations
- Support for cross-language and multi-modal embeddings
- Capabilities for:
  - Information retrieval
  - Semantic search
  - Clustering and classification tasks
- Placeholder for upcoming embedding model support

### 
> **📝 Want to add a model?** 
> Add the HF-compatible model to `/eagle/argonne_tpc/model_weights/` and contact [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20new%20endpoint)

## 🧩 Inference Execution

### Performance and Wait Times

When interacting with the inference endpoints, it's crucial to understand the system's operational characteristics:

1. **Initial Model Loading**
   - The first query for a "cold" model takes approximately **10-15 minutes**
   - Loading time depends on the specific model's size
   - A node must first be acquired and the model loaded into memory

2. **Cluster Resource Constraints**
   - These endpoints run on a High-Performance Computing (HPC) cluster
   - The cluster is used for multiple tasks beyond inference
   - During high-demand periods, your job might be queued
   - You may need to wait until computational resources become available

> **🚧 Future Improvements:** 
> The team is actively working on implementing a node reservation system to mitigate wait times and improve user experience.

### Cluster-Specific Details

#### Sophia Cluster
The models are currently run as part of a **24-hour job** on Sophia. Here's how the endpoint activation works:

- The first query by an authorized user dynamically acquires and activates the endpoints
- Subsequent queries by authorized users will re-use the running job/endpoint

#### Polaris Cluster
On Polaris, the models are currently run as part of a **debug job** with a **1-hour duration**.

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

### 🌟 Curl Request Examples

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

send_chat_request("What is the purpose of life?")
```
</details>

<details>
<summary>Using OpenAI Package</summary>

```python
from openai import OpenAI

# Load access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

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

<details>
<summary>Using Vision model</summary>

```python

from openai import OpenAI
import base64

# Load access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()
    
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
print(response.choices[0].message.content)
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
