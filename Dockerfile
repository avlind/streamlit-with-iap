FROM python:3.12-slim
EXPOSE 8080
WORKDIR /streamlit-with-iap

COPY . .
RUN pip install -r requirements.txt

ENTRYPOINT ["streamlit", "run", "streamlit/main.py", "--server.port=8080", "--server.address=0.0.0.0"]