#!/bin/bash

if [ -f "Data.tar.gz" ]; then
	echo "File seems to be already downloaded. Extracting contents ..."
else
	echo "File $FILE does not exist. Downloading ..."
	./third_party/gdown.pl https://drive.google.com/file/d/1ZR1qEf2qjQYA9zALLl-ZXuWhqG9lxzsM/view Data.tar.gz
fi

tar -zxvf Data.tar.gz
rm Data.tar.gz
