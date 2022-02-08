import os,sys,argparse,shutil


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dst_dir', default='./EVAL/LN')
    parser.add_argument('--name', default='LN7')
    args = parser.parse_args()
    
    src_hwh = './HW/LN_Ultra96/LN_Ultra96.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh'
    src_bit = './HW/LN_Ultra96/LN_Ultra96.runs/impl_1/design_1_wrapper.bit'
    
    dst_hwh = os.path.join(args.dst_dir,args.name+'.hwh')
    dst_bit = os.path.join(args.dst_dir,args.name+'.bit')
    
    shutil.copyfile(src_bit,dst_bit)
    print('Copied:',src_bit)
    print('-> ',dst_bit)
    shutil.copyfile(src_hwh,dst_hwh)
    print('Copied:',src_hwh)
    print('-> ',dst_hwh)