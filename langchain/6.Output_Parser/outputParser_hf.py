from langchain_huggingface import ChatHuggingFace,HuggingFaceEndpoint
from langchain_core.prompts import PromptTemplate
from dotenv import load_dotenv

load_dotenv()

llm = HuggingFaceEndpoint(
    repo_id="google/gemma-2-2b-it",
    task="text-generation"
)

model = ChatHuggingFace(llm=llm)

# first prompt -> detailed report
template1 = PromptTemplate(
    template="Write a detailed report on {topic}",
    input_variables=['topic']
)

# second prompt -> summary
template2 = PromptTemplate(
    template="Write a 5 line summary on {text}",
    input_variables=['text']
)

prompt1 = template1.invoke({'topic':'black hole'})
result1 = model.invoke(prompt1)

prompt2 = template2.invoke({'text':result1.text})
result2 = model.invoke(prompt2)

print(result2.text)



