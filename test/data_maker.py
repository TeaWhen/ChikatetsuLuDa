import random
import string

def make_insert_data():
    f = open('insert_big.sql', 'w')
    for i in range(1000000):
        f.write("insert into student values ({}, '{}');\n".format(i, randomword(20)))

def randomword(length):
   return ''.join(random.choice(string.lowercase) for i in range(length))

if __name__ == '__main__':
    make_insert_data()