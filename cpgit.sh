files=$1  # Gets the names of the files to copy to command line

narg=$(echo $#)
if [ $narg -le 0 ]
    then  echo "Need at least one argument"
    exit
fi

#allfiles=$files README.md   #Always add the readme file

massage="Adding files $files"

git add $files
git commit -m "$massage"
git push


