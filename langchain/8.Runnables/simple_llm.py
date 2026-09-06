from langchain_google_genai import GoogleGenerativeAI
from langchain_core.prompts import PromptTemplate
from dotenv import load_dotenv

load_dotenv()

llm = GoogleGenerativeAI(model='gemini-flash-latest')

prompt = PromptTemplate(
    template='Give me a blog on {topic}',
    input_variables=['topic']
)

topic = input("Enter the topic of the blog")

format_topic = prompt.format(topic=topic)

blog_title = llm.invoke(format_topic)

print("The blog title is : ",blog_title)
