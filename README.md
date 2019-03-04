# Attrition Warfare

The attrition warfare project comes up with a bunch of methods for simulating the mathematical 
aspects of attrition warfare. This project has been started in summer semester 18 by the participants 
of the conflict simulation course at the Univerity of Wuerzburg. 


### App

The simulating war application is a interactive shiny application that allows the user to simulate 
and visualize the course of a battle after Lanchester's Model as well as after Osipov's Model.

### Modules

The modules provide methods that allow the simulation of the course of a battle after the models of Osipov and Lanchester. 

##### Module warsim_max_2v2

Simulates the course of a battle after Osipov's example. Uses amount and power
of each unit for both sides (currently maximum of two different units per
side) to generate a probability of death for each unit, then rolls using
possible coefficients to determine the outcome. Repeats per given time unit,
or until one side has 0 units left.

##### Usage

```
$ python warsim_max_2v2.py --help
usage: warsim_max_2v2.py [-h] [--size-r1 SIZE_R1] [--power-r1 POWER_R1]
                         [--size-b1 SIZE_B1] [--power-b1 POWER_B1]
                         [--time TIME] [--coeff-r1 COEFF_R1]
                         [--coeff-b1 COEFF_B1] [--size-r2 SIZE_R2]
                         [--power-r2 POWER_R2] [--coeff-r2 COEFF_R2]
                         [--size-b2 SIZE_B2] [--power-b2 POWER_B2]
                         [--coeff-b2 COEFF_B2]


optional arguments:
  -h, --help           show this help message and exit
  --size-r1 SIZE_R1    Describes the size of the first part of the units on
                       side r.
  --power-r1 POWER_R1  Describes the power of the first part of the units on
                       side r.
  --size-b1 SIZE_B1    Describes the size of the first part of the units on
                       side b.
  --power-b1 POWER_B1  Describes the power of the first part of the units on
                       side b.
  --time TIME          Describes the amount of battle rounds/time units.
  --coeff-r1 COEFF_R1  Describes bonus/malus (armour, training, position) of a
                       unit of the first part of side r (maximum = 1, default
                       = 0).
  --coeff-b1 COEFF_B1  Describes bonus/malus (armour, training, position) of a
                       unit of the first part of side r (maximum = 1, default
                       = 0).
  --size-r2 SIZE_R2    Describes the size of the second part of the units on
                       side r (default = 0).
  --power-r2 POWER_R2  Describes the power of the second part of the units on
                       side r (default = 0).
  --coeff-r2 COEFF_R2  Describes bonus/malus (armour, training, position) of a
                       unit of the second part of side r (maximum = 1, default
                       = 0).
  --size-b2 SIZE_B2    Describes the size of the second part of the units on
                       side b (default = 0).
  --power-b2 POWER_B2  Describes the power of the second part of the units on
                       side b (default = 0).
  --coeff-b2 COEFF_B2  Describes bonus/malus (armour, training, position) of a
                       unit of the second part of side b (maximum = 1, default
                       = 0).
                       
```
##### Module deterministic_model

Simulates the course of a battle after Lanchesters Law, a deterministic model
for the losses in combat situations under certain conditions.

##### Usage

```                                        
$ python deterministic_model.py --help
usage: deterministic_model.py [-h] [--size-r SIZE_R] [--size-b SIZE_B]
                              [--time TIME] [--power-r POWER_R] 
                              [--power-b POWER_B]
                              


optional arguments:
  -h, --help         show this help message and exit
  --size-r SIZE_R    Describes the size of the first part of the units on
                     side r.
  --size-b SIZE_B    Describes the size of the first part of the units on
                     side b.
  --time TIME        Describes the amount of battle rounds/time units.
  --power-r POWER_R  Describes the power of the first part of the units on
                     side r.
  --power-b1 POWER_B Describes the power of the first part of the units on
                     side b.
                       
```
### Tutorials 

The tutorials are jupyter notebooks that demonstrate the usage of the modules. 
