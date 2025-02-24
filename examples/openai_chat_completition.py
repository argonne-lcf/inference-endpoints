from openai import OpenAI
import socket
import json
import os
import time
# Determine the hostname
start_time  = time.time()
hostname = socket.gethostname()
os.environ['no_proxy'] = f"localhost,{hostname},127.0.0.1"
# Construct the base_url
#base_url = f"http://127.0.0.1:8000/v1"
#base_url=f"https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1"


# Load access token
#with open('access_token.txt', 'r') as file:
#    access_token = file.read().strip()
access_token='Agxlo90Kr9o6pYBKQN4qdJ0GEwMQO1J19mVodqD5X86648NGYNC8CPkow2Mjjx21oBzwzVk6y4W7zacY44oVDh0X8EN'    
# Initialize the client
client = OpenAI(
    api_key=access_token,
    #base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1"
    base_url="http://127.0.0.1:8000/resource_server/sophia/vllm/v1"
)



completion = client.completions.create(
    #model="meta-llama/Meta-Llama-3-70B-Instruct",
    #model = "meta-llama/Meta-Llama-3.3-70B-Instruct",
    #model = "meta-llama/Llama-3.3-70B-Instruct",
    #model = "auroragpt/auroragpt-0.1-chkpt-7B-Base",
    #model = "mistralai/Mixtral-8x22B-Instruct-v0.1",
    #model = "mgoin/Nemotron-4-340B-Instruct-hf",
    #model = "meta-llama/Meta-Llama-3.1-405B-Instruct",
    #model = "/eagle/argonne_tpc/model_weights/Mistral-Large-Instruct-2407",
    #model = "Qwen/Qwen2.5-72B-Instruct",
    #model="meta-llama/Meta-Llama-3.1-8B-Instruct",
    #model="auroragpt/auroragpt-0.1-chkpt-7B-Base",
    #model="auroragpt/auroragpt-0.1-chkpt-7B-IT",
    #model="auroragpt/auroragpt-0.1-chkpt-7B-IT",
    #model="auroragpt/auroragpt-0.1-chkpt-7B-DPO",
    #model="auroragpt/auroragpt-0.1-chkpt-7B-KTO",
    model="deepseek-ai/DeepSeek-V3",
    #messages=[
    #    {
    #        "role": "user",
    #        "content": "How do I output all files in a directory using Java?",
    #    },
    #],
    prompt = "You are a friendly and helpful AI assistant. Please help me to answer the following question.\n\nQuestion What color is the sky\n\nAnswer:",
    temperature=0.2
)
print(completion)
print("Total time",time.time()-start_time)
