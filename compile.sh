#!/bin/bash

# Controlla se sono stati passati gli argomenti necessari
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <main_file_without_extension> <output_file_name>"
    exit 1
fi

# Assegna gli argomenti a variabili
MAIN_FILE="$1"
OUTPUT_FILE="$2.pdf"

echo "⚙️  Pulizia file temporanei..."
latexmk -C

# Compilazione LaTeX con XeLaTeX
echo "📝 Primo passaggio con XeLaTeX..."
xelatex -interaction=nonstopmode "${MAIN_FILE}.tex"
if [ $? -ne 0 ]; then
    echo "❌ Errore: XeLaTeX ha fallito al primo passaggio!"
    exit 1
fi

# Controllo se viene usato biblatex
if grep -q "biblatex" "${MAIN_FILE}.tex"; then
    echo "📚 Esecuzione di Biber per la bibliografia..."
    biber "${MAIN_FILE}"
    if [ $? -ne 0 ]; then
        echo "❌ Errore: Biber ha fallito!"
        exit 1
    fi
else
    echo "ℹ️ Nessun biblatex rilevato, salto Biber."
fi

# Secondo passaggio per aggiornare riferimenti
echo "🔄 Secondo passaggio con XeLaTeX..."
xelatex -interaction=nonstopmode "${MAIN_FILE}.tex"
if [ $? -ne 0 ]; then
    echo "❌ Errore: XeLaTeX ha fallito al secondo passaggio!"
    exit 1
fi

# Terzo passaggio per riferimenti incrociati
echo "🔄 Terzo passaggio con XeLaTeX..."
xelatex -interaction=nonstopmode "${MAIN_FILE}.tex"
if [ $? -ne 0 ]; then
    echo "❌ Errore: XeLaTeX ha fallito al terzo passaggio!"
    exit 1
fi

# Rinomina il PDF generato
if [ -f "${MAIN_FILE}.pdf" ]; then
    echo "📄 Rinomino il file PDF in ${OUTPUT_FILE}..."
    mv "${MAIN_FILE}.pdf" "${OUTPUT_FILE}"
    echo "✅ Compilazione completata con successo! Output: ${OUTPUT_FILE}"
else
    echo "❌ Errore: PDF non trovato, compilazione fallita!"
    exit 1
fi

# Pulizia dei file temporanei
echo "🧹 Pulizia dei file temporanei..."
rm -f "${MAIN_FILE}".{aux,bbl,bcf,blg,log,lot,out,toc,run.xml,synctex.gz,fls,fdb_latexmk}

echo "🚀 Script completato!"
