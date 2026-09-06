from langgraph.graph import StateGraph,START,END
from dotenv import load_dotenv
from typing import TypedDict,Annotated
from langgraph.graph.message import add_messages
from langchain_google_genai import ChatGoogleGenerativeAI
from langgraph.checkpoint.memory import InMemorySaver
from langchain_core.messages import BaseMessage,HumanMessage

load_dotenv()

model = ChatGoogleGenerativeAI(model='gemini-flash-latest')

class chatState(TypedDict):
    messages : Annotated[list[BaseMessage],add_messages]


def chat_node(state:chatState):
    messages = state['messages']
    response = model.invoke(messages)
    return {'messages':[response]}

# make the graph
graph = StateGraph(chatState)

# add node
graph.add_node("chat_node",chat_node)

# add edge
graph.add_edge(START,'chat_node')
graph.add_edge('chat_node',END)

# compile
checkpointer = InMemorySaver()

chatbot = graph.compile(checkpointer=checkpointer)

"""
# tin cheejhein pass karni hoti hai :
# 1. initial state   2.config   3. stream mode
for message_chunk,metadata in chatbot.stream(
    {'messages':[HumanMessage(content='What is the recipe to make Pasta')]},
    config = {'configurable':{'thread_id':'thread-1'}},
    stream_mode='messages'
):
    if message_chunk.text:
       print(message_chunk.text,end=" ",flush=True)

"""