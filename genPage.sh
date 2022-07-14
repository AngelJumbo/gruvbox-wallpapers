#!/bin/sh

touch ./index.html

echo "<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <title>Gruvbox wallpapers</title>
</head>

<body>
  <h1>Wallpapers for gruvbox</h1>
  <hr>
  <p> Contrib <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers\">here</a> </p>" > ./index.html

echo "<h2>IRL</h2>" >>./index.html
for i in ./wallpapers/irl/*
do
  echo "  <a target=\"_blank\" href=\"$i\">
    <img src=\"$i\" alt="$i" width=\"200\">
  </a>" >> ./index.html
done
echo "<h2>Minimalistic</h2>" >>./index.html
for i in ./wallpapers/minimalistic/*
do
  echo "  <a target=\"_blank\" href=\"$i\">
    <img src=\"$i\" alt="$i" width=\"200\">
  </a>" >> ./index.html
done
echo "<h2>Mix</h2>" >>./index.html
for i in ./wallpapers/mix/*
do
  echo "  <a target=\"_blank\" href=\"$i\">
    <img src=\"$i\" alt="$i" width=\"200\">
  </a>" >> ./index.html
done
echo "<h2>Pixelart</h2>" >>./index.html
for i in ./wallpapers/pixelart/*
do
  echo "  <a target=\"_blank\" href=\"$i\">
    <img src=\"$i\" alt="$i" width=\"200\">
  </a>" >> ./index.html
done
echo "<h2>Anime</h2>" >>./index.html
for i in ./wallpapers/anime/*
do
  echo "  <a target=\"_blank\" href=\"$i\">
    <img src=\"$i\" alt="$i" width=\"200\">
  </a>" >> ./index.html
done



echo "</body>

</html>" >> ./index.html
