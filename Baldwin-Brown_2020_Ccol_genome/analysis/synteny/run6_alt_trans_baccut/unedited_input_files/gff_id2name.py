#!/usr/bin/env python3

import re
import fileinput

def add_id(field9, namere, parentre):
    name_match = namere.search(field9)
    if not name_match:
        parent_match = parentre.search(field9)
        parent_str = parent_match.group(0)
        my_name = parent_str + "_child"
    else:
        name_str = name_match.group(0)
        my_name = name_str.rstrip(';').split('=')[-1]
    field9 = field9 + ";ID=" + my_name
    return(field9)

def id2name(field9, my_id):
    field9 = field9 + ";Name=" + my_id
    return(field9)

def fix_field9(field9, idre, namere, parentre):
    id_match = idre.search(field9)
    if not id_match:
        field9 = add_id(field9, namere, parentre)
        id_match = idre.search(field9)
    id_str = id_match.group(0)
    my_id = id_str.rstrip(';').split('=')[-1]
    
    name_match = namere.search(field9)
    if not name_match:
        field9 = id2name(field9, my_id)
    return(field9)

def id2name_conn(inconn):
    idre = re.compile(r"ID=[^;]*($|;)")
    namere = re.compile(r"Name=[^;]*($|;)")
    parentre = re.compile(r"Parent=[^;]*($|;)")
    for line in inconn:
        line = line.rstrip('\n')
        if len(line) <= 0:
            print(line)
            continue
        if line[0] == "#":
            print(line)
            continue
        sl = line.split('\t')
        if len(sl) < 9:
            print(line)
            continue
        field9 = sl[8]
        new_field9 = fix_field9(field9, idre, namere, parentre)
        sl[8] = new_field9
        print("\t".join(map(str, sl)))

def main():
    id2name_conn(fileinput.input())

if __name__ == "__main__":
    main()
