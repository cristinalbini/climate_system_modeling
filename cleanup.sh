#!/bin/bash

# Clean up old auxiliary and output files
echo "Cleaning up old auxiliary files..."

# Remove matching files in the current directory
rm -f *.{aux,bbl,bcf,blg,log,lot,out,toc,run.xml,synctex.gz,bak0,bak1,bak2,bak3,bak4,bak5,bak6,bak7,bak8,bak9,bak10}

# Remove matching files in subdirectories up to a depth of 2
find . -maxdepth 2 -type f \( \
    -name "*.aux" -o \
    -name "*.bbl" -o \
    -name "*.bcf" -o \
    -name "*.blg" -o \
    -name "*.log" -o \
    -name "*.lot" -o \
    -name "*.out" -o \
    -name "*.toc" -o \
    -name "*.run.xml" -o \
    -name "*.synctex.gz" -o \
    -name "*.bak0" -o \
    -name "*.bak1" -o \
    -name "*.bak2" -o \
    -name "*.bak3" -o \
    -name "*.bak4" -o \
    -name "*.bak5" -o \
    -name "*.bak6" -o \
    -name "*.bak7" -o \
    -name "*.bak8" -o \
    -name "*.bak9" -o \
    -name "*.bak10" \
\) -exec rm -f {} +

echo "Cleanup complete."
