from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv

# Load the GOOGLE_API_KEY from your .env file
load_dotenv()

# Initialize the latest available Gemini model
llm = ChatGoogleGenerativeAI(model="gemini-3.5-flash")

# Invoke the model
result = llm.invoke("What is the capital of India")

# Print just the plain text answer
print(result.text)