#!/usr/bin/env bash

# MIT License
# Copyright (c) 2022 Angel Jumbo <anarjumb@protonmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


write_section_header(){
  echo "<h2 class='s$1 clickable' onclick='activeSection(\"$2\")' >" >> $3
  echo "$2" | tr a-z A-Z  >> $3
  echo "</h2>" >> $3
}

write_img(){
  echo "  <a target='_blank' href='$1'>
<img loading='lazy' src='$1' alt='$1' width='200'></a>" >> $2
}

rm *.html

touch ./index.html

echo "<!DOCTYPE html>
<html lang='en'>

<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <link rel='stylesheet' type='text/css' href='style.css'>
  <title>Gruvbox wallpapers</title>
  <script src='app.js' defer></script>
  <script src='https://kit.fontawesome.com/13865d7982.js' crossorigin='anonymous' defer></script>
</head>

<body>
  <div class='float-btns'>
    <a href='https://github.com/AngelJumbo/gruvbox-wallpapers' target='_blank' class='btn float-btn' title='Source code' >
      <span>
        <i class='fa-brands fa-github'></i>
      </span>
    </a>
    <button onclick='switchTheme()' class='btn float-btn' title='Switch theme'>
      <span>
        <i id='light-icon' class='fa-solid fa-sun'></i>
        <i id='dark-icon' class='fa-solid fa-moon'></i>
      </span>
    </button>
  </div>
  <main>
  <h1>Gruvbox Wallpapers</h1>" > ./index.html

color=1

maxPerPage=8 

declare -a sections

for subdir in ./wallpapers/*
do
  section="${subdir##*/}"
  sections+=("$section")
  write_section_header $color "$section" ./index.html


  page=1
  img_count=0
  subhtml="${section}_page${page}.html"
  touch ./$subhtml

  echo "<div class='section' id='$section'>" >> ./index.html

  echo "<div class='pager'>" >> ./index.html
  countImgs=$(find "$subdir" -type f | wc -l)
  countImgs=$((countImgs - 1))
  for i in $(seq 1 $((( $countImgs / $maxPerPage)+1))); do
    echo "<button class='btn pager-btn' onclick='loadPage(\"$section\", $i)'>$i</button>" >> ./index.html
  done
  echo "</div>" >> ./index.html
  echo "<div  id='$section-content'>" >> ./index.html
  echo "<div class='c'>" >> ./$subhtml
  for wallpaper in ${subdir}/*
  do
    if [ "$img_count" -ge $maxPerPage ]; then

      echo "</div>" >> ./$subhtml
      page=$((page + 1))
      subhtml="${section}_page${page}.html"
      touch ./$subhtml


      echo "<div class='c'>" >> ./$subhtml
      img_count=0
    fi

    write_img $wallpaper ./$subhtml
    img_count=$((img_count + 1))
  done

  echo "</div>" >> ./$subhtml

  echo "</div>" >> ./index.html
  echo "</div>" >> ./index.html

  color=$((color + 1))
  if [ "$color" -eq 8 ]; then 
    color=1
  fi
done
echo "</main>" >> ./index.html
echo "<script>
  window.onload = () => {" >> ./index.html
#echo "hideAll();" >> ./index.html
for section in "${sections[@]}"; do
  echo "    loadPage('$section', 1);" >> ./index.html
done

echo "
  activeSection('${sections[0]}');
  if (window.matchMedia('(prefers-color-scheme: dark)').matches){
    setTheme('dark');
  }else{
    setTheme('light');
  }
}
</script>" >> ./index.html


echo "
</body>
</html>" >> ./index.html
