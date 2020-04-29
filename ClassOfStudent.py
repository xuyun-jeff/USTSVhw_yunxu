class ClassOfStudent:
    "I will define class_name(string), section_num(integer), and student_list(which is a list of studnet objects)"
    def __init__(self,class_name,section_num):
        self.__class_name=class_name
        self.__section_num=section_num
        self.__student_list=[]
    #Check class info
    def getClass_Name(self):
        return self.__class_name
    def getSection_Num(self):
        return self.__section_num
    def getStudent_List(self):
        return self.__student_list

    def __str__(self):
        students =""
        for eachstudent in self.__student_list:
            students+=str(eachstudent)+"\n"
        return "Name of class: "+self.__class_name+"\nSection num: "+str(self.__section_num)+"\nStudents: "+ students

    def add_student(self,Student):
        self.__student_list.append(Student)

    def getNumber_Of_Student(self):
        Number_Of_Student=0
        for Number_Of_Student in self.__student_list:
            Number_Of_Student+=1
        return Number_Of_Student
    def getStudent_Details(self):
        for each in self.__student_list:
            print(each)
    
