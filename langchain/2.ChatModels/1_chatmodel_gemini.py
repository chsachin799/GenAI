from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv

# Load the GOOGLE_API_KEY from your .env file
load_dotenv()

# Initialize the model
llm = ChatGoogleGenerativeAI(model="gemini-3.5-flash",temperature=1.5,max_completion_tokens=10)

# Test invocation
result = llm.invoke("What is the capital of India")
print(result.text)