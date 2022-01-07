import argparse
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--LEN", type=int, required=True)
    parser.add_argument("--DATA_WIDTH", type=int, default=8)
    
    LEN = parser.parse_args().LEN
    DATA_WIDTH = parser.parse_args().DATA_WIDTH
    MAX_VAL = 2**DATA_WIDTH
    
    with open("hex.txt",'w') as f:
        for i in range(LEN):
            v = format(i % MAX_VAL, 'x')+'\n'
            f.write(v)

