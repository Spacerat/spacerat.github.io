jupyter nbconvert _notebooks/*.ipynb --to markdown
sed -i '' 's/!\[png\](/![png](\/images\/notebooks\//' _notebooks/*.md
mv _notebooks/*.md _posts/
trash images/notebooks
rsync -r _notebooks/*_files images/notebooks/
trash _notebooks/*_files