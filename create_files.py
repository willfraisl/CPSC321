'''
Will Fraisl
Create sql files
'''

import random
import os


def main():
    f = open("hw11-data-1000000.sql", "w")
    f.write("INSERT INTO employee VALUES")
    for i in range(1000000):
        employee_id = str(i)
        salary = str(random.randint(12000, 150000))
        title = i % 4
        if title == 0:
            title = "administrator"
        elif title == 1:
            title = "engineer"
        elif title == 2:
            title = "manager"
        else:
            title = "salesperson"
        values = "(" + employee_id + ", " + salary + ", \"" + title + "\"),"
        f.write(values)
    f.seek(-1, os.SEEK_CUR)
    f.write(";")


main()
