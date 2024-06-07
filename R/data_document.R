
# NFT BART objects --------------------------------------------------------

#' OS prediction model
#'
#' NFT BART model to predict overall survival.
#'
#' @docType data
#' @keywords datasets
#' @name deadcounter
#' @format nft model object
NULL

#' EFS prediction model
#'
#' NFT BART model to predict event-free survival.
#'
#' @docType data
#' @keywords datasets
#' @name efscounter
#' @format nft model object
NULL

# Reference data ----------------------------------------------------------

#' Zip-code median household income look-up table
#'
#' A data frame of median household income by zip-code, obtained from the 2019 ACS.
#'
#' @docType data
#' @keywords datasets
#' @name zcta_hhinc
#' @format data frame with 1 row per zip-code
NULL

#' Function including factor and variable labels 
#'
#' A function to apply factor and variable labels to user input data.
#'
#' @docType data
#' @keywords datasets
#' @name dat_fmtfun
#' @format function 
NULL

#' Default user input values
#'
#' A data frame including the default values for user inputs. Default values were taken as the mode or median value for each item. 
#'
#' @docType data
#' @keywords datasets
#' @name patdat_default
#' @format data frame 
NULL

#' Variables to pass to predictive models
#'
#' A vector of the variable names that the predictive models were trained on. 
#'
#' @docType data
#' @keywords datasets
#' @name xtest_vnames
#' @format vector
NULL
