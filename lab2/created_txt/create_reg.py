def decimalToBinary(n):  
    return bin(n).replace("0b", "") 

f = open('reg_file.txt', 'w')
arr = []
for i in range (0, 32):
    num = decimalToBinary(i)
    print(num)
    arr.append(num)

print("binary arry: ", arr)

for num in arr:
    f.write(num)
    f.write('\n')
f.close()

