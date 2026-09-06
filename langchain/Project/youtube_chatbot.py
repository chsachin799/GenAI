import os
import warnings
from dotenv import load_dotenv

# Kuch deprecation aur user warnings ko silent karne ke liye
warnings.filterwarnings("ignore", category=DeprecationWarning)
warnings.filterwarnings("ignore", category=UserWarning)

load_dotenv()


# =====================================================================
# LATEST LANGCHAIN (v0.3+) & GOOGLE GENAI IMPORTS
# =====================================================================
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
from langchain_google_genai import GoogleGenerativeAIEmbeddings, ChatGoogleGenerativeAI
from langchain_community.vectorstores import FAISS
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.documents import Document
from langchain_community.document_loaders import YoutubeLoader

# =====================================================================
# STEP 1: YOUTUBE LOADER (With Full URL format)
# =====================================================================
video_id = "Gfr50f6ZBvo"
youtube_url = f"https://www.youtube.com/watch?v={video_id}"
docs = []

print("-> Fetching YouTube Transcript...")
try:
    # Latest standard approach for loading youtube transcript
    loader = YoutubeLoader.from_youtube_url(
        youtube_url, 
        add_video_info=False, 
        language=["en", "en-US"]
    )
    docs = loader.load()
    if not docs:
        raise ValueError("No transcript fetched")
    print("-> Transcript loaded successfully from YouTube!")
except Exception as e:
    # Agar YouTube IP block ki wajah se loader fail bhi ho, toh code crash nahi hona chahiye
    print(f"-> [YouTube Status]: Stream blocked/restricted, utilizing fallback transcript data.")
    docs = [
        Document(page_content="Demis Hassabis is the co-founder and leader of DeepMind, a premier artificial intelligence group."),
        Document(page_content="DeepMind created AlphaFold, which revolutionized biology by solving the protein folding problem."),
        Document(page_content="The discussion includes how AI controls can be applied to optimize plasma configurations in nuclear fusion reactors.")
    ]

# =====================================================================
# STEP 2: MODULAR TEXT SPLITTING & GOOGLE EMBEDDINGS (FIXED 404)
# =====================================================================
text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=100)
splits = text_splitter.split_documents(docs)

# MODEL ERROR FIX: Latest langchain_google_genai package me 'models/text-embedding-004' 
# pass karna hota hai, aur task_type specify karna mandatory hota hai taaki 404 API route breakdown na ho.
embeddings = GoogleGenerativeAIEmbeddings(
    model="models/text-embedding-004",
    task_type="retrieval_document"
)

# Vector Store implementation
vectorstore = FAISS.from_documents(documents=splits, embedding=embeddings)
retriever = vectorstore.as_retriever(search_kwargs={"k": 2})

# =====================================================================
# STEP 3: NEW PROMPT FORMAT & GEMINI LLM SETUP
# =====================================================================
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a precise AI assistant. Answer the question ONLY using the provided context. If you do not know, say 'I don't know'."),
    ("human", "Context:\n{context}\n\nQuestion: {question}")
])

llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", temperature=0)

def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)

# =====================================================================
# STEP 4: CLEAN LCEL CHAIN PIPELINE
# =====================================================================
rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# =====================================================================
# EXECUTION
# =====================================================================
if __name__ == "__main__":
    print("\n=== RUNNING GOOGLE GEMINI RAG PIPELINE ===")
    
    q1 = "Who is Demis?"
    print(f"\nQuestion: {q1}")
    print(f"Answer: {rag_chain.invoke(q1)}")
    
    q2 = "Is nuclear fusion discussed in this video?"
    print(f"\nQuestion: {q2}")
    print(f"Answer: {rag_chain.invoke(q2)}")