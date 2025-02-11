# Fibonacci App  

This project provides a simple Python application to calculate and display Fibonacci numbers. It includes a `Dockerfile` to containerize the application for easy deployment and execution.  

---

## Project Structure  


- **fibonacci.py:** A Python script to compute Fibonacci numbers and display results periodically.  
- **Dockerfile:** Instructions to build a Docker image for the application.  

---

## How to Use  

### Run Locally  

#### **Prerequisites:**  
Ensure you have Python 3 installed.

#### **Running the Script Locally:**  
1. Open a terminal and navigate to the `fibonacci-app` directory.  
2. Execute the script:  

   **Run the default mode (first 20 Fibonacci numbers with a delay):**  
   ```bash
   python fibonacci.py
   ```

   **Calculate the Fibonacci number for a specific position:**  
   ```bash
   python fibonacci.py <non-negative integer>
   ```

---

### Run with Docker  

#### **Build the Docker Image:**  
```bash
docker build -t fibonacci-app .
```

#### **Run the Docker Container:**  
```bash
docker run --rm fibonacci-app
```

To pass a specific number as an argument to the container:  
```bash
docker run --rm fibonacci-app 10
```

---

## Example Output  

**Default Execution:**  
```
Displaying the first 10 Fibonacci numbers:
Fibonacci(0) = 0
Fibonacci(1) = 1
Fibonacci(2) = 1
Fibonacci(3) = 2
...
```

**With a specific input (`10`):**  
```
Fibonacci(10) = 55
```

