from langchain_google_genai import GoogleGenerativeAIEmbeddings
from dotenv import load_dotenv

load_dotenv()

# Switch to the active "gemini-embedding-001" model
# Note: gemini-embedding-001 outputs up to 3072 dimensions by default, 
# but allows flexible reduction (like down to 768 or similar via Matryoshka learning)
embedding = GoogleGenerativeAIEmbeddings(
    model="gemini-embedding-001", 
    output_dimensionality=768  # Use output_dimensionality for the newer LangChain package limits
)

result = embedding.embed_query("Delhi is the capital of India")
print("Vector length:", len(result))
print("First 5 values:", result[:5])

# for docs
documents = [
    "I am Sachin",
    "Kathmandu is the capital of Nepal",
    "Paris is the capital of France"
]
res = embedding.embed_documents(documents)
print(str(res))