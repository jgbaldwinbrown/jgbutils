#!/usr/bin/env python3

import scipy.stats as ss
import scipy.misc as sm

ltercov = 180
t011cov = 232
lowcov = 70

nindivs = 100
nhaps = 200

#def get_p0(nhaps, cov):
#    phit0 = 1 - (1 / nhaps)
#    p0 = phit0 ** cov
#    return(p0)
#    pass
#
#def get_p1(nhaps, cov):
#    phit1 = (1 / nhaps)
#    phit0 = 1 - (1/nhaps)
#    pass

def p2plusbinom(nhaps, cov):
    return(1 - (ss.binom.cdf(2, cov, 1/nhaps)))

def p2pluspois(nhaps, cov):
    return((ss.poisson.cdf(1, cov/nhaps)))

print(p2pluspois(nhaps, ltercov))
print(p2pluspois(nhaps, t011cov))
print(p2pluspois(nhaps, lowcov))
