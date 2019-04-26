#!/usr/bin/env python3

import sys
import scipy.stats as ss
import math
import argparse

def walk(power, n, nhits, precision, maxiter):
    curguess = 0.5
    lowbound = 0.0
    upbound = 1.0
    i=0
    while (upbound - lowbound) > precision and i < maxiter:
        hits = ss.binom.ppf((1-power), n, curguess)
        if hits >= nhits:
            upbound = curguess
            curguess = (upbound + lowbound) / 2.0
        else:
            lowbound = curguess
            curguess = (upbound + lowbound) / 2.0
        i+=1
    return(curguess, lowbound, upbound, i)

def logbin(power, n):
    exponent = math.log(1-power) / n
    p = 1-math.exp(exponent)
    #exponent = math.log(power) * n
    #p = math.exp(exponent)
    return(p)

def main():
    parser = argparse.ArgumentParser("Identify the allele frequency of a marker necessary to detect it with specified power and sample size")
    parser.add_argument("-p", "--power", help = "Power to detect variant (default = 0.80).", default=0.80)
    parser.add_argument("-n", "--number_of_observations", help = "Number of observations made (default = 260).", default=260)
    parser.add_argument("-c", "--hits_required", help = "Number of hits required for successful detection of variant (default = 1)", default=1)
    parser.add_argument("-a", "--precision", help = "Precision of estimate required(default = 1e-10)", default=1e-10)
    parser.add_argument("-i", "--max_iterations", help = "Maximum number of iterations allowed to generate estimate (default = 10000)", default=10000)
    args = parser.parse_args()

    power = float(args.power)
    n = int(args.number_of_observations)
    nhits = int(args.hits_required)
    precision = float(args.precision)
    maxiter = int(args.max_iterations)
    
    guess = walk(power, n, nhits, precision, maxiter)
    print("estimate: %.15f\nlower_bound: %.15f\nupper_bound: %.15f\niterations: %d" % guess)
    
    exact = logbin(power, n)
    print("exact: %.15f" % exact)

if __name__ == "__main__":
    main()
