# -*- coding: utf-8 -*-
"""
Created on Wed Jun 20 09:06:15 2018

@author: LENOVO
"""

import numpy as np
import random as rd


r = 1000
b = 800
t = 500

k = 0.01
c = 0.02

probr = 0
probb = 0
rtemp = 0 
btemp = 0

rsize = [r]
bsize = [b]

for i in np.arange(0,t):
    
    probr = c*b/r
    probb = k*r/b

    for j in np.arange(0,r):
        if probr >= rd.uniform(0,1):
            rtemp = rtemp + 1
    for j in np.arange(0,b):
        if probb >= rd.uniform(0,1):
            btemp = btemp + 1

    r = r - rtemp
    b = b - btemp
    
    rtemp = 0 
    btemp = 0
    
    if r < 0:
        r = 0
    if b < 0:
        b = 0
    
    
    rsize.append(r)
    bsize.append(b)
    
    if r == 0 or b == 0:
        break

    