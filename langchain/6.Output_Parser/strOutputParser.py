from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
from langchain_core.prompts import PromptTemplate
load_dotenv()


model = ChatGoogleGenerativeAI(model='gemini-flash-latest')

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



