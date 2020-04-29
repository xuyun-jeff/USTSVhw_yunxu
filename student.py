class Student:
    def __init__(self,name,studentID,overall_score):
        self.__name=name
        self.__studentID=studentID
        self.__overall_score=overall_score
#Check student info
    def getName(self):
     return self.__name
    def getStudentID(self):
     return self.__studentID
    def getOverall_score(self):
     return self.__overall_score

#Modify student Info
    def setName(self,name):
        self.__name=name
    def setStudentID(self,studentID):
        self.__studentID=studentID
    def setOverallScore(self, overall_score):
        self.__overall_score = overall_score

    def __str__(self):
     return "Student Name:"+self.__name+"\n"+"Student ID:"+str(self.__studentID)+"\n"+"Student Overall Score:"+str(self.__overall_score)

