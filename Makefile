
.PHONY: website clean

website:
	mkdir _site
	cp Workshop/Präsentation.html _site
	cp -R Workshop/Präsentation_files _site/Präsentation_files
	cp -R Workshop/img _site/img
	cp -R Workshop/images _site/images
	cp -R Workshop/data	_site/data
	cp -R  Workshop/sqlite-db _site/sqlite-db
	cd _site
	zip -r Archive.zip *
	cd ..
	mv _site/Archive.zip .
	rm -rf _site

clean:
	rm Archive.zip
	cd Workshop
	rm *.html
	rm *.docx
	rm -rf *_files
