from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import streamlit as st
from langchain_core.prompts import PromptTemplate, load_prompt
load_dotenv()

st.header('Research Tool')

model = ChatGoogleGenerativeAI(model="gemini-flash-latest")
paper_input = st.selectbox("Select Research Paper Name",["Select...","Attention is All You Need","BERT: Pre-training of Deep Bidirectional Transformers","GPT-3: Language Models are Few-Shot Learners","Diffusion Models beat GANs on Image Synthesis"])

style_input = st.selectbox("Select Explanation Style",["Beginner-Friendly","Technical","Code-Oriented","Mathematical"])

length_input = st.selectbox("Select Explanation Length",["Short (1-2 paragraphs)","Medium (3-5 paragraphs)","Long (detailed explanation)"])

template = load_prompt('template.json')
# template 


# fill the placeholders
prompt = template.invoke({
    'paper_input':paper_input,
    'style_input':style_input,
    'length_input':length_input
})

if st.button('Summarize'):
    chain = template | model
    result = chain.invoke({
        'paper_input':paper_input,
        'style_input':style_input,
        'length_input':length_input
    })
    st.write(result.text)
