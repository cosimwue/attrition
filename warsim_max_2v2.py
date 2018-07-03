# -*- coding: utf-8 -*-
"""
Created on Mon July 02 09:06:15 2018

@author: RBabl
"""

DESCRIPTION = """Simulates the course of a battle after Osipov's example. 
              Uses amount and power of each unit for both sides (currently maximum of two different units per side) 
              to generate a probability of death for each unit, then rolls using possible coefficients to determine the outcome. 
              Repeats per given time unit, or until one side has 0 units left.
              """

import numpy as np
import random as rd
import argparse

def _prob(size_def, size_one, power_one, size_two = 0 , power_two = 0):
    """Generates the probability for an individual unit to succumb to enemy fire.
    The int size_def describes the number of units taking fire,
    the int size_one (and size_two) describes the number units firing
    the int power_one (and power_two) describes the power of units firing"""    
    deathprob = (size_one*power_one + size_two*power_two)/size_def
    return deathprob


def _battle(size, coeff, prob):
    """Uses a randomized roll for every unit do determine whether it dies or not.
    The int size describes the number of units taking fire,
    the float coeff describes a special bonus/malus (armour, position, training) for a unit,
    the float prob describes the probability of death for a unit"""
    temp = 0
    for j in np.arange(0,size):
        if (prob - coeff*prob) >= rd.uniform(0,1):
            temp = temp + 1    
    newsize = size - temp
    if newsize < 0:
        newsize = 0
    return newsize
    
def warsim(size_r1, power_r1, size_b1, power_b1, time, coeff_r1 = 0, coeff_b1 = 0, size_r2 = 0, power_r2 = 0, coeff_r2 = 0, size_b2 = 0, power_b2 = 0, coeff_b2 = 0):
    """Simulates a Battle of two sides, current maximum of 2 different units a side.
    
    Keyword arguments:
    size_r1   ---   int used to describe the size of the first part of the units on side r.
    power_r1  ---   int used to describe the power of the first part of the units on side r.
    size_b1   ---   int used to describe the size of the first part of the units on side b.
    power_b1  ---   int used to describe the power of the first part of the units on side b.
    time      ---   int used to describe the amount of battle rounds/time units.
    coeff_r1  ---   float used to describe bonus/malus (armour, training, position)
                    of a unit of the first part of side r (maximum = 1, default = 0).
    coeff_b1  ---   float used to describe bonus/malus (armour, training, position)
                    of a unit of the first part of side b (maximum = 1, default = 0).
    size_r2   ---   int used to describe the size of the second part of the units on side r (default = 0). 
    power_r2  ---   int used to describe the power of the second part of the units on side r (default = 0). 
    coeff_r2  ---   float used to describe bonus/malus (armour, training, position)
                    of a unit of the second part of side r (maximum = 1, default = 0).
    size_b2   ---   int used to describe the size of the second part of the units on side b (default = 0). 
    power_b2  ---   int used to describe the power of the second part of the units on side b (default = 0). 
    coeff_b2  ---   float used to describe bonus/malus (armour, training, position)
                    of a unit of the second part of side b (maximum = 1, default = 0)."""
                    
    if coeff_r1 or coeff_b1 or coeff_r2 or coeff_b2 > 1:
        print("Coefficient cannot be > 1, please select a smaller value")
        raise SystemExit
    r = size_r1 + size_r2
    b = size_b1 + size_b2
    
    r_size = [r]
    b_size = [b]

    for i in np.arange(0,time):
    
        prob_r = _prob(r, size_b1, power_b1, size_b2, power_b2)
        prob_b = _prob(b, size_r1, power_r1, size_r2, power_r2)

        size_r1 = _battle(size_r1, coeff_r1, prob_r)
        size_r2 = _battle(size_r2, coeff_r2, prob_r)
        size_b1 = _battle(size_b1, coeff_b1, prob_b)
        size_b2 = _battle(size_b2, coeff_b2, prob_b)   
      
        r = size_r1 + size_r2
        b = size_b1 + size_b2
          
        r_size.append(r)
        b_size.append(b)
    
        if r == 0 or b == 0:
            break
    print("Size of r per time unit: ", r_size,"Size of b per time unit: ",b_size)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=DESCRIPTION)

    parser.add_argument("--size-r1", type=int, help="Describes the size of the first part of the units on side r.")
    parser.add_argument("--power-r1", type=int, help="Describes the power of the first part of the units on side r.")
    parser.add_argument("--size-b1", type=int, help="Describes the size of the first part of the units on side b.")
    parser.add_argument("--power-b1", type=int, help="Describes the power of the first part of the units on side b.")
    parser.add_argument("--time", type=int, help="Describes the amount of battle rounds/time units.")
    parser.add_argument("--coeff-r1", type=float, default=.0, help="Describes bonus/malus (armour, training, position) of a unit of the first part of side r (maximum = 1, default = 0).")
    parser.add_argument("--coeff-b1", type=float, default=.0, help="Describes bonus/malus (armour, training, position) of a unit of the first part of side r (maximum = 1, default = 0).")
    parser.add_argument("--size-r2", type=int, default=0, help="Describes the size of the second part of the units on side r (default = 0).")
    parser.add_argument("--power-r2", type=int, default=0, help="Describes the power of the second part of the units on side r (default = 0).")
    parser.add_argument("--coeff-r2", type=float, default=.0, help="Describes bonus/malus (armour, training, position) of a unit of the second part of side r (maximum = 1, default = 0).")
    parser.add_argument("--size-b2", type=int, default=0, help="Describes the size of the second part of the units on side b (default = 0).")
    parser.add_argument("--power-b2", type=int, default=0, help="Describes the power of the second part of the units on side b (default = 0).")
    parser.add_argument("--coeff-b2", type=float, default=.0, help="Describes bonus/malus (armour, training, position) of a unit of the second part of side b (maximum = 1, default = 0).")

    args = parser.parse_args()

    warsim(args.size_r1, args.power_r1, args.size_b1, args.power_b1, args.time, args.coeff_r1, args.coeff_b1,
           args.size_r2, args.power_r2, args.coeff_r2, args.size_b2, args.power_b2, args.coeff_b2)