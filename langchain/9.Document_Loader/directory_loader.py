from langchain_community.document_loaders import DirectoryLoader,PyPDFLoader

loader = DirectoryLoader(
    path='books',
    glob='*.pdf',   # iss pattern ko satisfy  karne wale files ko pick karlo
    loader_cls=PyPDFLoader
)

docs = loader.load()
print(len(docs))
print(docs[0].page_content)
print(docs[0].metadata)
