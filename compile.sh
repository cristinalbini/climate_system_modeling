#!/bin/bash

# Check if required arguments are passed
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <main_file_without_extension> <output_file_name>"
    exit 1
fi

# Assign arguments to variables
MAIN_FILE="$1"
OUTPUT_FILE="$2.pdf"

# Clean up old auxiliary and output files
echo "Cleaning up old auxiliary files..."
rm -f "${MAIN_FILE}".{aux,bbl,bcf,blg,log,lot,out,toc,run.xml,synctex.gz,fls,fdb_latexmk}

# Compile LaTeX document (first pass)
echo "Running pdflatex (first pass)..."
pdflatex -interaction=nonstopmode "${MAIN_FILE}".tex
if [ $? -ne 0 ]; then
    echo "pdflatex failed during the first pass!"
    exit 1
fi

# Run biber for bibliography management if biblatex is used
if grep -q "biblatex" "${MAIN_FILE}.tex"; then
    echo "Running biber..."
    biber "${MAIN_FILE}"
else
    echo "No biblatex found, skipping biber."
fi

# Compile LaTeX document (second pass)
echo "Running pdflatex (second pass)..."
pdflatex -interaction=nonstopmode "${MAIN_FILE}".tex
if [ $? -ne 0 ]; then
    echo "pdflatex failed during the second pass!"
    exit 1
fi

# Compile LaTeX document (third pass for references)
echo "Running pdflatex (third pass)..."
pdflatex -interaction=nonstopmode "${MAIN_FILE}".tex
if [ $? -ne 0 ]; then
    echo "pdflatex failed during the third pass!"
    exit 1
fi

# Rename the output PDF
if [ -f "${MAIN_FILE}.pdf" ]; then
    echo "Renaming output PDF to ${OUTPUT_FILE}..."
    mv "${MAIN_FILE}".pdf "${OUTPUT_FILE}"
    echo "Compilation completed successfully! Output PDF: ${OUTPUT_FILE}"
else
    echo "Compilation failed: Output PDF not found."
    exit 1
fi

# Clean up old auxiliary files
echo "Cleaning up old auxiliary files..."
rm -f "${MAIN_FILE}".{aux,bbl,bcf,blg,log,lot,out,toc,run.xml,synctex.gz}
