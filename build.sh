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

write_header(){
  echo "<!DOCTYPE html>
<html lang=\"en\">

<head>
  <meta charset=\"utf-8\">
  <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">
  <title>Gruvbox wallpapers</title>
  <script>
    function loadPage(section, page) {
      let buttons = document.getElementById(section ).getElementsByTagName('button');
      let currSel;
      for(let i in buttons){
        if(buttons[i].classList?.contains('sel-btn')){
          if(page-1 == i)
            return;
          else{
            currSel = buttons[i];
            break;
          }
        }

      }

      fetch(section + '_page' + page + '.html')
        .then(response => response.text())
        .then(data => {
          document.getElementById(section + '-content').innerHTML = data;
          if (currSel){
            currSel.classList.remove('sel-btn');
          }
          document.getElementById(section).getElementsByTagName('button')[page-1].classList.add('sel-btn');
        });
    }
  </script>
</head>

<body>
  <h1>Wallpapers for Gruvbox</h1>" > $1
}

write_section_header(){
  echo "<h2 id=\"s$1\" class=\"clickable\" onclick=\"activeSection('$2')\" >" >> $3
  echo "$2" | tr a-z A-Z  >> $3
  echo "</h2>" >> $3
}

write_img(){
  echo "  <a target=\"_blank\" href=\"$1\">
<img loading=\"lazy\" src=\"$1\" alt=\"$1\" width=\"200\"></a>" >> $2
}

write_footer(){
  echo "<p> Contributions!! <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers\">here</a>.</p>
</body>
</html>" >> $1
}

touch ./index.html

write_header ./index.html

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

  echo "<div id=\"$section\">" >> ./index.html

  echo "<div class=\"pager\">" >> ./index.html
  countImgs=$(find "$subdir" -type f | wc -l)
  countImgs=$((countImgs - 1))
  for i in $(seq 1 $((( $countImgs / $maxPerPage)+1))); do
    echo "<button class=\"clickable\" onclick=\"loadPage('$section', $i)\">$i</button>" >> ./index.html
  done
  echo "</div>" >> ./index.html
  echo "<div id=\"$section-content\">" >> ./index.html
  echo "<div id=\"c\">" >> ./$subhtml
  for wallpaper in ${subdir}/*
  do
    if [ "$img_count" -ge $maxPerPage ]; then

      echo "</div>" >> ./$subhtml
      page=$((page + 1))
      subhtml="${section}_page${page}.html"
      touch ./$subhtml


      echo "<div id=\"c\">" >> ./$subhtml
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

echo "<script>
  window.onload = function myFunc() {" >> ./index.html

for section in "${sections[@]}"; do
  echo "    loadPage('$section', 1);
    document.getElementById('$section').style.display = \"none\";
  " >> ./index.html
done

echo "  
  document.getElementById(\"${sections[0]}\").style.display = \"block\";
}
  function activeSection(section){">> ./index.html

for section in "${sections[@]}"; do
  echo "
    document.getElementById('$section').style.display = \"none\";
  " >> ./index.html
done
  echo "  document.getElementById(section).style.display = \"block\";
document.getElementById(section).focus();
  }
</script>" >> ./index.html


write_footer ./index.html
