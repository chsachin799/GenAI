from langchain_huggingface import ChatHuggingFace, HuggingFacePipeline

# Use .from_model_id instead of calling the class directly
llm = HuggingFacePipeline.from_model_id(
    model_id='TinyLlama/TinyLlama-1.1B-Chat-v1.0',
    task='text-generation',
    pipeline_kwargs=dict(
        temperature=0.5,
        max_new_tokens=50,
        do_sample=True # Required by Hugging Face when temperature is used
    )
)

model = ChatHuggingFace(llm=llm)
result = model.invoke("Messi vs Ronaldo")
print(result.content)