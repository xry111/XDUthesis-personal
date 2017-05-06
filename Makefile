# The target for ":make" in vim.
# The "preview" nohup command seems an ugly hack...
render_and_preview:
	cat ThesisFiles/download_bib/*.bib > ThesisFiles/RefFile.bib
	latexmk --xelatex main && xterm -e "nohup evince main.pdf"

clean:
	rm -f *.toc *.bbl *.blg *.out *.aux *.log *.bak *.thm *.synctex.gz *.fdb_latexmk *.fls *.glo *.gls *.idx *.ilg *.ind
