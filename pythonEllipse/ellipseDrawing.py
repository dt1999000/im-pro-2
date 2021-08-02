# -*- coding: utf-8 -*-
"""
Created on Wed Jun 30 17:17:01 2021

@author: dt199
"""

#------------------------------import necessary modules------------------------
import scipy
import os
import numpy as np
import math
from scipy.interpolate import splprep, splev
import matplotlib.pyplot as plt
import cv2


#---------------------load the data from matlab environment/textfile-----------
with open('centroids 1.txt', 'r') as f:
    centerList1 = [[float(num) for num in line.split(',')] for line in f]
print(centerList1)

#------------------------------draw ellipse around the cluster centroids-------
centerList = np.array(centerList1)
#centerList = centerList/3.19
centerList = centerList.astype(int)
centerManual = ((1711,1640),(1900,2013),(1877,1371),(2150,1664),(2813,1420),(3199,1367),(3117,1880),(3472,1562),(3520,1706))
centerManual = np.array(centerList)
#centerManual = centerManual/3.19 #This line is for pictures that are rescaled when processing with matlab
centerManual = centerManual.astype(int)
print(centerList)
folder = os.getcwd()
imgName = r'Pflanze 1.jpg'
img_path = os.path.join(folder, imgName)
 
img = cv2.imread(img_path)
dimension = img.shape
print(dimension)

 

axesList = ((300, 400),(280, 330),(240, 300),(230, 310),(240, 170),(100, 200),(300, 200),(150, 320))
print(axesList)
angleList = (90,40,139,170,180,15,0,85)
startAngle = 0
endAngle = 360
colorList = ((200,20,43),(255,20,43),(225,255,43),(255,2,244),(12,200,200),(12,200,43),(200,200,255),(200,200,200))
thickness = 4
 
#ellipse(img, center, axes, angle, startAngle, endAngle, color[, thickness[, lineType[, shift]]]) -> img
for i in range(len(centerList)):
    axes = axesList[i]
    center = centerManual[i]
    angle = angleList[i]
    color = colorList[i]
    cv2.ellipse(img, center, axes, angle, startAngle, endAngle, color, thickness)
 
   
#cv2.imshow("Model Image", img)
#cv2.waitKey(0)   
#cv2.destroyAllWindows()
cv2.imwrite('Pflanze 1 Ellipse.png', img)

sumArea = 0
for i in range(len(centerList)):
    sumArea += axesList[i][0]* axesList[i][1]
   
sumArea = sumArea* math.pi * 50.25 / 682664
print(sumArea)
    
    