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


#---------------------load the data from matlab environment/textfile-----------
with open('A.txt', 'r') as f:
    dataset = np.array([[float(num) for num in line.split(',')] for line in f])
print(dataset)
#dataset = dataset/3.19
#---------------------load picture---------------------------------------------
folder = os.getcwd()
imgName = r'Pflanze 3.jpg'
img_path = os.path.join(folder, imgName)
 
img = cv2.imread(img_path)
dimension = img.shape
print(dimension)

#---------------------ellipse fitting with least squared-----------------------
ellipse = LsqEllipse().fit(dataset)
center, width, height, phi = ellipse.as_parameters()

center = np.array(center)
center = center.astype(int)


axes = np.array([width,height])
axes = axes.astype(int)


phi = np.array(phi)
phi = int(phi)


startAngle = 0
endAngle = 360
color = (250,0,0)
thickness = 4
#---------------------draw ellipse based on fitting result---------------------

cv2.ellipse(img, center, axes, phi, startAngle, endAngle, color, thickness)
cv2.imshow("Model Image", img)
cv2.waitKey(0)   
cv2.destroyAllWindows()
cv2.imwrite('manualEllipseFitPflanze3.png', img);
