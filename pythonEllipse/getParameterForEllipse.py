# -*- coding: utf-8 -*-
"""
Created on Mon Aug  2 13:11:32 2021

@author: dt199
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Jul 29 18:04:28 2021

@author: dt199
"""


import scipy
import os
import numpy as np
from ellipse import LsqEllipse
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
import cv2

#---------------------load picture---------------------------------------------
folder = os.getcwd()
imgName = r'Pflanze 3.jpg'
img_path = os.path.join(folder, imgName)
 
img = cv2.imread(img_path)
dimension = img.shape
print(dimension)

#---------------------ellipse fitting with least squared-----------------------
def fit(dataset):
    
    ellipse = LsqEllipse().fit(dataset)
    center, width, height, phi = ellipse.as_parameters()
    
    center = np.array(center)
    center = center.astype(int)
    
    
    axes = np.array([width,height])
    axes = axes.astype(int)
    
    
    phi = np.array(phi)
    phi = int(phi)
    
    
    
    return [center,axes,phi]
#---------------------calculate param and write into textfile------------------
numberofleaves = 8

center = [np.zeros(numberofleaves),np.zeros(numberofleaves)]
axes = np.array([np.zeros(numberofleaves),np.zeros(numberofleaves)])
print(axes)
phi = np.zeros(numberofleaves)
for i in range(8):
    with open('Pflanze3Nummer'+str(i+1) + '.txt', 'r') as f:
        dataset = np.array([[float(num) for num in line.split(',')] for line in f])
        [[center[0][i],center[1][i]],[axes[0][i],axes[1][i]],phi[i]] = fit(dataset)
        print(center)
        print(axes)
        print(phi)
    print(dataset)
#dataset = dataset/3.19




#-------------------------write the params in a text file----------------------
on = True
path = 'paramlistPflanze3.txt'

if (on):
    
    with open(path, 'a') as f:
        for i in range(numberofleaves):
            f.write(str(center[0][i])+ ','+str(center[1][i])+ ',' + str(axes[0][i]) +',' + str(axes[1][i]) +',' + str(phi[i]) + "\n")
    


