from openai import OpenAI
import base64

# Load access token
with open('access_token.txt', 'r') as file:
    access_token = file.read().strip()
    
# Initialize the client
client = OpenAI(
    api_key=access_token,
    #base_url="https://data-portal-dev.cels.anl.gov/resource_server/sophia/vllm/v1"
    base_url="http://127.0.0.1:8000/resource_server/sophia/vllm/v1"
)

# Function to encode image to base64
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

# Prepare the image
image_path = "car.jpg"
base64_image = encode_image(image_path)

# Create vision model request
response = client.chat.completions.create(
    #model="Qwen/Qwen2-VL-72B-Instruct",
    model="meta-llama/Llama-3.2-90B-Vision-Instruct",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "Describe the image"},
                {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{base64_image}"}}
            ]
        }
    ],
    max_tokens=300
)

# Print the model's analysis
#print(response.choices[0])
print(response.server_response)
