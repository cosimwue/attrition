def square_law(r, b, t, a, c):
    for i in range(t):
        print("{} vs. {}".format(round(r), round(b)))
        r = r - c * b
        b = b - a * r
        if r <= 0 or b <= 0:
            break
    return r, b
