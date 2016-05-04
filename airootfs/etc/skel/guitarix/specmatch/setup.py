#!/usr/bin/python2
# -*- coding: utf-8 -*-
# Distutils installer for specmatch

# Test for Jack2
#---------------------------------------------------#
import os
if os.path.exists("/usr/local/include/jack/jack.h"):
  path = "/usr/local/include/jack/jack.h"
elif os.path.exists("/usr/include/jack/jack.h"):
  path = "/usr/include/jack/jack.h"
else:
  print("You don't seem to have the jack headers installed.\nPlease install them first")
  exit(-1)

test = open(path).read()

pyjack_macros=[]
if ("jack_get_version_string" in test):
  pyjack_macros+=[('JACK2', '1')]
else:
  pyjack_macros+=[('JACK1', '1')]
#----------------------------------------------------#

try:
    from setuptools import setup, Extension
except ImportError:
    from distutils.core import setup, Extension
import numpy.distutils

numpy_include_dirs = numpy.distutils.misc_util.get_numpy_include_dirs()

setup(
    name = "specmatch",
    version = "0.9",
    description = "Calculate an IR to match a spectrum",
    author='Andreas Degert',
    author_email='guitarix-developer@lists.sourceforge.net',
    url='http://sourceforge.net/projects/guitarix/',
    packages = ['specmatch'],
    scripts = ['scripts/specmatch'],
    package_data = {'specmatch': ['specmatch.glade']},
    data_files = [('share/applications', ['desktop/specmatch.desktop']),
                  ('share/mime/packages', ['desktop/specmatch.xml']),
                  ],
    license='GPL',
    long_description = "Calculate an IR to match a spectrum",
    install_requires = ['matplotlib','numpy','scipy','scikits.audiolab'],
    ext_modules = [Extension("specmatch.jackx",
                             ["pyjackx.c"],
                             libraries=["jack", "dl"],
                             include_dirs=numpy_include_dirs,
                             define_macros=pyjack_macros,
                             )],
    )
