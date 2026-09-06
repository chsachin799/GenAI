from langchain_text_splitters import CharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader

loader = PyPDFLoader('D:\GenAI\9.Document_Loader\books\Introduction-to-Machine-Learning-with-Python.pdf')
docs = loader.load()

text = """
In the realm of Generative AI and Large Language Models (LLMs), managing how text is fed into a system is often the defining factor between a highly accurate application and one that hallucinating or dropping critical context. At the core of this management strategy lies the concept of text splitting. When building applications like Retrieval-Augmented Generation (RAG) systems, developers quickly realize that raw data—whether it is a thousand-page financial report, a dense legal contract, or a collection of medical records—cannot simply be dumped into an LLM all at once. Every model operates under a strict constraint known as a context window, which dictates the maximum number of tokens it can process in a single interaction. Even as these context windows expand into millions of tokens, processing massive blocks of text remains inefficient, costly, and prone to the "lost in the middle" phenomenon, where models struggle to retrieve information buried deep within a massive prompt. Consequently, breaking down large documents into smaller, meaningful, and digestible pieces—commonly referred to as chunks—becomes an absolute architectural necessity.

However, text splitting is far more nuanced than merely slicing a string of characters at arbitrary intervals. A naive approach, such as cutting text exactly every two hundred characters, inevitably tears words in half, destroys sentence structures, and separates vital context. For instance, splitting a sentence right before its concluding thought completely strips the resulting chunks of their semantic value. To counter this, advanced frameworks like LangChain introduce sophisticated text splitters designed to respect the natural geometry of human language. The most fundamental of these is the CharacterTextSplitter, which divides text based on specific characters—often newlines—while measuring chunk size by character count. While useful, it is frequently eclipsed by the RecursiveCharacterTextSplitter. This algorithm attempts to split text by a hierarchy of characters, moving from double newlines to single newlines, spaces, and eventually individual characters, ensuring that paragraphs and sentences are kept intact as much as possible before hitting a hard size limit.

Beyond simple character counts, modern AI workflows increasingly rely on token-based and semantic splitters. Because LLMs read tokens rather than characters, token splitters ensure that chunks perfectly align with the model's actual memory constraints. Meanwhile, semantic splitters analyze the embedding vectors of sentences, placing boundaries only when the underlying meaning or topic of the text shifts significantly. Regardless of the specific method chosen, the ultimate goal remains the same: balancing chunk size with context retention. Developers must also implement a "chunk overlap," allowing adjacent chunks to share a small percentage of text. This overlap acts as a bridge, ensuring that concepts spanning across a boundary are not lost to the ether. By mastering these text-splitting strategies, developers can ensure their AI applications retrieve the exact information needed, maintaining high semantic fidelity and delivering precise, contextually rich responses."""

splitter = CharacterTextSplitter(
    chunk_size = 100,
    chunk_overlap=0,
    separator=''
)
result = splitter.split_text(text)
result2 = splitter.split_documents(docs)
print(result)
print(result2[0].page_content)