import math

def FST_W_pairwise (col):
	  NpopA = float(col[0])
	  NpopB = float(col[2])

	  popAcount= int(col[1])
	  popBcount= int(col[3])
	  

	  npops= 2.0
	  nsamples = float(NpopA + NpopB)
	  n_bar= (NpopA / npops) + (NpopB / npops)
	  samplefreq = ( (popAcount+popBcount) / (NpopA + NpopB) )
	  pop1freq = popAcount / float(NpopA )
	  pop2freq = popBcount / float(NpopB )
	  Npop1 = NpopA
	  Npop2 = NpopB
	  S2A= (1/ ( (npops-1.0) * n_bar) ) * ( ( (Npop1)* ((pop1freq-samplefreq)**2) ) + ( (Npop2)*((pop2freq-samplefreq)**2) ) )
	  nc = 1.0/(npops-1.0) * ( (Npop1+Npop2) - (((Npop1**2)+(Npop2**2)) / (Npop1+Npop2)) )
	  T_1 = S2A -( ( 1/(n_bar-1) ) * ( (samplefreq * (1-samplefreq)) -  ((npops-1)/npops)* S2A ) )
	  T_2 = (( (nc-1) / (n_bar-1) ) * samplefreq *(1-samplefreq) )   +  (1.0 +   (((npops-1)*(n_bar-nc))  / (n_bar-1)))       * (S2A/npops)

	  return (T_1,T_2)

def FST_H_pairwise (col):
		NpopA = float(col[0])
		NpopB = float(col[2])

		popAcount= int(col[1])
		popBcount= int(col[3])
		
		pop1freq = popAcount / float(NpopA )
		pop2freq = popBcount / float(NpopB )
		Npop1 = NpopA
		Npop2 = NpopB
		T_1=(pop1freq-pop2freq)**2 - ((pop1freq*(1.0-pop1freq))/(Npop1-1)) - ((pop2freq*(1.0-pop2freq))/(Npop2-1))
		T_2=(pop1freq*(1.0-pop2freq)) + (pop1freq*(1.0-pop2freq))
		#T_1=T_2
		#T_2=1.0
		
		return (T_1,T_2)

def all_pairwise_tests(count,n,func):
    fstarray={}
    #if len(count) != len(n):
    #    exit("must having matching numbers of counts for the 2 alleles!")
    indata = zip(count,n)
    numpops = len(indata)
    for i in enumerate(indata):
        i_i = i[0]
        i_c = i[1][0]
        i_n = i[1][1]
        for j in enumerate(indata[i_i+1:]):
            j_i = j[0] + 1 + i_i
            j_c = j[1][0]
            j_n = j[1][1]
            col = (i_n,i_c,j_n,j_c)
            fstarray[(i_i,j_i)] = func(col)
    return fstarray

def mean(l): 
    return(float(sum(l))/len(l) if len(l) > 0 else float('nan'))

def flatten_sparse(smat):
    temp = []
    keys = sorted(smat)
    for i in keys:
        temp.append(smat[i][0])
    return(temp)

def str2int_NA(value):
    try:
        out=int(round(float(value)))
    except ValueError:
        out="NA"
    return(out)

def str2float_NA(value):
    try:
        out=(float(value))
    except ValueError:
        out="NA"
    return(out)

def nCr(n,r):
    f = math.factorial
    return f(n) / f(r) / f(n-r)
