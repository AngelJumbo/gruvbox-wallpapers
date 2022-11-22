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

color=1
for subdir in ./wallpapers/*
do

  echo "<h2 id=s"$color">" >> ./index.html
  echo "${subdir##*/}" | tr a-z A-Z  >> ./index.html
  echo "</h2>" >> ./index.html
  
  echo "<div id=c>" >> ./index.html

  for wallpaper in ${subdir}/*
  do
    echo "  <a target=\"_blank\" href=\"$wallpaper\">
    <img loading=\"lazy\" src=\"$wallpaper\" alt="$wallpaper" width=\"200\"></a>" >> ./index.html
  done
  
  echo "</div>" >> ./index.html

  color=$((color+1))
  if [ "$color" -eq 8 ]; then
    color=1
  fi
done

echo "<p> Contributions <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers\">here</a>.</p>
<p> This images are from random sites or contributions so I don't have a way to know who are their original artist.</p>
<p> I want to keep this site as simple as possible, but if you are the creator of any of these images and you want acknowledgment I will happily add a section with your name. Just open an issue <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers/issues\">here</a>.</p>
<p> The same goes, if you want me to remove your art.</p>
</body>
</html>" >> ./index.html
