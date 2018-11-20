import fileinput

myinpaths = [x.rstrip('\n') for x in fileinput.input()]
myinfiles = [x.split('/')[-1] for x in myinpaths]
mycons = [open(x,"r") for x in myinpaths]
print "gene\t" + "\t".join(myinfiles)

index = 0
while True:
    mylines = [x.readline().rstrip('\n') for x in mycons]
    if index <= 3:
        index = index + 1
        continue
    if len(mylines[0]) <= 0:
        break
    mygene = mylines[0].split('\t')[0]
    myouts = [x.split('\t')[-1] for x in mylines]
    print mygene + "\t" + "\t".join(myouts)
    index = index + 1

for i in mycons:
    i.close()


#for fi in range(len(myinpaths)):
#    with open(myinpaths[fi],"r") as f:
#        
#        for i in f:
            
