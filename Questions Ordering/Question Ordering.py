f=open('Your text file','r')
ff=open('Another_file.txt','w')
nums=('0','1','2','3','4','5','6','7','8','9')
list_of_Question=[]
Position_of_Question={}

# reading and writing instruction and paring

flag=0
pre=-1
while(f):
	a=f.read(1)
	if not a:
		break
	if a=='Q':
		position=f.tell()
		s=''
		while(f):
			r_num=f.read(1)
			if not r_num:
				flag=1
				break
			if r_num in nums: # checking for number 
				s=s+r_num
			elif r_num ==')':
				print int(s)
				if(pre!=-1):
					Position_of_Question[pre]=[Position_of_Question[pre],position-1]
				list_of_Question.append(int(s))
				Position_of_Question[int(s)]=position
				pre=int(s)
				break
			else:
				if len(list_of_Question)==0:
					ff.write(a)
					ff.write(s)
					ff.write(r_num)
				break

	else:
		if len(list_of_Question)==0:
			ff.write(a)
	if flag==1:
		break

if(pre!=-1):
	Position_of_Question[pre]=[Position_of_Question[pre],f.tell()]

ff.close()

# Now writing into another file according to question sequence

list_of_Question.sort()
ff=open('Another_file.txt','a')

for i in range(len(list_of_Question)):
	j=list_of_Question[i]
	if Position_of_Question[j][0]!=0:
		f.seek(Position_of_Question[j][0]-1,0)
	else:
		f.seek(Position_of_Question[j][0],0)
	while(f.tell()!=Position_of_Question[j][1]):
		a=f.readline()
		ff.write(a)

f.close()
ff.close()