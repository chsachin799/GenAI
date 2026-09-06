from langchain_google_genai import GoogleGenerativeAI
from langchain_core.prompts import PromptTemplate
from dotenv import load_dotenv

load_dotenv()

model = GoogleGenerativeAI(model = "gemini-flash-latest")

prompt = PromptTemplate(
    template="A short blog on {topic}",
    input_variables=['topic']
)
chain = prompt | model
result = chain.invoke({'topic':'Cricket'})
print(result)
