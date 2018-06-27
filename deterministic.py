def square_law(r, b, t, a, c):
    for i in range(t):
        r = r - c * b
        b = b - a * r
    return r, b
