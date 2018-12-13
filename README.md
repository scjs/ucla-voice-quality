This R package contains the acoustic and electroglottography measurements from
the [UCLA Voice Quality
Project](http://www.phonetics.ucla.edu/voiceproject/voice.html). It also
provides plain text versions of the word lists for all of the languages in the
project.

The original data have been converted into the [tidy data
format](https://r4ds.had.co.nz/tidy-data.html) for use with the tidyverse family
of R packages. The scripts that were used to convert and clean the original
Excel and PDF files are in the `data-raw` directory (`tidy-*.Rmd`).

If you want to use the data or word lists without using R, all of the tables in
this package are also available in CSV format in the `data-raw/csv` directory. A
description of each table is in the `R/data.R` text file.

This package is made available under a Creative Commons
Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0) license. If
you use this package, attribution should be made as follows: "Materials from the
"Production and Perception of Linguistic Voice Quality" project at UCLA."

Installation
------------

To install the package from GitHub, run this command in R:

    devtools::install_github("scjs/ucla-voice-quality")

You may need to install `devtools` first:

    install.packages("devtools")

Usage
-----

To see a list of the tables included with the package, use the `data()`
function:

	data(package = "voicequality")

To read a description of a table, use the `help()` function:

	help("acoustics", package = "voicequality")
	help("egg", package = "voicequality")

To load a table, use the `data()` function with the table name. For example,
this will load the table named `acoustics`, which contains the measurements from
the master acoustics spreadsheet on the project site:

	data("acoustics", package = "voicequality")

For a usage example, see the [`gujarati`
vignette](https://rpubs.com/scjs/gujarati).

Maintenance
-----------

To make corrections or additions, please send a pull request or file an issue.
The `TODO.md` file has a list of things that are known to be missing or
incorrect.
