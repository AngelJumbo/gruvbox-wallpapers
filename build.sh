#!/bin/sh

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


#not really a header, it's just the begining of the page.
write_header(){
  echo "<!DOCTYPE html>
<html lang=\"en\">

<head>
  <meta charset=\"utf-8\">
  <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">
  <title>Gruvbox wallpapers</title>
</head>

<body>
  <h1>Wallpapers for gruvbox</h1>" > $1
}

write_section_header(){
  echo "<h2 id=s"$1">" >> $3
  echo "$2" | tr a-z A-Z  >> $3
  echo "</h2>" >> $3
}

write_img(){
  echo "  <a target=\"_blank\" href=\"$1\">
<img loading=\"lazy\" src=\"$1\" alt="$1" width=\"200\"></a>" >> $2
}

#not really a footer, it's just the end of the page.
write_footer(){
      echo "<p> Contributions <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers\">here</a>.</p>
<p> This images are from random sites or contributions so I don't have a way to know who are their original artist.</p>
<p> I want to keep this site as simple as possible, but if you are the creator of any of these images and you want acknowledgment I will happily add a section with your name. Just open an issue <a href=\"https://github.com/AngelJumbo/gruvbox-wallpapers/issues\">here</a>.</p>
<p> The same goes, if you want me to remove your art.</p>
</body>
</html>" >> $1

}

#create index file
touch ./index.html

#write the begining of the index file
write_header ./index.html

#color of the section headers 
#there are 7 colors and these are defined in the style.css 
#with the ids: s1, s2 .... s7
color=1

for subdir in ./wallpapers/*
do
  #for each folder in the wallpapers directory we first write a section header
  write_section_header $color "${subdir##*/}" ./index.html
  
  echo "<div id=c>" >> ./index.html
  
  count=1;
  for wallpaper in ${subdir}/*
  do
    #write each image of each folder in the Wallpapers directory
    if [ "$count" -lt 9 ]; then #limit the amount of images per section in index
      write_img $wallpaper ./index.html
      count=$((count+1))
    else #if the limit is exceeded then create a new html with all the images of the section
            
      subhtml="${subdir##*/}.html"
      #count the amount of images in the folder
      nimgs=$(ls "${subdir}" | wc -l)
      #make a link to the new page
      echo "  <a target=\"_blank\" class = \"showmore\" href=\"${subhtml}\">
      <div class = \"showmore\">show all ${nimgs} ${subdir##*/} wallpapers </div></a>" >> ./index.html      
      
      touch "$subhtml"
      
      write_header $subhtml

      write_section_header $color "${subdir##*/}" $subhtml


      echo "<div id=c>" >> "${subhtml}"
      #write all the images of the current section
      for wallpaper2 in ${subdir}/*
      do
        write_img $wallpaper2 $subhtml
      done

      echo "</div>" >> "${subhtml}"

      write_footer $subhtml
      #break current loop and continue to the next section
      break
    fi
    
  done
  
  echo "</div>" >> ./index.html

  color=$((color+1))
  #there are only 7 colors, if there are more than 7 folders in the wallpapers folder
  #then repeat the colors
  if [ "$color" -eq 8 ]; then 
    color=1
  fi
done

write_footer ./index.html
