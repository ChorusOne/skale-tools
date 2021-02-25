FROM python:3-alpine

COPY skalemon.py .
COPY requirements.txt .

RUN pip3 install -r requirements.txt && chmod +x skalemon.py
CMD ["./skalemon.py"]
