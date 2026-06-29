# Этап 1
FROM python:3.12-slim AS builder

#  Ваш код здесь #
COPY . .

RUN pip install --prefix=/install -r requirements.txt

# Этап 2
FROM python:3.12-slim 

COPY --from=builder /install /usr/local

COPY . .

# Запускаем приложение с помощью uvicorn, делая его доступным по сети
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"] 
