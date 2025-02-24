from openai import OpenAI
import socket
import json
import os
import time
import httpx

# Determine the hostname
start_time  = time.time()
hostname = socket.gethostname()
os.environ['no_proxy'] = f"localhost,{hostname},127.0.0.1"
# Construct the base_url
base_url = f"http://127.0.0.1:8000/resource_server/sophia/vllm/v1"


# Define the access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()

client = OpenAI(
    base_url=base_url,
    api_key=access_token,
   #http_client = httpx.Client(verify=False)

)


data = {
    "temperature": 0.4,
    "max_tokens": 500,
    "model": "meta-llama/Llama-3.2-90B-Vision-Instruct",
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text", 
                    "text": "What is in this image?"
                },
                {
                    "type": "image_url",
                    "image_url": {
                    #"url": "https://apod.nasa.gov/apod/image/2412/MarsClouds_Perseverance_2048.jpg",
                    #"url":"https://www.stockvault.net/data/2010/06/01/113952/preview16.jpg",
                    #"url":"https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
                    "url":"https://g-1f0ec5.fd635.8443.data.globus.org/car.jpg"
			},
                },
            ],
        }
    ],
}

response = client.chat.completions.create(**data)
# Print the response
print(response)
if hasattr(response, "choices") and response.choices:
    print(response.choices[0].message.content)
else:
    print("No valid response received from the API.")

print("Total time",time.time()-start_time)
