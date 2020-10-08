#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: sts=4 sw=4 et
# Description: Unit test checker
# Author: Tony Pavlov (untoxa)
# SPDX-License-Identifier: MIT

import sys
import json
from PIL import Image, ImageChops

from BGB_toolkit import load_noi, read_bgb_snspshot

def get_rule_desc(config_file):
    desc = config.get('description', '')
    if len(desc) > 0:
        return '{:s} ({:s})'.format(config_file, desc)
    else:
        return config_file

def CHECKSCREEN(file_name):
    image_one = Image.open(file_name).convert('RGB')
    image_two = Image.open(sys.argv[4]).convert('RGB')

    diff = ImageChops.difference(image_one, image_two)

    return (diff.getbbox() is None)


def exec_rule(rule):
    global rule_result
    rule_result = False
    exec('global rule_result; rule_result = {:s}'.format(rule))
    return rule_result

mem_map = { 'WRAM': 0xC000, 'VRAM': 0x8000, 'OAM': 0xFE00, 'HRAM': 0xFF80 }
def ADDR(symbol, base):
    if type(base) is str:
        base = mem_map[base.upper()]
    return symbols.get(symbol) - base

def DATA(section, address, len = 0):
    if len > 1:
        return snapshot[section][address:address + len]
    else:
        return snapshot[section][address]

def ASCIIZ(section, address):
    ofs = address
    data = snapshot[section]
    fin = ofs
    while data[fin] != 0: fin += 1
    return str(data[ofs:fin], 'ascii') if fin - ofs > 0 else ''


if len(sys.argv) == 1:
    sys.exit(('Unit test checker v0.1\n'
              '  USAGE: unit_checker.py <rules.json> <symbols.noi> <snapshot.sna> <screenshot.bmp>'))

config = {}

with open(sys.argv[1]) as json_file:
    config = json.load(json_file)

symbols = load_noi(sys.argv[2])
symbols = {value:key for key, value in symbols.items()}

snapshot = read_bgb_snspshot(sys.argv[3])

rules = config.get('rules', [])

for x in rules:
    if exec_rule(x) == False:
        sys.exit('TEST: {:s} FAILED!\n  FAILED RULE: "{:s}"\n'.format(get_rule_desc(sys.argv[1]), x))

sys.stdout.write('TEST: {:s} PASSED\n'.format(get_rule_desc(sys.argv[1])))
