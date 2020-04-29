from student import Student
from ClassOfStudent import ClassOfStudent
def main():
    s = Student("Jeff",101,45.7)
    s1 = Student("Mike",122,98)
    s2 = Student("James",130,99)
    c = ClassOfStudent("Art",3301)
    c.add_student(s)
    c.add_student(s1)
    c.add_student(s2)
    print(c)

main() 
