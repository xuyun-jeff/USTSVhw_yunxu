# Program to display the Fibonacci sequence up to a limit

limit = int(input("upper limit= "))

# first two terms
n1, n2 = 0, 1
nth = 1

# check if the number of terms is valid
if limit < 0:
   print("Please enter a positive integer")
if limit == 0:
   print("Fibonacci sequence upto",limit,":")
   print(n1)
else:
   print("Fibonacci sequence:")
   print(n1)
   while nth <= limit:
       nth = n1 + n2
       # update values
       n1 = n2
       n2 = nth
       print(n1)
    