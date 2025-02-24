from openai import OpenAI
import base64
import time

start_time  = time.time()
# Load access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()
    

# Initialize the client
client = OpenAI(
    api_key=access_token,
    base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/infinity/v1"
    #base_url="http://127.0.0.1:8000/resource_server/sophia/infinity/v1"
)


completion = client.embeddings.create(
  model="nvidia/NV-Embed-v2",
  input="The food was delicious and the waiter...",
  encoding_format="float"
)


print(completion)
print("Total time",time.time()-start_time)
