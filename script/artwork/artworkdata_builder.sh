#!/usr/bin/env bash
# I have been using this on MacOSX High Sierra.

if [ "$1" != "" ]; then
    input=$1
    if [ ! -f $1 ]; then
        echo 'File not found.'
        exit
    fi
else
    echo '$sh artworkdata_builder.sh INPUT_FILE'
    echo 'You need INPUT_FILE as argument.'
    exit
fi

creatoreth='0x174B3C5f95c9F27Da6758C8Ca941b8FFbD01d330'

echo "\nChange file name($input) to index_name_sha256hash.gif format\n"
#create sha256 hash
sha256hash=$(openssl sha -sha256 $input)
#echo $sha256hash

#get only hash value
hash=$(printf "$sha256hash"|cut -d' ' -f2)
echo $hash

#get only index of file
index=$(printf "$input"|cut -d'_' -f1)
echo $index

#get base file name except file extension
prefix=$(printf "$input"|cut -d'.' -f1)
echo $prefix

artworknametmp=$(printf "$prefix"|cut -d'_' -f2-)
artworkname=$(echo "$artworknametmp"|sed -e 's/\_/\ /g')
echo $artworkname


#get file dementional size
dimension=$(file "$input"|cut -d',' -f3)
#echo $dimension
width=$(echo $dimension|cut -d' ' -f1)
#echo $width
height=$(echo $dimension|cut -d' ' -f3)
#echo $height

newfilename=$prefix"_"$hash.gif

#get base64 hash
base64=$(openssl base64 < $input | tr -d '\n')
#echo $base64

#get final data sha256 hash
datasha256=$(printf $newfilename|openssl sha -sha256)
#datasha256=$(openssl sha -sha256 <<< $newfilename)
#echo $datasha256

#get creation data and modify date
birthdate=$(stat -f "%SB" $input)
#echo $birthdate
modifydate=$(stat -f "%Sm" $input)
#echo $modifydate

echo "mv $input $prefix""_$hash.gif"
#cp $input $newfilename
#move to web images dir
cp $input ../../src/images/$newfilename



read -d '' jsonstr <<- EOF
{
    "id":"$index",
    "name":"$artworkname",
    "image":"$newfilename",
    "width":"$width",
    "height":"$height",
    "creator":"$creatoreth",
    "createdate":"$birthdate",
    "modifydate":"$modifydate",
    "metadata": {
                "sha256":"$hash",
                "base64":"$base64",
                "datasha256":"$datasha256"
    }
}
EOF
echo "$jsonstr"

echo "Creating $index.json for IPFS process..."
echo "$jsonstr" > ../artworkdata/$index.json
echo "Done, please check ../artworkdata/$index.json and ../../src/images/$newfilename."



#moving on IPFS process
echo "\nRemoving whitespaces\tab\linebreak from $index.json, and creating $index.json.min"
sed 's/^ *//g' ../artworkdata/$index.json |tr -d '\011\012\015' > ../artworkdata/$index.json.min;cat ../artworkdata/$index.json.min

echo "\n\nAdding $index.min to IPFS"
#ipfs_result=$(ipfs add ../artworkdata/$index.json.min)
ipfs_result=$(curl "https://ipfs.infura.io:5001/api/v0/add?pin=true" -X POST -H "Content-Type: multipart/form-data" -F file=@"../artworkdata/$index.json.min")

echo "$ipfs_result"
#ipfs_hash=$(echo "$ipfs_result"|cut -d' ' -f2)
ipfs_hash=$(echo "$ipfs_result"|cut -d',' -f2|cut -d':' -f2|cut -d'"' -f2)
echo "\nGo visite:"
#echo "https://ipfs.io/ipfs/$ipfs_hash"
echo "https://ipfs.infura.io:5001/api/v0/cat?arg=$ipfs_hash"

echo "\nRemember, tihs is not pined so, it will be gc in 24 hours."

echo "Creating cpixel string data"
read -d '' cpixeljsonstr <<- EOF
{
    "id":"$index",
    "name":"$artworkname",
    "image":"images/$newfilename",
    "width":"$width",
    "height":"$height",
    "creator":"$creatoreth",
    "createdate":"$birthdate",
    "modifydate":"$modifydate",
    "ipfshash":"$ipfs_hash"
},
EOF
echo "$cpixeljsonstr"
echo "$cpixeljsonstr" >> ../artworkdata/cpixel_raw.txt


