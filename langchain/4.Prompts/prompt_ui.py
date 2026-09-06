from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import streamlit as st

load_dotenv()

st.header('Research Tool')
user_input = st.text_input('Enter your prompt')

model = ChatGoogleGenerativeAI(model="gemini-flash-latest")
if st.button('Summarize'):
    result = model.invoke(user_input)
    st.write(result.text)
    