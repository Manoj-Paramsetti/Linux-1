mkdir nosubsmkv;
echo "Creating nosubsmkv/ to store the output of mkvmerge"
echo ""

count=1
for file in *.mkv;
  do 
    name=`echo "$file"`
    outputfile=`echo "${name%.mkv}_1.mkv"`
    directory=`pwd`
    inputfile="${directory}/${name}"
    outputfile="${name%.mkv}_1.mkv"
    outputfilepath="${directory}/nosubsmkv/${name%.mkv}_1.mkv"
    finalname="${name%.mkv}.mkv"

    echo "File Number   : ${count}"
    echo "Input File    : ${inputfile}"
    echo "Output File   : ${outputfile}"
    echo ""

    echo "Creating the matroska file using ffmpeg"
    ffmpeg -i "${inputfile}" -c copy -map 0:v -map 0:a "${outputfilepath}" -v quiet -stats

    mv "nosubsmkv/${outputfile}" "nosubsmkv/${finalname}"
    echo "Removing the metadata!"
    mkvpropedit "nosubsmkv/${finalname}" --set title="" --delete-track-statistics-tags --tags all:
    echo "-------------------------------------------------------------"
    echo ""
    count=`expr $count + 1`
done
