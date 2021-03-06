###################################################
##  Main Control Script to process model output  ##
###################################################

################## General Setup ##################

## Number of cores to use? Must have the doParallel package installed
ncores <- NULL 

## Specify the high-resolution routing domain file
hydFile <- NULL 

## Specify the low-resolution geogrid file
geoFile <- NULL 

## Specify the aggregation factor between hydrogrid and geogrid
aggfact <- NULL 

## Specify location of .Rdata file containing pre-processed mask objects
maskFile <- NULL 

## Specify whether the model run used NHD reach-based routing (otherwise gridded routing assumed)
# If TRUE, mask file should also contain rtLinks dataframe.
reachRting <- FALSE 

## Temp directory to write intermediate files
tmpDir <- NULL 


################## Observations ###################

## Path to Ameriflux data .Rdata file
AMFfile <- NULL 

## Path to SNOTEl data .Rdata file
SNOfile <- NULL 

## Path to meteorological station data .Rdata file
METfile <- NULL 

## Path to streamflow data .Rdata file
STRfile <- NULL
 
################ SNODAS Point Files ###############

## Path to SNOTEL SNODAS .Rdata file
snodasSNOfile <- NULL

## Path to meteorological station .Rdata SNODAS file
snodasMETfile <- NULL

################ Model Output Reads ###############

## Read model output?
readMod <- FALSE

## If TRUE, specify the following to read in model output:

        # Specify the model run output directory or directories
        modPathList <- NULL 

        # Specify tags to identify the model run or runs (should be 1:1 with number of model output directories)
	modTagList <- NULL

	# Specify ensemble information
        readEnsemble <- FALSE

	ensembleList <- NULL

	ensembleTagList <- NULL

        # Specify the output .Rdata file to create
	modReadFileOut <- NULL
 
	# Append to existing file? FALSE = create new file (or overwrite existing!)
        modAppend <- FALSE

	# Select what aggregations/imports to run:

		# Basin means and imports
		readBasinLdasout <- FALSE
		readBasinRtout <- FALSE
		readGwout <- FALSE
		readFrxstout <- FALSE

		# Channel routing
		readChrtout <- FALSE
			# Read only links with gages?
			readChrtout_GAGES <- FALSE
			# Read specified subset? Provide object with link and site_no columns
			readLink2gage <- NULL 

		# Snotel sites
		readSnoLdasout <- FALSE 

		# Ameriflux sites
		readAmfLdasout <- FALSE

		# MET sites
		readMetLdasout <- FALSE

	# Subset LDASOUT variables?
	varsLdasoutSUB <-  FALSE
	varsLdasoutNFIE <- FALSE
	varsLdasoutIOC0 <- FALSE
	varsLdasoutSNOW <- FALSE 

	# Specify start and end dates if you do NOT want to read all files
	readModStart <- NULL 
	readModEnd <- NULL 


################## Forcing Reads ##################

## Read forcing data?
readForc <- FALSE

## If TRUE, specify the following:

	# Specify the path to the forcing data
	forcPathList <- NULL

        # Specify tags to identify the forcings (should be 1:1 with number of model forcing directories)
	forcTagList <- NULL

	# Specify the forcing output .Rdata file to create
	forcReadFileOut <- NULL        

	# Append to existing file? FALSE = create new file (or overwrite existing!)
        forcAppend <- FALSE

	# Select what aggregations/imports to run:

		# Basin means
		readBasinLdasin <- FALSE 

		# SNOTEL sites
		readSnoLdasin <- FALSE 

		# Ameriflux sites
		readAmfLdasin <- FALSE

		# MET sites
		readMetLdasin <- FALSE 

        # Specify start and end dates if you do NOT want to read all files
        readForcStart <- NULL 
        readForcEnd <- NULL 

############# SNODAS ################

## Read SNODAS SWE data?
readSnodas <- FALSE

## If TRUE, specify the following:

        # Specify path to the regridded SNODAS NetCDF data
	snodasPathList <- NULL

        # Specify tags to identify SNODAS product
	snodasTagList <- NULL

        # Specify the snodas analysis output .Rdata file to create
	snodasReadFileOut <- NULL

        # Append to existing file? FALSE = create new file (or overwrite existing!)
        snodasAppend <- FALSE

        # Specify resolution in km
        resMod <- NULL 

        # Select what aggregations/imports to run:

                # Basin means
                readBasinSnodas <- FALSE 

                # SNOTEL sites
                readSnoSnodas <- FALSE 

                # Ameriflux sites
                readAmfSnodas <- FALSE

                # MET sites
                readMetSnodas <- FALSE

        # Specify start and end dates if you do NOT want to read all files
        readSnodasStart <- NULL 
        readSnodasEnd <- NULL 

############# Model Performance Stats #############

## Calculate stats?
calcStats <- FALSE

	## Calculate streamflow performance stats?
	strProc <- FALSE
		# Read specified subset? Provide object with link and site_no columns
		statsLink2gage <- NULL 
		# Calculate daily stats?
		strProcDaily <- FALSE

	## Calculate SNOTEL performance stats?
	snoProc <- FALSE

	## Calculate Ameriflux performance stats?
	amfProc <- FALSE

	## Calculate MET performance stats?
	metProc <- FALSE

	## Calculate basin snow performance/analysis statistics?
        basSnoProc <- FALSE 

## If any are TRUE, specify the following:

	# If the raw data read .Rdata file exists (vs. created above), specify the file
	modReadFileIn <- NULL	

	forcReadFileIn <- NULL

        # Specify the stats output .Rdata file to create
	statsFileOut <- NULL

	# Range dates for main stats
        stdate_stats <- NULL
        enddate_stats <- NULL 

	# Range dates for seasonal stats (e.g., spring)
        stdate_stats_sub <- NULL 
        enddate_stats_sub <- NULL 

	# Write stats tables?
	writeStatsFile <- FALSE
	# If TRUE, specify output directory
        writeDir <- NULL 


################### Plotting ######################

## Create plots and/or maps?
createPlots <- FALSE 

## Create HTML files?
writeHtml <- FALSE

## If TRUE, specify output directory
writePlotDir <- NULL
	######### TIME SERIES PLOTS ###########

	## Generate accumulated flow plots?
	accflowPlot <- FALSE

		# Specify which run tags to plot
		accflowTags <- NULL

		# Specify start date
		accflowStartDate <- NULL 

		# Specify end date
		accflowEndDate <- NULL

	## Generate hydrographs?
	hydroPlot <- FALSE

        	# Specify which run tags to plot
        	hydroTags <- NULL 
 
        	# Specify start date
        	hydroStartDate <- NULL 
        
        	# Specify end date
        	hydroEndDate <- NULL

	## Generate ensemble hydrographs?
        hydroEnsPlot <- FALSE

		# Specify which run tags to plot
                hydroTags2 <- NULL

                # Specify which ensembles to plot
                hydroEnsTags <- NULL 

                hydroEnsStartDate <- NULL 

                # Specify end date
                hydroEnsEndDate <- NULL 

	## Generate ensemble model basin snow plots?
	basSnoEnsPlot <- FALSE

		# Specify beginning date
		basSnowEnsStartDate <- NULL

		# Specify ending date
		basSnowEnsEndDate <- NULL

	## Generate accumulated precip plots?
	accprecipPlot <- FALSE

        	# Specify which run tags to plot
        	accprecipTags <- NULL
        
        	# Specify start date
        	accprecipStartDate <- NULL 
        
        	# Specify end date
        	accprecipEndDate <- NULL

	## Generate Streamflow and Basin-mean SWE plots?
	flowswePlot <- FALSE

        	# Specify which run tags to plot
        	flowsweTags <- NULL
        
        	# Specify start date
        	flowsweStartDate <- NULL 
        
        	# Specify end date
        	flowsweEndDate <- NULL

        ## Generate Streamflow and Basin-mean LSM Runoff plots?
        flowlsmPlot <- FALSE

                # Specify which run tags to plot
                flowlsmTags <- NULL

                # Specify start date
                flowlsmStartDate <- NULL

                # Specify end date
                flowlsmEndDate <- NULL

	## Generate SWE station plots?
	swePlot <- FALSE

        	# Specify which run tags to plot
        	sweTags <- NULL

        	# Specify start date
        	sweStartDate <- NULL 

        	# Specify end date
        	sweEndDate <- NULL

        ## Generate MET station plots?
        metPlot <- FALSE

                # Specify which run tags to plot
                metTags <- NULL

                # Specify start date
                metStartDate <- NULL 

                # Specify end date
                metEndDate <- NULL

	## Generate Basin Snow/SNODAS Metric Plots?
        snowBasinPlot <- FALSE

		# Specify basin snow data file
		snowBasDataFile <- NULL

                # Specify start date
                snowBasStartDate <- NULL 

                # Specify end date
                snowBasEndDate <- NULL 

	########### MAPS #############

	## Generate STRFLOW bias maps?
	strBiasMap <- FALSE

        	# Specify which run tags to plot
        	strBiasTags <- NULL

        	# Specify which run seasons to plot
        	strBiasSeas <- NULL

	## Generate STRFLOW correlation maps?
	strCorrMap <- FALSE

        	# Specify which run tags to plot
        	strCorrTags <- NULL

        	# Specify which run seasons to plot
        	strCorrSeas <- NULL

	## Generate SNOTEL SWE error maps?
	snosweErrMap <- FALSE

        	# Specify which run tags to plot
        	snosweErrTags <- NULL

        	# Specify which run seasons to plot
        	snosweErrSeas <- NULL

	## Generate SNOTEL Precip error maps?
	snoprecipErrMap <- FALSE

        	# Specify which run tags to plot
        	snoprecipErrTags <- NULL

        	# Specify which run seasons to plot
        	snoprecipErrSeas <- NULL

	## Generate map of peak SWE date for model tag(s) and SNODAS for a given water year
        peakSweMap <- FALSE

                # Specify WY
                peakSweWY <- NULL

        ## Generate maps of model vs SNODAS errors for model tag(s) for a given time period.
        snodasErrorMap <- FALSE

                # Specify beginning date
                snowMapBegDate <- NULL 

                # Specify ending date
                snowMapEndDate <- NULL 

	## Scatter plots ##

	## Scatter plots for snow points of model against observations and analysis
	snowPointScatter <- FALSE

		# Specify the beginning date
		snowScatterBegDate <- NULL 

		# Specify the ending date
		snowScatterEndDate <- NULL 

		snotelScatter <- FALSE

		metScatter <- FALSE

		basinScatter <- FALSE # Perform scatter plot of all points within basins/regions?

	## Include summary stats tables?
	statsMapTables <- FALSE


###########################################################################################
## RUN (do not change anything below this line)

source("run_CONFIG.R")

