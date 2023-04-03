// Define input and output folders as well as image type
#@ File (label = "CSV file", style = "file") input
#@ File (label = "Image", style = "file") image
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".csv") suffix

// open the image and get the title and a title without the suffix
open(image);
titleOfCurrentImage = getTitle();
shortTitle = replace(titleOfCurrentImage, ".tif" , "_")

// calls the function below to read the table of localizations
processFile(input);

//function to read X and Y of the localizations 
function processFile(input) {

	Table.open(input);
	xpoints = Table.getColumn("x"); 
	ypoints = Table.getColumn("y");
	makeSelection("point small red circle", xpoints, ypoints); //creates overlays from the XY coordinates, here small red circles
	
// open the ROI manager and add the overlay as an object so it can be manioulated further, this can be commented out		
run("ROI Manager...");
roiManager("Add");	


// save the overlay tiff to the output directory, can be commented out
saveAs(output + File.separator  + shortTitle +  "overlay.tif");		
			