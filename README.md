# DNA_damage_colocalization

<div align="center">
  
# Documentation forcolocalization analysis of DNA damage foci

</div>

### Pipeline

* _**1.	Tiff file extraction from nd2 files**_
* _**2.	Simple nuclear mask creation using Fiji**_

<br />

<div style="text-align: justify">
  
 ### 1.	Tiff file extraction from nd2 files
  
Use the [Fiji](https://fiji.sc/) macro ```open_nd2_split.ijm``` script to open a set of .nd2 (nikon software) files, split the channels and resave them as single tiff files in seperate folders in the output directory. The script also renames the files, for this, the script exprects these channels in this order: 1. C1, 2. C2, 3. C3 and 4. DAPI.
  
  
  
   ### 2.	Simple nuclear mask creation using Fiji
  
  Using thresholding in Fiji, a simple mask of the signal in the DAPi channel can be created using the ```create_nucleus_mask.ijm``` script. 
