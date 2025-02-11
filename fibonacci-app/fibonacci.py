import sys, time

def calculate_fibonacci_number(n):
    """Returns the nth Fibonacci number.
    
    Args:
        n (int): The position in the Fibonacci sequence (0-based index).
        
    Returns:
        int: The nth Fibonacci number.
    """
    if n < 0:
        raise ValueError("Input number must be a non-negative integer.")
    elif n == 0:
        return 0
    elif n == 1:
        return 1

    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b



def return_periodically_first_25_fibonacci():
    """Displays the first 25 Fibonacci numbers with a 0.5-second interval."""
    print("Displaying the first 25 Fibonacci numbers:")
    for i in range(25):
        print(f"Fibonacci({i}) = {calculate_fibonacci_number(i)}")
        time.sleep(0.5)



if __name__ == "__main__":
    if len(sys.argv) == 1:
        # No parameters passed, display the first 10 Fibonacci numbers
        return_periodically_first_25_fibonacci()
    elif len(sys.argv) == 2:
        try:
            num = int(sys.argv[1])
            result = calculate_fibonacci_number(num)
            print(f"Fibonacci({num}) = {result}")
        except ValueError as e:
            print(f"Error: {e}")
            sys.exit(1)
    else:
        print("Usage: python fibonacci_script.py <non-negative integer>")
        sys.exit(1)