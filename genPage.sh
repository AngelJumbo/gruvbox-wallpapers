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
  <h1>Wallpapers for gruvbox</h1>" > ./index.html
n=1
for i in ./wallpapers/*
do
  subdir=$i
 


  echo "<h2" >> ./index.html
  echo "id=s"$n">" >> ./index.html
  echo "${subdir##*/}" | tr a-z A-Z  >> ./index.html
  echo "</h2>" >> ./index.html
  
  echo "<div id=c>" >> ./index.html

  for j in ${subdir}/*
  do
    echo "  <a target=\"_blank\" href=\"$j\">
    <img loading=\"lazy\" src=\"$j\" alt="$j" width=\"200\"></a>" >> ./index.html
  done
  
  echo "</div>" >> ./index.html

  n=$((n+1))
  if [ "$n" -eq 8 ]; then
    n=1
  fi
done

echo "<p> Contributions <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers\">here</a>.</p>
<p> This images are from random sites or contributions so I don't have a way to know who are their original artist.</p>
<p> I want to keep this site as simple as possible, but if you are the creator of any of these images and you want acknowledgment I will happily add a section with your name. Just open an issue <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers/issues\">here</a>.</p>
<p> The same goes, if you want me to remove your art.</p>
</body>
</html>" >> ./index.html
