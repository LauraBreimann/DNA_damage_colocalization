//===============================================================================
// Creates a binary mask from of the DAPI signal
//  - Laura Breimann
//===============================================================================
#@ File (label = "DAPI directory", style = "directory") input
#@ String (label = "DAPI file suffix", value = ".tif") suffix
#@ File (label = "Output directory", style = "directory") output


//read in the DAPI file
processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	//open the file
	print("Processing: " + input + File.separator + file);
	open(input + File.separator + file);		
	selectWindow(file);
	
	// create max-projection
	run("Z Project...", "projection=Median");
	selectWindow(file);
	close(file);
	//setMinAndMax(101, 125);
	saveAs("tiff", output + File.separator +  file + "_median");	

		
	//run("Convert to Mask"); 
	//setThreshold(101, 5000, "raw"); // this threshold depends on the DAPI signal and the background, needs to be adapted
	setAutoThreshold("Otsu dark no-reset");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	
	//Smooth out the mask a bit, first remove some small bits and then dilate the connected shapes. 
	//This part depends a bit on the quality of the inital mask and might need to be adapted. 
	run("Erode");
	run("Close-");
	run("Fill Holes");
	run("Dilate");
	run("Close-");
	run("Fill Holes");
	run("Dilate");
	run("Watershed");
	
	//divide by 255 so that the values are 0 and 1 
	//run("Divide...", "value=255.000");
	//setMinAndMax(0, 1);
	
	// save file to output folder 
	print("Saving to: " + output);
	saveAs("tif", output + File.separator +  file + "_mask"); //actual mask file
	saveAs("PNG", output + File.separator +  file + "_mask");	//just to have a quick view at the result
	close();
}
print("Done");