# Image-Processing-Filter

## Description

This is a project originally for EEE 5022 at National Taiwan University.  
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

<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_mode.PNG" width=60% height=60%>
</p>

## Supported Functions

◆ Input image loading  
The input image is given in raster-scan order.  
The design includes 3 on-chip SRAM, each stores the R/G/B-channel's pixel values respectively of the input image.
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_image.PNG" width=20% height=20%>
</p>

The default coordinate of the origin is at 0.
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_origin.PNG" width=35% height=35%>
</p>

◆ Display region up/down/left/right shifting  
EX. origin right shift (i_op_mode = 4’b0100)
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_right_shift_yes.PNG" width=40% height=40%>
</p>

If output of display exceeds the image boundary, retain the same origin point.
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_right_shift_no.PNG" width=40% height=40%>
</p>

◆ Display region scaling-down/up  
The chip can display the image in one of the 3 sizes: 4x4, 2x2, 1x1.  
That means if the display size now is 4x4, scaling up will retain the same display size.  
If the display size is now 1x1, scaling down will also retain the same display size.  
EX. scaling down: 4x4 --> 2x2
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_scale_down.PNG" width=45% height=45%>
</p>

EX. scaling up: 1x1 --> 2x2
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_scale_up.PNG" width=40% height=40%>
</p>

◆ Median filter 
For this operation the chip performs median filtering on the display region.  
The filter is a 3x3 kernel. It results in a median of the set of pixel value.  
The chip operates median filtering to R-channel, G-channel, B-channel, separately.  
The image is zero-padded for median filter operation.  
The values of original pixels will not be changed.
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_median_filter.PNG" width=40% height=40%>
</p>

◆ YCbCr display  
Estimated YCbCr calculation:  
Y = 0.25R + 0.625G  
Cb = − 0.125R − 0.25G + 0.5B + 128  
Cr = 0.5R − 0.375G − 0.125B + 128  

◆ Census transform  
For this operation the chip performs Census transform on the display region.  
The filter is a 3x3 kernel. It identifies the pixels with higher intensity than the center pixel.  
The chip operates Census transform to R-channel, G-channel, B-channel, separately.  
The image is zero-padded for Census Transform.  
The values of original pixels will not be changed.  
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_census_transform.PNG" width=48% height=48%>
</p>

## Pipeline Design
To meet the latency standard, the critical path, which is the datapath for median filter has a pipeline design similar to that of  
"Hossein Zamani HosseinAbadi, Shadrokh Samavi, and Nader Karimi. 2013. Image Noise Reduction by Low Complexity Hardware Median Filter".  
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_median_pipeline.PNG" width=35% height=35%>
</p>
After implementation and static timing analysis, only the level 2 pipeline stage in the image above is used in the final design to save the area of 9 registers in level 1 stage.

## APR Result
Clock Tree Debugger
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_cct_debugger.PNG" width=40% height=40%>
</p>

Clock Tree Routing
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_cct_route.PNG" width=40% height=40%>
</p>

Layout
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_layout.PNG" width=40% height=40%>
</p>

STA Setup
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_apr_sta_setup.PNG" width=40% height=40%>
</p>

STA Hold
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_apr_sta_hold.PNG" width=40% height=40%>
</p>

DRC Check
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_drc.PNG" width=40% height=40%>
</p>

LVS Check
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_lvs.PNG" width=40% height=40%>
</p>

Report
<p align="center">
<img src="https://github.com/Howard-Liang/Image-Processing-Filter/blob/main/image/ipdc_layout_result.PNG" width=40% height=40%>
</p>


## Testing 
A testbed_temp.v were written by myself to verify the functionality of the chip.  
However, note that the SRAM module used in this poject isn't provided in this repo.  
Therefore, the testing will only work properly if you have the SRAM module.  
The SRAM module: High-Speed Single-Port Synchronous Flex-Repair SRAM with Redundancy, sram_256x8  
Process Technology: TSMC CL013G  

RTL simulation: (replace tb* with tb0/tb1/tb2/tb3)
```
$ ncverilog -f rtl_01.f +notimingchecks +access+r +define+tb*
```
Gate-level simulation:
```
ncverilog -f rtl_03.f +ncmaxdelays +define+SDF+tb* +access+r
```
Post layout simulation: (note that tsmc13_neg.v also isn't provided in this repo)
```
ncverilog testbed_temp.v ipdc_pr.v tsmc13_neg.v +ncmaxdelays +define+SDF+tb* +access+r
```
