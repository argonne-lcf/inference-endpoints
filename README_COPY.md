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

## 📚 Available Models

<details>
<summary>Click to expand model list</summary>

- Qwen/Qwen2.5-14B-Instruct
- Qwen/Qwen2.5-7B-Instruct
- meta-llama/Meta-Llama-3-70B-Instruct
- meta-llama/Meta-Llama-3-8B-Instruct
- meta-llama/Meta-Llama-3.1-70B-Instruct
- meta-llama/Meta-Llama-3.1-8B-Instruct
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
