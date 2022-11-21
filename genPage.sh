#!/bin/sh

touch ./index.html

echo "<!DOCTYPE html>
<html lang=\"en\">

<head>
  <meta charset=\"utf-8\">
  <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">
  <title>Gruvbox wallpapers</title>
</head>

<body>
  <h1>Wallpapers for gruvbox</h1>
  <hr>
  <p> Contrib <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers\">here</a> </p>" > ./index.html

for i in ./wallpapers/*
do
  subdir=$i
  echo "<h2>"${subdir##*/}"</h2>" >> ./index.html
 
  for j in ${subdir}/*
  do
    echo "  <a target=\"_blank\" href=\"$j\">
    <img loading=\"lazy\" src=\"$j\" alt="$j" width=\"200\">
  </a>" >> ./index.html
  done
done

echo "</body>

</html>" >> ./index.html
