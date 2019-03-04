"""

    Simulates the course of a battle after Lanchesters Law, a deterministic model
    for the losses in combat situations under certain conditions

"""

def square_law(r, b, t, a, c):
    """
    Simulates a battle of two sides, current maximum of 2 different units a side.
    
    Args:
        r (int) -- size of unit r at the beginning of the battle
        
        b (int) -- size of unit b at the beginning of the battle
        
        t (int) -- number of timeunits 
        
        a (int) -- describe bonus/malus (armour, training, position) of unit r
        
        c (int) -- describe bonus/malus (armour, training, position) of unit b
        
    Returns:
        r,b (int) -- size of r unit, size of b unit (after the battle)
    
    
    """
    for i in range(t):
        print("{} vs. {}".format(round(r), round(b)))
        r = r - c * b
        b = b - a * r
        if r <= 0 or b <= 0:
            break
    return r, b


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=DESCRIPTION)

    parser.add_argument("--size-r", type=int, help="Describes the size of the first part of the units on side r.", required=True)
    parser.add_argument("--size-b", type=int, help="Describes the size of the first part of the units on side b.", required=True)
    parser.add_argument("--time", type=int, help="Describes the amount of battle rounds/time units.", required=True)
    parser.add_argument("--power-r", type=float, help="Describes the power of the first part of the units on side r.", required=True)
    parser.add_argument("--power-b", type=float, help="Describes the power of the first part of the units on side b.", required=True)
    
    args = parser.parse_args()

    square_law(args.size_r, args.size_b, args.time, args.power_r, args.power_b)