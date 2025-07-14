# 🤖 ALCF Inference Endpoints

> **Unlock Powerful Large Language Model Inference at Argonne Leadership Computing Facility (ALCF)**

### Table of Content

<details>
    <summary><a href=#-overview>Overview</a></summary>
        &emsp;&ensp; <a href=#%EF%B8%8F-available-clusters>Available Clusters</a>
</details>

<details>
    <summary><a href=#-supported-frameworks>Supported Frameworks</a></summary>
</details>

<details>
    <summary><a href=#-api-endpoints>API Endpoints</a></summary>
        &emsp;&ensp; <a href=#chat-completions>Chat Completions</a><br>
        &emsp;&ensp; <a href=#completions>Completions</a><br>
        &emsp;&ensp; <a href=#embeddings>Embeddings</a>
</details>

<details>
    <summary><a href=#-available-models>Available Models</a></summary>
        &emsp;&ensp; <a href=#-chat-language-models>Chat Language Models</a><br>
        &emsp;&ensp; <a href=#deepseek-family>Deepseek Family</a><br>
        &emsp;&ensp; <a href=#allenai-family>Allenai Family</a><br>
        &emsp;&ensp; <a href=#%EF%B8%8F-vision-language-models>Vision Language Models</a><br>
        &emsp;&ensp; <a href=#-embedding-models>Embedding Models</a>
</details>

<details>
    <summary><a href=#-inference-execution>Inference Execution</a></summary>
        &emsp;&ensp; <a href=#performance-and-wait-times>Performance and Wait Times</a><br>
        &emsp;&ensp; <a href=#cluster-specific-details>Cluster Specific Details</a>
</details>

<details>
    <summary><a href=#%EF%B8%8F-prerequisites>Prerequisites</a></summary>
        &emsp;&ensp; <a href=#python-sdk-setup>Python SDK Setup</a><br>
        &emsp;&ensp; <a href=#authentication>Authentication</a>
</details>

<details>
    <summary><a href=#-usage-examples>Usage Examples</a></summary>
        &emsp;&ensp; <a href=#-curl-request-examples>Curl Request Examples</a><br>
        &emsp;&ensp; <a href=#-python-implementations>Python Implementations</a>
</details>

<details>
    <summary><a href=#-batch>Batch</a></summary>
        &emsp;&ensp; <a href=#create-batch>Create Batch</a><br>
        &emsp;&ensp; <a href=#retrieve-batch>Retrieve Batch</a><br>
        &emsp;&ensp; <a href=#list-batch>List Batch</a><br>
        &emsp;&ensp; <a href=#batch-status>Batch Status</a><br>
        &emsp;&ensp; <a href=#cancel-batch>Cancel Batch</a>
</details>

<details>
    <summary><a href=#-troubleshooting>Troubleshooting</a></summary>
</details>

<details>
    <summary><a href=#-contact-us>Contact Us</a></summary>
</details>


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
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/embeddings
```

### Batches
```
https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/batches
```

### 
> **📝 Important Notes:** 
> * Currently embeddings are only supported by the infinity framework.
> * See [usage](#-usage-examples) and/or refer to [OpenAI API](https://platform.openai.com/docs/overview) docs for examples.
> * Default response format for the API is `text/plain`.
> * Globus backend does not support streaming, set `stream: False` when integrating with RAG applications.

## 📚 Available Models

### 💬 Chat Language Models

#### Qwen Family
- Qwen/Qwen2.5-14B-Instruct<sup>B</sup><sup>T</sup>
- Qwen/Qwen2.5-7B-Instruct<sup>B</sup><sup>T</sup>
- Qwen/QwQ-32B<sup>B</sup><sup>R</sup><sup>T</sup>
- Qwen/Qwen3-235B-A22B<sup>R</sup><sup>T</sup>
- Qwen/Qwen3-32B<sup>B</sup><sup>R</sup><sup>T</sup>

#### Meta Llama Family
- meta-llama/Meta-Llama-3-70B-Instruct<sup>B</sup>
- meta-llama/Meta-Llama-3-8B-Instruct<sup>B</sup>
- meta-llama/Meta-Llama-3.1-70B-Instruct<sup>B</sup>
- meta-llama/Meta-Llama-3.1-8B-Instruct<sup>B</sup>
- meta-llama/Meta-Llama-3.1-405B-Instruct<sup>T</sup>
- meta-llama/Llama-3.3-70B-Instruct<sup>B</sup><sup>T</sup>
- meta-llama/Llama-4-Scout-17B-16E-Instruct<sup>T</sup>
- meta-llama/Llama-4-Maverick-17B-128E-Instruct<sup>T</sup>

#### Mistral Family
- mistralai/Mistral-7B-Instruct-v0.3<sup>B</sup>
- mistralai/Mistral-Large-Instruct-2407<sup>B</sup>
- mistralai/Mixtral-8x22B-Instruct-v0.1<sup>B</sup>

#### Nvidia Nemotron Family
- mgoin/Nemotron-4-340B-Instruct-hf

#### Aurora GPT Family
- argonne-private/AuroraGPT-IT-v4-0125
- argonne-private/AuroraGPT-Tulu3-SFT-0125
- argonne-private/AuroraGPT-DPO-UFB-0225
- argonne-private/AuroraGPT-7B-OI

### Allenai Family
- allenai/Llama-3.1-Tulu-3-405B

### Google Family
- google/gemma-3-27b-it<sup>B</sup><sup>T</sup>

### 👁️ Vision Language Models

#### Qwen Family
- Qwen/Qwen2-VL-72B-Instruct<sup>B</sup>

#### Meta Llama Family
- meta-llama/Llama-3.2-90B-Vision-Instruct

### 🧲 Embedding Models

#### Mistral Family
- mistralai/Mistral-7B-Instruct-v0.3-embed
- Salesforce/SFR-Embedding-Mistral

#### Nvidia Family
- nvidia/NV-Embed-v2



### 
> **📝 Want to add a model?** 
> * Add the HF-compatible, framework-supported model weights to `/eagle/argonne_tpc/model_weights/` and contact [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Add%20new%20endpoint)
> * **B** - Batch Enabled
> * **T** - Tool Calling Enabled
> * **R** - Reasoning Enabled

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
  
4. **Payload limits**
   - Payloads sent via Globus for inference requests are limited to 10 MB. For requests exceeding this limit, either split your input into smaller chunks or utilize the <a href="#-batch">Batch mode</a> for processing larger inputs efficiently.
     
> **📝 Note:** 
> * If you’re interested in extended model runtimes, reservations, or private model deployments, please get in touch with us.

### Cluster-Specific Details

#### Sophia Cluster
The models currently run as part of a **24-hour job** on Sophia. Here's how the endpoint activation works:

- The first query by a user dynamically acquires and activates the endpoints (approximately **10-15 minutes**).
- Subsequent queries by users will re-use the running job/endpoint.
- Running endpoints that are idle for more than 2 hours will be terminated in order to re-allocate resources to other HPC jobs.

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
The above command will generate an access token and a refresh token, and store them in your home directory. 

If you need to re-authenticate from scratch in order to 1) change Globus account, or 2) resolve a `Permission denied from internal policies` error, first logout from your account by visiting [https://app.globus.org/logout](https://app.globus.org/logout), and type the following command:
```bash
python inference_auth_token.py authenticate --force
```
View your access token:
```bash
python inference_auth_token.py get_access_token
```
If your current access token is expired, the above command will atomatically generate a new token without human intervention.

> **⏰ Token Validity:** All access tokens are valid for 48 hours, but the refresh token will allow you to acquire new access tokens programatically without needing to re-authenticate. Refresh tokens do not expire unless they are left unused for 6 months or more. However, an internal policy will force users to re-authenticate every 7 days.
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

## 🧩 Batch

The ALCF Inference Service provides batch processing capabilities for large-scale inference tasks. This service is exclusively available to ALCF users with an allocation and access to our filesystem space. When a batch job is submitted:

- A dedicated vLLM instance is launched specifically for processing your batch requests
- The model serves only your requests from the input file (up to 150,000 requests per file per batch job)
- The service runs for a maximum of 24 hours or until all requests are processed
- Once completed, the model is automatically brought down to free resources
- Results are written either to:
  - Default directory: `/eagle/argonne_tpc/inference-service-batch-results/`.
  - Custom directory: Specified via optional `output_folder_path` in the request payload (e.g., `/eagle/argonne_tpc/path/to/your/output/folder/`). 

> **📝 Important Note:**
> * Input file and output folder (if provided) **must be located within the `argonne_tcp` project** space or within a world readable/writable folder. Otherwise, the ALCF inference service will not have the permission to process your batch request.

### Concurrent Job Limit:
Currently, the service accommodates only two concurrent batch jobs. Any additional jobs are queued on Globus, and the batch status will accurately reflect the current state of each job.


> **📝 Important Note:**
> * Only models marked with <sup>B</sup> in the [Available Models section](#-available-models) support batch processing. Those are models with less than 70B parameters (models that fit on a single Sophia node)


### Input File Format
Each line in the input file should contain a complete JSON request object in the format of the OpenAI API. For example:

```json
{"custom_id": "request-1", "method": "POST", "url": "/v1/chat/completions", "body": {"model": "meta-llama/Meta-Llama-3.1-8B-Instruct", "messages": [{"role": "system", "content": "You are a helpful assistant."},{"role": "user", "content": "Hello world!"}],"max_tokens": 1000}}
{"custom_id": "request-2", "method": "POST", "url": "/v1/chat/completions", "body": {"model": "meta-llama/Meta-Llama-3.1-8B-Instruct", "messages": [{"role": "system", "content": "You are an unhelpful assistant."},{"role": "user", "content": "Hello world!"}],"max_tokens": 1000}}
```

> **📝 Important Notes:**
> * Input files **must be located within the `argonne_tcp` project** space or within a world readable/writable folder.
> * Each request in the input file should be formatted as a JSON object on a single line (JSON Lines format).
> * Each input file must only target one model, since a batch job will only load one model in memory.

### Batch API Endpoints

#### Create Batch

<details>
<summary>Create Batch Request</summary>

```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

# Define the base URL
base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/batches"

# Submit batch request
curl -X POST "$base_url" \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
          "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
          "input_file": "/eagle/argonne_tpc/path/to/your/input.jsonl"
        }'

# Submit batch request with custom output folder
curl -X POST "$base_url" \
     -H "Authorization: Bearer ${access_token}" \
     -H "Content-Type: application/json" \
     -d '{
          "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
          "input_file": "/eagle/argonne_tpc/path/to/your/input.jsonl",
          "output_folder_path": "/eagle/argonne_tpc/path/to/your/output/folder/"
        }'
```

Using Python:
```python
import requests
import json
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()

# Define headers and URL
headers = {
    'Authorization': f'Bearer {access_token}',
    'Content-Type': 'application/json'
}
url = "https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1/batches"

# Submit batch request
data = {
    "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
    "input_file": "/eagle/argonne_tpc/path/to/your/input.jsonl",
    "output_folder_path": "/eagle/argonne_tpc/path/to/your/output/folder/"
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```
</details>

#### Retrieve Batch

<details>
<summary>Retrieve Batch Metrics</summary>

```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

# Get results of specific batch
batch_id="your-batch-id"
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/v1/batches/${batch_id}/result" \
     -H "Authorization: Bearer ${access_token}"
```

Using Python:
```python
import requests
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()

# Define headers and URL
headers = {
    'Authorization': f'Bearer {access_token}'
}
batch_id = "your-batch-id"
url = f"https://data-portal-dev.cels.anl.gov/resource_server/v1/batches/{batch_id}/result"

# Get batch results
response = requests.get(url, headers=headers)
print(response.json())
```

Sample output:
```bash
{
    "results_file": "/eagle/argonne_tpc/path/to/your/output/folder/<input-file-name>_<model>_<batch-id>/<input-file-name>_<timestamp>.results.jsonl",
    "progress_file": "/eagle/argonne_tpc/path/to/your/output/folder/<input-file-name>_<model>_<batch-id>/<input-file-name>_<timestamp>.progress.json",
    "metrics": {
        "response_time": 27837.440138816833,
        "throughput_tokens_per_second": 3899.833442250346,
        "total_tokens": 108561380,
        "num_responses": 99985,
        "lines_processed": 100000
    }
} 
```
</details>

#### List Batch

<details>
<summary>List All Batches</summary>

```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

# List all batches
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/v1/batches" \
     -H "Authorization: Bearer ${access_token}"

# Optionally filter by status (pending, running, completed, or failed)
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/v1/batches?status=completed" \
     -H "Authorization: Bearer ${access_token}"
```

Using Python:
```python
import requests
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()

# Define headers and URL
headers = {
    'Authorization': f'Bearer {access_token}'
}
url = "https://data-portal-dev.cels.anl.gov/resource_server/v1/batches"

# List all batches
response = requests.get(url, headers=headers)
print(response.json())

# Optionally filter by status (pending, running, completed, or failed)
params = {'status': 'completed'}
response = requests.get(url, headers=headers, params=params)
print(response.json())
```
Sample Output:
```bash
[
  {
    "batch_id": "f8fa8efd-1111-476d-a0a0-111111111111",
    "cluster": "sophia",
    "created_at": "2025-02-20 18:39:58.049584+00:00",
    "framework": "vllm",
    "input_file": "/eagle/argonne_tpc/path/to/your/output/folder/chunk_a.jsonl",
    "status": "pending"
  },
  {
    "batch_id": "4b8a31b8-2222-479f-8c8c-222222222222",
    "cluster": "sophia",
    "created_at": "2025-02-20 18:40:30.882414+00:00",
    "framework": "vllm",
    "input_file": "/eagle/argonne_tpc/path/to/your/output/folder/chunk_b.jsonl",
    "status": "pending"
  }
]
```

</details>

#### Batch Status

<details>
<summary>Get Batch Status</summary>

```bash
#!/bin/bash

# Get your access token
access_token=$(python inference_auth_token.py get_access_token)

# Get status of specific batch
batch_id="your-batch-id"
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/v1/batches/${batch_id}" \
     -H "Authorization: Bearer ${access_token}"
```

Using Python:
```python
import requests
from inference_auth_token import get_access_token

# Get your access token
access_token = get_access_token()

# Define headers and URL
headers = {
    'Authorization': f'Bearer {access_token}'
}
batch_id = "your-batch-id"
url = f"https://data-portal-dev.cels.anl.gov/resource_server/v1/batches/{batch_id}"

# Get batch status
response = requests.get(url, headers=headers)
print(response.json())
```
Batch Status Codes:
- **pending**: The request was submitted, but the job has not started yet.
- **running**: The job is currently running on a compute node.
- **failed**: An error occurred; the error message will be displayed when querying the result.
- **completed**: :tada:
</details>

#### Cancel Batch

<details>
<summary>Cancel Submitted Batch</summary>

The inference team is currently developing a mechanism for users to cancel submitted batches. In the meantime, please contact us with your `batch_id` if you have a batch to cancel.

</details>

## 🚨 Troubleshooting

- **Connection Timeout** 
  - Verify Argonne network access
  - The model you are requesting may be queued as the cluster has too many pending jobs
    - Check model status by querying `https://data-portal-dev.cels.anl.gov/resource_server/sophia/jobs`

- **Connection Error from Polaris**
  - > Could not connect ... Max retries exceeded with url ...
  - Reset your HTTP and HTTPS proxies:
    ```bash
    export HTTP_PROXY="http://proxy.alcf.anl.gov:3128"
    export HTTPS_PROXY="http://proxy.alcf.anl.gov:3128"
    export http_proxy="http://proxy.alcf.anl.gov:3128"
    export https_proxy="http://proxy.alcf.anl.gov:3128"
    ```

- **Permission Denied from Internal Policies**
  - > Error: Permission denied from internal policies. This is likely due to a high-assurance timeout...
  - Logout from your account by visiting [https://app.globus.org/logout](https://app.globus.org/logout)
  - Regenerate your access token with `python inference_auth_token.py authenticate --force`

- **Permission Error During Batch Execution**
  - > Error: Batch failed: Error: TaskExecutionFailed:... PermissionError:...
  - Make sure your input file and output folder (if provided) are located within the `argonne_tcp` project space, or within a world readable/writable folder.

## 📞 Contact Us

- 📧 [Benoit Cote](mailto:bcote@anl.gov?subject=Inference%20Endpoint)
- 📧 [Aditya Tanikanti](mailto:atanikanti@anl.gov?subject=Inference%20Endpoint)
- 📧 [ALCF Support](mailto:support@alcf.anl.gov?subject=Inference%20Endpoint)
