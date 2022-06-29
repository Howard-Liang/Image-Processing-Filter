# Image-Processing-Filter

## Description

This is a project originally for class EEE 5022 at National Taiwan University.  
It implements an image filter/displayer chip that stores an input image into on-chip SRAM.  
It can then process a region of the saved image and display the processed region in raster-scan order. 
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_effect.PNG" width=60% height=60%>
</p>

Several process functions are supported:  
◆ Input image loading  
◆ Display region up/down/left/right shifting  
◆ Display region scaling-down/up  
◆ Median filter  
◆ YCbCr display  
◆ Census transform  

## Block Diagram

<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_block_diagram.PNG" width=60% height=60%>
</p>

Top module: ipdc.v

## Specification

<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_spec.png" width=60% height=60%>
</p>
