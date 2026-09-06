from langchain_huggingface import HuggingFaceEndpoint, ChatHuggingFace
from dotenv import load_dotenv

# Load your HUGGINGFACEHUB_API_TOKEN from the .env file
load_dotenv()

# 1. Initialize an online hosted model (Qwen is fast, powerful, and free on HF API)
llm = HuggingFaceEndpoint(
    repo_id="Qwen/Qwen2.5-7B-Instruct",
    task="text-generation"
)

# 2. Wrap it so it works as a structured Chat Model
model = ChatHuggingFace(llm=llm)

# 3. Run your prompt
result = model.invoke("Who is Messi?")
print(result.content)