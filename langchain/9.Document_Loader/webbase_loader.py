from langchain_community.document_loaders import WebBaseLoader
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv

load_dotenv()

model = ChatGoogleGenerativeAI(model='gemini-flash-latest')
parser = StrOutputParser()

prompt = PromptTemplate(
    template="Answer the following question  \n {question} from the following text - \n {text}",
    input_variables=['question','text']
)
url ='https://www.flipkart.com/apple-macbook-air-m2-8-gb-256-gb-ssd-mac-os-monterey-mly33hn-a/p/itmdc5308fa78421?pid=COMGFB2GMCRXZG85&lid=LSTCOMGFB2GMCRXZG855GPGWQ&marketplace=FLIPKART&store=6bo%2Fb5g&srno=b_1_4&otracker=browse&fm=organic&iid=68fda3cf-298e-4274-a5f6-b0439e24e30a.COMGFB2GMCRXZG85.SEARCH&ppt=None&ppn=None&ssid=3bd617vlbk0000001784442507927&ov_redirect=true'
loader = WebBaseLoader(url)

docs = loader.load()

chain = prompt | model | parser

print(chain.invoke({'question':'What is the name of this product?','text':docs[0].page_content}))