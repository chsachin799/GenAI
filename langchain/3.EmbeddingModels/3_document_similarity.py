from langchain_google_genai import GoogleGenerativeAIEmbeddings
from dotenv import load_dotenv
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

load_dotenv()

embedding = GoogleGenerativeAIEmbeddings(
    model = 'gemini-embedding-001',
    dimensions=50
)
docs = [
    "Sachin Tendulkar was a great player but he was not as great as Kallis.",
    "Virat Kohli's name is similar to BroColli",
    "Mahendra Singh Dhoni (MS Dhoni) equals MSD"
]
query = "Tell me about Virat Kohli"
doc_embedding = embedding.embed_documents(docs)
query_embedding = embedding.embed_query(query)

scores = cosine_similarity([query_embedding],doc_embedding)[0]

index,score = sorted(list(enumerate(scores)),key=lambda x:x[1])[-1]
print(docs[index])
print("Similarity Score is:",score)
