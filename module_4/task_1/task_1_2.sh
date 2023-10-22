directory="$1"

if [ ! -d "$directory" ]; then
    echo "The directory does not exist"
    exit 1
fi

find "$directory" -type d | while read dir; do
    file_count=$(find "$dir" -type f | wc -l)
    echo "Directory: $dir, files: $file_count"
done

