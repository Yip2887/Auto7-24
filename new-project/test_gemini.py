import os
from google import genai

# Initialize the client
api_key = os.environ.get("AIzaSyBTo7QyDwuHXkHY9S2GVxWuYvzyjVL-THU")
client = genai.Client(api_key=api_key)

try:
    # Try to use gemini-3.1-pro-preview (the current standard preview name for AI Studio)
    response = client.models.generate_content(
        model="gemini-3.1-pro-preview",
        contents="Hello, please confirm what your current model name is?"
    )
    print("-" * 30)
    print(f"Answer content: {response.text}")
    print("-" * 30)
except Exception as e:
    print(f"Execution error: {e}")
