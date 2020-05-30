#!/usr/bin/env python3

rho = 0.00599
genlen =  120535642
ne = 2.97e5

r = rho / (4 * ne)
print("r: ", r)
maplen = r * genlen
print("maplen: ", maplen)
