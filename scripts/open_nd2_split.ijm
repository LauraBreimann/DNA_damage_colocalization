//===============================================================================
// Opens raw image stacks from Nikon software, spilts the channels, renames the channels and saves separate tiffs
// - Laura Breimann - 
//===============================================================================

// extension of the files to be opened
extension = "nd2";

// ask the user to provide the input and output folders
dir = getDirectory("Select a directory containing one or several ."+extension+" files.");
output = getDirectory("Select a directory to save the output files");

// create new subfolders to dave the split images
splitDir_DAPI= output + "/DAPI/" ;
splitDir_C1= output + "/C1/" ;
splitDir_C2= output + "/C2/" ;
splitDir_C3= output + "/C3/" ;
File.makeDirectory(splitDir_DAPI); 
File.makeDirectory(splitDir_C1); 
File.makeDirectory(splitDir_C2); 
File.makeDirectory(splitDir_C3); 

// record a list of all files in the input directory and print out what was found
files = getFileList(dir);
print("Detected files " +files.length);

// batch mode setting, comment this out to see each image being opend
setBatchMode(true); 

// Loop to find all images in the input folder with the correct extension
k=0;
n=0;
run("Bio-Formats Macro Extensions");
for(f=0; f<files.length; f++) {
	if(endsWith(files[f], "."+extension)) {
		k++;
		id = dir+files[f];
		Ext.setId(id);
		Ext.getSeriesCount(seriesCount);
		print(seriesCount+" series in "+id);		
		n+=seriesCount;
		for (i=0; i<seriesCount; i++) {
			// command to open the file 
			run("Bio-Formats Importer", "open=["+id+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+(i+1));
			
			// Get the name of the open image and create a variable with the filenmae without the extension for saving
			fullName	= getTitle();
			baseNameEnd=indexOf(fullName, "."+extension); 
         	fileName=substring(fullName, 0, baseNameEnd);

			getDimensions(x,y,c,z,t);			
					
			//select window
			selectWindow(fullName);
	
			//split channels 
			run("Split Channels");
			
			// the follwing code exprects a 4 channel image stack (C1, C2, C3, DAPI)
			// adapt the follwing code if the order is different in the images
			
			//select and save first channel
			selectWindow("C1-" + fullName);
			resetMinAndMax();
			run("Grays");
			saveAs(".tif", splitDir_C1  +fileName + "_C1" + ".tif");
			close();
			
			//select and save second channel
			selectWindow("C2-" + fullName);
			run("Grays");
			resetMinAndMax();
			saveAs(".tif", splitDir_C2  + fileName + "_C2" + ".tif");
			close();
						
			//select and save thrid channel
			selectWindow("C3-" + fullName);
			resetMinAndMax();
			run("Grays");
			saveAs(".tif", splitDir_C3  + fileName + "_C3" + ".tif");
			close();
						
			//select and save DAPI channel
			selectWindow("C4-" + fullName);
			resetMinAndMax();
			run("Grays");
			saveAs(".tif", splitDir_DAPI  + fileName + "_DAPI" + ".tif");
			close();									
		}	
     }
  }
  
// Remove spaces in filenames which can have issues in downstream analysis
run("Fix Funny Filenames", "which=" + splitDir_DAPI);
run("Fix Funny Filenames", "which=" + splitDir_C1);
run("Fix Funny Filenames", "which=" + splitDir_C2);
run("Fix Funny Filenames", "which=" + splitDir_C3);

// close all windows
print("Done");
run("Close All");

// Messages for log and how many images were processed
print("Saved to: " + output);
showMessage("Done with "+k+" files and "+n+" series!");
