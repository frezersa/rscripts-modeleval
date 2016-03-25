###################################################
##  Main Control Script to process model output  ##
###################################################

################## General Setup ##################

## Number of cores to use? Must have the doParallel package installed
ncores <- 15

## Specify the high-resolution routing domain file
hydFile <- '/glade/p/ral/RHAP/gochis/WRF_Hydro_code/WRF-Hydro_NCEP_test_version_Oct_27_2015/DOMAIN/Fulldom_hires_netcdf_file_1km.nc'

## Specify the low-resolution geogrid file
geoFile <- '/glade/p/ral/RHAP/gochis/WRF_Hydro_code/WRF-Hydro_NCEP_test_version_Oct_27_2015/DOMAIN/geo_em.d01.nc.conus_1km'

## Specify the aggregation factor between hydrogrid and geogrid
aggfact <- 1

## Specify location of .Rdata file containing pre-processed mask objects
#maskFile <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/ecol3_MASKS_TAGGED_POINTS.Rdata'
maskFile <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/gagesII_MASKS_TAGGED_POINTS.Rdata'

## Specify whether the model run used NHD reach-based routing (otherwise gridded routing assumed)
# If TRUE, mask file should also contain rtLinks dataframe.
reachRting <- FALSE

## Temp directory to write intermediate files
tmpDir <- '/glade/scratch/karsten'

################## Observations ###################

## Path to Ameriflux data .Rdata file
AMFfile <- "/glade/p/ral/RHAP/adugger/CONUS_IOC/OBS/AMF/obs_AMF_1998_current.Rdata" 

## Path to SNOTEl data .Rdata file
SNOfile <- "/glade/p/ral/RHAP/adugger/CONUS_IOC/OBS/SNOTEL/obs_SNOTEL_1998_current.Rdata"

## Path to meteorological station data .Rdata file
METfile <- NULL

## Path to streamflow data .Rdata file
#STRfile <- "/glade/p/ral/RHAP/adugger/CONUS_IOC/OBS/USGS/obsStrData_BIGRIVSAMPLE.Rdata"
STRfile <- "/glade/p/ral/RHAP/adugger/CONUS_IOC/OBS/USGS/obsStrData_GAGESII_2010_2014_DV.Rdata"

################ SNODAS Point Files ###############

## Path to SNOTEL SNODAS .Rdata file
snodasSNOfile <- ''

## Path to meteorological station .Rdata SNODAS file
snodasMETfile <- ''

################ Model Output Reads ###############

## Read model output?
readMod <- FALSE

## If TRUE, specify the following to read in model output:

        # Specify the model run output directory or directories
	modPathList <- c('/glade/scratch/gochis/IOC_calib_runs/no_terr_rtg/v1.1_calib_no_oCONUS_no_res_new_route_link_16yr_Dec_26_2015')

        # Specify tags to identify the model run or runs (should be 1:1 with number of model output directories)
        modTagList <- c('WRF-Hydro Retrospective')

        # Specify the output .Rdata file to create
        #modReadFileOut <- '/glade/p/ral/RHAP/adugger/CONUS_IOC/ANALYSIS/151207_conus_gagesII_su2010allrt_modelout_AMF.Rdata'
        modReadFileOut <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/output/conus_modout_analysis_NHDPLUS_Run_5yr_terr_rtg_IOC_route_link_oCONUS_lakes.Rdata'
        # Append to existing file? FALSE = create new file (or overwrite existing!)
        modAppend <- FALSE

	# Select what aggregations/imports to run:

		# Basin means and imports
		readBasinLdasout <- TRUE
		readBasinRtout <- FALSE
		readGwout <- FALSE
		readFrxstout <- FALSE

		# Channel routing
		readChrtout <- FALSE
			# Read only links with gages?
			readChrtout_GAGES <- FALSE
			# Read specified subset? Provide object with link and site_no columns
			#link2gage.man <- read.table("/glade/p/ral/RHAP/adugger/CONUS_IOC/DOMAIN/link2gage_bigrivs.txt", sep="\t", header=TRUE)
			readLink2gage <- read.table("/glade/p/ral/RHAP/adugger/CONUS_IOC/DOMAIN/link2gage_gagesII.txt", sep="\t", header=TRUE)

		# Snotel sites
		readSnoLdasout <- FALSE

		# Ameriflux sites
		readAmfLdasout <- FALSE

		# MET sites
		readMetLdasout <- FALSE

	# Subset LDASOUT variables?
	varsLdasoutSUB <- FALSE
	varsLdasoutNFIE <- FALSE
	varsLdasoutIOC0 <- TRUE

	# Specify start and end dates if you do NOT want to read all files
	readModStart <- as.POSIXct("2010-01-02 00:00", format="%Y-%m-%d %H:%M", tz="UTC")
	readModEnd <- as.POSIXct("2010-01-12 23:59", format="%Y-%m-%d %H:%M", tz="UTC") 


################## Forcing Reads ##################

## Read forcing data?
readForc <- FALSE

## If TRUE, specify the following:

	# Specify the path to the forcing data
	forcPathList <- c('/glade/p/ral/RHAP/gochis/WRF_Hydro_code/WRF-Hydro_NCEP_test_version_Oct_27_2015/forcing/') 

        # Specify tags to identify the forcings (should be 1:1 with number of model forcing directories)
	forcTagList <- c('NLDAS2-Downscaled')

	# Specify the forcing output .Rdata file to create
	forcReadFileOut <- '/glade/p/ral/RHAP/adugger/CONUS_IOC/ANALYSIS/conus_nldas_forcings_2010.Rdata'
        # Append to existing file? FALSE = create new file (or overwrite existing!)
        forcAppend <- FALSE

	# Select what aggregations/imports to run:

		# Basin means 
		readBasinLdasin <- FALSE

		# SNOTEL sites
		readSnoLdasin <- TRUE

		# Ameriflux sites
		readAmfLdasin <- TRUE

		# MET sites
		readMetLdasin <- FALSE

        # Specify start and end dates if you do NOT want to read all files
        readForcStart <- as.POSIXct("2010-10-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")
        readForcEnd <- as.POSIXct("2011-08-01 23:59", format="%Y-%m-%d %H:%M", tz="UTC")


############# SNODAS ################

## Read SNODAS SWE data?
readSnodas <- TRUE

## If TRUE, specify the following:

	# Specify path to the regridded SNODAS NetCDF data
        snodasPathList <- c('/glade/scratch/karsten/conus_snodas_TMP/grids')

        # Specify tags to identify SNODAS product
        snodasTagList <- c('SNEQV')

        # Specify the snodas analysis output .Rdata file to create
	snodasReadFileOut <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/output/retro_analysis/data/conus_snodas_gaugesII_WY04_retrospective.Rdata'

         # Append to existing file? FALSE = create new file (or overwrite existing!)
        snodasAppend <- FALSE

        # Specify resolution in km
        resMod = 1.0

	# Select what aggregations/imports to run:

		# Basin means
		readBasinSnodas <- TRUE

		# SNOTEL sites
		readSnoSnodas <- FALSE

		# Ameriflux sites
		readAmfSnodas <- FALSE

		# MET sites
		readMetSnodas <- FALSE

	# Specify start and end dates if you do NOT want to read all files
	readSnodasStart <- as.POSIXct("2003-10-01", format="%Y-%m-%d", tz="UTC")
        readSnodasEnd <- as.POSIXct("2004-08-01", format="%Y-%m-%d", tz="UTC")

############# Model Performance Stats #############
 
## Calculate stats?
calcStats <- FALSE

	## Calculate streamflow performance stats?
	strProc <- FALSE
		# Read specified subset? Provide object with link and site_no columns
		statsLink2gage <- read.table("/glade/p/ral/RHAP/adugger/CONUS_IOC/DOMAIN/link2gage_gagesII.txt", 
					sep="\t", header=TRUE, colClasses=c("integer","character"))
                # Calculate daily stats?
                strProcDaily <- TRUE

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
	modReadFileIn <- '/glade/p/ral/RHAP/adugger/CONUS_IOC/ANALYSIS/OUT_AMFSNO/160106_conus_su2010v11_modelout_AMFSNO.Rdata'

        # Specify the stats output .Rdata file to create
        # statsFileOut <- '/glade/p/ral/RHAP/adugger/CONUS_IOC/ANALYSIS/151207_conus_gagesII_su2010allrt_stats_AMF.Rdata'
	statsFileOut <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/output/snow_metrics_WY2012_NHDPLUS_Run_5yr_terr_rtg_IOC_route_link_oCONUS_lakes.Rdata'

	# Range dates for main stats
	stdate_stats <- as.POSIXct("2011-101-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")
	enddate_stats <- as.POSIXct("2012-09-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")

	# Range dates for seasonal stats (e.g., spring)
	stdate_stats_sub <- as.POSIXct("2011-10-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")
	enddate_stats_sub <- as.POSIXct("2012-09-01 00:00", format="%Y-%m-%d %H:%M", tz="UTC")

	# Write stats tables?
	writeStatsFile <- FALSE
	# If TRUE, specify output directory
	#writeDir <- '/glade/p/ral/RHAP/adugger/CONUS_IOC/ANALYSIS/151207_gagesII_su2010allrt_PLOTS'
        writeDir <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/output'

################### Plotting ######################

## Create plots and/or maps?
createPlots <- FALSE

## Create HTML files?
writeHtml <- FALSE

## If TRUE, specify output directory
writePlotDir <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/output/retro_analysis'

	######### TIME SERIES PLOTS ###########

	## Generate accumulated flow plots?
	accflowPlot <- FALSE

		# Specify which run tags to plot
		accflowTags <- NULL

		# Specify start date
		accflowStartDate <- as.POSIXct("2014-04-01", format="%Y-%m-%d", tz="UTC")

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

	## Generate accumulated precip plots?
	accprecipPlot <- FALSE

        	# Specify which run tags to plot
        	accprecipTags <- NULL
        
        	# Specify start date
        	accprecipStartDate <- as.POSIXct("2013-10-01", format="%Y-%m-%d", tz="UTC")
        
        	# Specify end date
        	accprecipEndDate <- NULL

	## Generate Streamflow and Basin-mean SWE plots?
	flowswePlot <- FALSE

        	# Specify which run tags to plot
        	flowsweTags <- NULL
        
        	# Specify start date
        	flowsweStartDate <- as.POSIXct("2013-10-01", format="%Y-%m-%d", tz="UTC")
        
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
        	sweStartDate <- as.POSIXct("2013-10-01", format="%Y-%m-%d", tz="UTC")

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
	snowBasinPlot <- TRUE

		# Specify basin snow data file
		snowBasDataFile <- '/glade/p/ral/RHAP/karsten/conus_ioc/analysis/output/retro_analysis/data/conus_snodas_gaugesII_WY04_retrospective.Rdata'
	
		# Specify start date
		snowBasStartDate <- as.POSIXct("2003-10-01", format="%Y-%m-%d", tz="UTC")

		# Specify end date
		snowBasEndDate <- as.POSIXct("2004-08-01", format="%Y-%m-%d", tz="UTC")


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

	## Generate maps of model vs SNODAS errors for model tag(s) for a given time period.
        snodasErrorMap <- TRUE

                # Specify beginning date
                snowMapBegDate <- as.POSIXct("2003-11-01", format="%Y-%m-%d", tz="UTC")

                # Specify ending date
                snowMapEndDate <- as.POSIXct("2004-08-01", format="%Y-%m-%d", tz="UTC")

	## Generate map of peak SWE date for model tag(s) and SNODAS for a given water year
	peakSweMap <- FALSE
	
		# Specify WY
		peakSweWY <- 2015

        ## Scatter plots ##

        ## Scatter plots for snow points of model against observations and analysis
        snowPointScatter <- FALSE

                # Specify the beginning date
                snowScatterBegDate <- as.POSIXct("2011-10-01", format="%Y-%m-%d", tz="UTC")

                # Specify the ending date
                snowScatterEndDate <- as.POSIXct("2012-06-01", format="%Y-%m-%d", tz="UTC")

                snotelScatter <- FALSE

                metScatter <- FALSE

                basinScatter <- TRUE # Perform scatter plot of all points within basins/regions?

	## Include summary stats tables?
	statsMapTables <- FALSE


###########################################################################################
## RUN (do not change anything below this line)

source("run_CONFIG.R")

