FROM python:3.9-slim
WORKDIR /app

COPY fibonacci.py .
# Create a non-root user
RUN groupadd -r nonroot && useradd -r -g nonroot nonroot
RUN chown -R nonroot:nonroot /app
USER nonroot

ENTRYPOINT ["python", "-u", "fibonacci.py"]
