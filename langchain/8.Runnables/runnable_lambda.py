from langchain_google_genai import GoogleGenerativeAI
from dotenv import load_dotenv
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
from langchain_core.runnables import RunnableSequence,RunnableParallel,RunnablePassthrough,RunnableLambda
load_dotenv()

def word_count(text):
    return len(text.split())

model = GoogleGenerativeAI(model="gemini-2.5-flash")
parser = StrOutputParser()

passthrough = RunnablePassthrough()

prompt = PromptTemplate(
    template="Write a joke about {topic}",
    input_variables=['topic']
)


joke_gen_chain = RunnableSequence(prompt, model, parser)

parallel_chain = RunnableParallel({
    'joke':RunnablePassthrough(),
    'word_count':RunnableLambda(word_count)
})

final_chain = RunnableSequence(joke_gen_chain,parallel_chain)

result = final_chain.invoke({'topic':'cricket'})

final_result = """{} \n word count - {}""".format(result['joke'],result['word_count'])
print(final_result)