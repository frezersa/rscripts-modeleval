###################################################
##  Main Control Script to process model output  ##
###################################################

################## General Setup ##################

## Number of cores to use? Must have the doParallel package installed
ncores <- 15

## Specify the high-resolution routing domain file
hydFile <- '/glade/p/ral/RHAP/gochis/Col_Upp_Rio_Grande/DOMAIN/updated_Nov_5_2014/Fulldom_hires_netcdf_file.nc' 

## Specify the low-resolution geogrid file
geoFile <- '/glade/p/ral/RHAP/gochis/Col_Upp_Rio_Grande/DOMAIN/geo_em.d02.nc' 

## Specify the aggregation factor between hydrogrid and geogrid
aggfact <- 10

## Specify location of .Rdata file containing pre-processed mask objects
maskFile <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/urg_MASKS_NEWDOMAIN_TAGGED_POINTS.Rdata'

## Specify whether the model run used NHD reach-based routing (otherwise gridded routing assumed)
# If TRUE, mask file should also contain rtLinks dataframe.
reachRting <- FALSE

## Temp directory to write intermediate files
tmpDir <- '/glade/scratch/karsten'


################## Observations ###################

## Path to Ameriflux data .Rdata file
AMFfile <- NULL 

## Path to SNOTEl data .Rdata file
SNOfile <- '/glade/p/ral/RHAP/alyssah/SNOTEL/obs_SNOTEL_1998_current_update.Rdata'

## Path to meteorological station data .Rdata file
METfile <- '/glade/p/ral/RHAP/adugger/Upper_RioGrande/OBS/MET/met_URG_NEW.Rdata'

## Path to streamflow data .Rdata file
STRfile <- '/glade/p/ral/RHAP/adugger/Upper_RioGrande/OBS/STRFLOW/obsStrData.Rdata'
 
################ SNODAS Point Files ###############

## Path to SNOTEL SNODAS .Rdata file
snodasSNOfile <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/REALTIME/urg_snotel_snodas_read_REALTIME.Rdata'

## Path to meteorological station .Rdata SNODAS file
snodasMETfile <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/WY15/urg_met_snodas_read_SNOWH_wy15.Rdata'

################ Model Output Reads ###############

## Read model output?
readMod <- FALSE

## If TRUE, specify the following to read in model output:

        # Specify the model run output directory or directories
        modPathList <- c('/glade/p/nral0008/zhangyx/URG_realtime/EXE')

        # Specify tags to identify the model run or runs (should be 1:1 with number of model output directories)
	modTagList <- c('realtime') 

        # Specify the output .Rdata file to create
        modReadFileOut <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/REALTIME/urg_modreads_snow.Rdata'
	#modReadFileOut <- '/glade/p/ral/RHAP/karsten/urg_analysis/urg_modelreads_out_retrospective_SNOTEL.Rdata' 
 
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
			readLink2gage <- read.table("/glade/p/ral/RHAP/adugger/CONUS_IOC/DOMAIN/link2gage_bigbigrivs.txt", sep="\t", header=TRUE, colClasses=c("integer","character"))

		# Snotel sites
		readSnoLdasout <- TRUE

		# Ameriflux sites
		readAmfLdasout <- FALSE

		# MET sites
		readMetLdasout <- FALSE

	# Subset LDASOUT variables?
	varsLdasoutSUB <-  FALSE
	varsLdasoutNFIE <- FALSE
	varsLdasoutIOC0 <- FALSE
	varsLdasoutSNOW <- TRUE

	# Specify start and end dates if you do NOT want to read all files
	readModStart <- as.POSIXct("2015-10-02", format="%Y-%m-%d", tz="UTC")
	readModEnd <- as.POSIXct("2016-02-10", format="%Y-%m-%d", tz="UTC")


################## Forcing Reads ##################

## Read forcing data?
readForc <- FALSE

## If TRUE, specify the following:

	# Specify the path to the forcing data
	forcPathList <- c('/glade/scratch/zhangyx/WRF-Hydro/RioGrande/NLDAS2.data') 

        # Specify tags to identify the forcings (should be 1:1 with number of model forcing directories)
	forcTagList <- c('Retrospective')

	# Specify the forcing output .Rdata file to create
	forcReadFileOut <- '/glade/p/ral/RHAP/adugger/Upper_RioGrande/ANALYSIS/151111_urg_forcingreads_RETEST.Rdata'
        # Append to existing file? FALSE = create new file (or overwrite existing!)
        forcAppend <- FALSE

	# Select what aggregations/imports to run:

		# Basin means
		readBasinLdasin <- TRUE

		# SNOTEL sites
		readSnoLdasin <- TRUE

		# Ameriflux sites
		readAmfLdasin <- FALSE

		# MET sites
		readMetLdasin <- TRUE

        # Specify start and end dates if you do NOT want to read all files
        readForcStart <- as.POSIXct("2013-01-01", format="%Y-%m-%d", tz="UTC") 
        readForcEnd <- as.POSIXct("2013-12-31", format="%Y-%m-%d", tz="UTC")

############# SNODAS ################

## Read SNODAS SWE data?
readSnodas <- FALSE

## If TRUE, specify the following:

        # Specify path to the regridded SNODAS NetCDF data
	snodasPathList <- c('/glade/p/work/karsten/urg_snodas/wrf_hydro_grids')

        # Specify tags to identify SNODAS product
        snodasTagList <- c('SNEQV')

        # Specify the snodas analysis output .Rdata file to create
        snodasReadFileOut <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/REALTIME/urg_snotel_snodas_read_REALTIME.Rdata'
	#snodasReadFileOut <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/REALTIME/urg_basin_snodas_read_REALTIME.Rdata'

         # Append to existing file? FALSE = create new file (or overwrite existing!)
        snodasAppend <- FALSE

        # Specify resolution in km
        resMod = 1.0

        # Select what aggregations/imports to run:

                # Basin means
                readBasinSnodas <- FALSE 

                # SNOTEL sites
                readSnoSnodas <- TRUE

                # Ameriflux sites
                readAmfSnodas <- FALSE

                # MET sites
                readMetSnodas <- FALSE

        # Specify start and end dates if you do NOT want to read all files
        readSnodasStart <- as.POSIXct("2015-10-02", format="%Y-%m-%d", tz="UTC")
        readSnodasEnd <- as.POSIXct("2016-02-10", format="%Y-%m-%d", tz="UTC")

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
        basSnoProc <- TRUE

## If any are TRUE, specify the following:

	# If the raw data read .Rdata file exists (vs. created above), specify the file
        #modReadFileIn <- '/glade/p/ral/RHAP/karsten/urg_analysis/urg_modelreads_out_retrospective_SNOTEL.Rdata'
        modReadFileIn <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/REALTIME/urg_modreads_snow.Rdata'
	forcReadFileIn <- '/glade/p/ral/RHAP/adugger/Upper_RioGrande/ANALYSIS/151111_urg_forcingreads_RETEST.Rdata'

        # Specify the stats output .Rdata file to create
	statsFileOut <- '/glade/p/ral/RHAP/karsten/urg_analysis/urg_snow_basin_stats_WY2004.Rdata'

	# Range dates for main stats
        stdate_stats <- NULL
        enddate_stats <- as.POSIXct("2015-09-30 00:00", format="%Y-%m-%d %H:%M", tz="UTC")

	# Range dates for seasonal stats (e.g., spring)
        stdate_stats_sub <- as.POSIXct("2014-11-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")
        enddate_stats_sub <- as.POSIXct("2015-09-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")

	# Write stats tables?
	writeStatsFile <- FALSE
	# If TRUE, specify output directory
        writeDir <- '/glade/p/ral/RHAP/karsten/urg_analysis'


################### Plotting ######################

## Create plots and/or maps?
createPlots <- TRUE

## Create HTML files?
writeHtml <- FALSE

## If TRUE, specify output directory
writePlotDir <- '/glade/p/ral/RHAP/karsten/urg_analysis'
	######### TIME SERIES PLOTS ###########

	## Generate accumulated flow plots?
	accflowPlot <- FALSE

		# Specify which run tags to plot
		accflowTags <- NULL

		# Specify start date
		accflowStartDate <- as.POSIXct("2015-04-01", format="%Y-%m-%d", tz="UTC")

		# Specify end date
		accflowEndDate <- NULL

	## Generate hydrographs?
	hydroPlot <- FALSE

        	# Specify which run tags to plot
        	hydroTags <- NULL 
 
        	# Specify start date
        	hydroStartDate <- as.POSIXct("2014-10-01", format="%Y-%m-%d", tz="UTC")
        
        	# Specify end date
        	hydroEndDate <- NULL

	## Generate accumulated precip plots?
	accprecipPlot <- FALSE

        	# Specify which run tags to plot
        	accprecipTags <- NULL
        
        	# Specify start date
        	accprecipStartDate <- as.POSIXct("2014-10-01", format="%Y-%m-%d", tz="UTC") 
        
        	# Specify end date
        	accprecipEndDate <- NULL

	## Generate Streamflow and Basin-mean SWE plots?
	flowswePlot <- FALSE

        	# Specify which run tags to plot
        	flowsweTags <- NULL
        
        	# Specify start date
        	flowsweStartDate <- as.POSIXct("2014-10-01", format="%Y-%m-%d", tz="UTC")
        
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
        	sweStartDate <- as.POSIXct("2014-10-01", format="%Y-%m-%d", tz="UTC")

        	# Specify end date
        	sweEndDate <- NULL

        ## Generate MET station plots?
        metPlot <- FALSE

                # Specify which run tags to plot
                metTags <- NULL

                # Specify start date
                metStartDate <- as.POSIXct("2014-10-01", format="%Y-%m-%d", tz="UTC")

                # Specify end date
                metEndDate <- NULL

	## Generate Basin Snow Metric Plots?
        snowBasinPlot <- FALSE

		# Specify basin snow data file
		snowBasDataFile <- '/glade/p/ral/RHAP/karsten/urg_analysis/data/REALTIME/urg_basin_snodas_read_REALTIME.Rdata'

                # Specify start date
                snowBasStartDate <- as.POSIXct("2015-10-02", format="%Y-%m-%d", tz="UTC")

                # Specify end date
                snowBasEndDate <- as.POSIXct("2016-02-10", format="%Y-%m-%d", tz="UTC")

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
                peakSweWY <- 2015

        ## Generate maps of model vs SNODAS errors for model tag(s) for a given time period.
        snodasErrorMap <- FALSE

                # Specify beginning date
                snowMapBegDate <- as.POSIXct("2014-11-01", format="%Y-%m-%d", tz="UTC")

                # Specify ending date
                snowMapEndDate <- as.POSIXct("2015-09-01", format="%Y-%m-%d", tz="UTC")

	## Scatter plots ##

	## Scatter plots for snow points of model against observations and analysis
	snowPointScatter <- TRUE

		# Specify the beginning date
		snowScatterBegDate <- as.POSIXct("2015-10-02", format="%Y-%m-%d", tz="UTC")

		# Specify the ending date
		snowScatterEndDate <- as.POSIXct("2016-02-10", format="%Y-%m-%d", tz="UTC")

		snotelScatter <- FALSE

		metScatter <- FALSE

		basinScatter <- TRUE # Perform scatter plot of all points within basins/regions?

	## Include summary stats tables?
	statsMapTables <- FALSE


###########################################################################################
## RUN (do not change anything below this line)

source("run_CONFIG.R")

