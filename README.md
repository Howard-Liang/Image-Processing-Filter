# Image-Processing-Filter

## Description

This is a project originally for class EEE 5022 at National Taiwan University.  
It implements an image filter/displayer chip that stores an input image into on-chip SRAM.  
It can then process a region of the saved image and display the processed region in raster-scan order.  
Several process functions are supported:  
◆ Input image loading  
◆ Display region up/down/left/right shifting  
◆ Display region scaling-down/up  
◆ Median filter  
◆ YCbCr display  
◆ Census transform  

## Block Diagram

<p align="center">
<img src="https://github.com/Howard-Liang/Single-Cycle-RISC-V/blob/main/image/architecture.JPG" width=40% height=40%>
</p>
