# Convert all notebooks to markdown files
jupyter nbconvert _notebooks/*.ipynb --to markdown

# Make image URLS absolute
sed -i '' 's/!\[png\](/![png](\/images\/notebooks\//' _notebooks/*.md

# Remove weird unicode spaces
sed -i '' 's/ / /' _notebooks/*.md

# Move markdown files and rendered images to appropriate folders
mv _notebooks/*.md _posts/
trash images/notebooks
rsync -r _notebooks/*_files images/notebooks/
trash _notebooks/*_files
