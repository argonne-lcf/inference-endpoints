# Inference Endpoints
This repository provides examples of running inference against Large Language Models and other ML models using Python and curl.

## Prerequisites

1. The endpoints are restricted by Globus groups and policy. Please contact [Benoit Cote](bcote@anl.gov) or [Aditya Tanikanti](atanikanti@anl.gov) with your Globus ID to be added to the Globus group. 

2. A Python environment with `globus_sdk` installed:
```bash
conda create -n globus_env python==3.10.12 --y
conda activate globus_env
pip install globus_sdk
```

3. Access to Argonne's network. Use VPN or Dash if working remotely.

## Usage

### Using Python

* Obtain an auth token to run the models. The [notebook](./remote_inference_gateway.ipynb) contains all the necessary information to run the service.

### Using Curl

* To use curl, refer to [curl-requests.sh](./curl-request.sh). First, run [generate_auth_token.py](./generate_auth_token.py) to get the access token. Then, use it in {access_token}. For example, to check all available endpoints, run:
```bash
python3 generate_auth_token.py
access_token = "generated_code"
curl -X GET "https://data-portal-dev.cels.anl.gov/resource_server/list-endpoints" \
     -H "Authorization: Bearer ${access_token}"
```

3. We currently serve three models using vLLM on Polaris: mistralai/Mistral-7B-Instruct-v0.3, meta-llama/Meta-Llama-3-70B-Instruct, and mistralai/Mistral-7B-Instruct-v0.3. For more endpoints, please contact us.


## Limitations

* The endpoints on Polaris are set up to run on the debug queue. The first request will take time to acquire the node. Once the node is acquired, you can make requests sequentially for up to an hour.
* The latency for the requests may be slightly higher than making requests directly to the service. We are working on improving this.
* For a new model to be served, please contact us to create an endpoint.
