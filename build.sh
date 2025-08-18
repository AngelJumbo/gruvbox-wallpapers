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

generate_thumbnails() {
  echo "generate thumbnails ..."
  mkdir -p thumbnails
  rm -rf thumbnails/*
  
  # Count total number of images
  total_images=$(find ./wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)
  current_image=0
  
  for section_dir in ./wallpapers/*; do
    section_name="${section_dir##*/}"
    mkdir -p "thumbnails/$section_name"
    
    # Process dark images (base directory)
    for img in "$section_dir"/*; do
      [ -f "$img" ] || continue
      case "$img" in
        *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG) ;;
        *) continue ;;
      esac
      
      current_image=$((current_image + 1))
      local img_filename="${img##*/}"
      local thumbnail="thumbnails/$section_name/$img_filename"
      echo "($current_image/$total_images): $img -> $thumbnail"
      convert "$img" -resize 300x300 "$thumbnail"
    done
    
    # Process light images if light folder exists
    if [ -d "$section_dir/light" ]; then
      mkdir -p "thumbnails/$section_name/light"
      for img in "$section_dir/light"/*; do
        [ -f "$img" ] || continue
        case "$img" in
          *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG) ;;
          *) continue ;;
        esac
        
        current_image=$((current_image + 1))
        local img_filename="${img##*/}"
        local thumbnail="thumbnails/$section_name/light/$img_filename"
        echo "($current_image/$total_images): $img -> $thumbnail"
        convert "$img" -resize 300x300 "$thumbnail"
      done
    fi
  done
  
  echo "Thumbnail generation complete: $total_images images processed"
}

check_has_light_folder() {
  local section_dir=$1
  [ -d "$section_dir/light" ] && echo "true" || echo "false"
}

count_images_in_dir() {
  local dir=$1
  find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l
}

create_section_data() {
  local section=$1
  local subdir=$2
  local maxPerPage=8
  local has_light=$(check_has_light_folder "$subdir")
  
  echo "Creating data for section: $section"
  
  # Create JSON data file for the section
  local data_file="${section}_data.js"
  
  cat > "$data_file" << EOF
// Data for $section section
window.sectionData = window.sectionData || {};
window.sectionData['$section'] = {
  hasLight: $has_light,
  maxPerPage: $maxPerPage,
  dark: [
EOF

  # Generate dark images data
  for wallpaper in "$subdir"/*; do
    [ -f "$wallpaper" ] || continue
    case "$wallpaper" in
      *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG) ;;
      *) continue ;;
    esac
    
    local img_path="${wallpaper#./}"
    local img_filename="${wallpaper##*/}"
    local thumbnail_path="thumbnails/$section/$img_filename"
    echo "    { src: '$img_path', thumb: '$thumbnail_path', alt: '$img_filename' }," >> "$data_file"
  done

  # Generate light images data if exists
  echo "  ]," >> "$data_file"
  if [ "$has_light" = "true" ]; then
    echo "  light: [" >> "$data_file"
    for wallpaper in "$subdir/light"/*; do
      [ -f "$wallpaper" ] || continue
      case "$wallpaper" in
        *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG) ;;
        *) continue ;;
      esac
      
      local img_path="${wallpaper#./}"
      local img_filename="${wallpaper##*/}"
      local thumbnail_path="thumbnails/$section/light/$img_filename"
      echo "    { src: '$img_path', thumb: '$thumbnail_path', alt: '$img_filename' }," >> "$data_file"
    done
    echo "  ]" >> "$data_file"
  else
    echo "  light: []" >> "$data_file"
  fi

  echo "};" >> "$data_file"
}

# Clean up old files
rm -f *.html *.js

# Generate thumbnails
generate_thumbnails

# Create main index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'>
  <link rel='stylesheet' type='text/css' href='style.css'>
  <title>Gruvbox wallpapers</title>
  <style>
    .section-content {
      margin: 20px 0;
      opacity: 0;
      visibility: hidden;
      transition: all 0.3s ease-in-out;
      transform: translateY(10px);
    }
    
    .section.selected .section-content {
      opacity: 1;
      visibility: visible;
      transform: translateY(0);
    }
    
    /* Theme switcher styles */
    .section-theme-switcher {
      text-align: center;
      margin: 15px 0;
      opacity: 0;
      visibility: hidden;
      transition: all 0.3s ease-in-out;
      transform: translateY(-10px);
    }
    
    .section.selected .section-theme-switcher {
      opacity: 1;
      visibility: visible;
      transform: translateY(0);
    }
    
    .theme-toggle {
      display: inline-flex;
      gap: 0;
    }
    
    .theme-btn {
      padding: 10px 20px;
      background-color: var(--bg-color-reverse);
      color: var(--fg-color-reverse);
      border: 2px solid transparent;
      cursor: pointer;
      transition: border-color 0.3s ease;
      font-weight: 600;
      font-size: 14px;
      argin: 0 5px 0 5px;
    }
    
    .theme-btn:hover {
      background-color: var(--bg-color-reverse);
    }
    
    .theme-btn.active {
      border: 4px solid var(--fg-color);
      background-color: var(--bg-color);
      color: var(--fg-color);
    }
    
    .subsection-content {
      display: none;
    }
    
    .subsection-content.active {
      display: block;
    }
    
    .loading {
      text-align: center;
      padding: 40px;
      color: var(--fg-color);
    }
  </style>
</head>
<body>
  <div class='float-btns'>
    <a href='https://github.com/AngelJumbo/gruvbox-wallpapers' target='_blank' class='btn float-btn' title='Source code'>
      <span>
       <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-github-icon lucide-github"><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"/><path d="M9 18c-4.51 2-5-2-7-2"/></svg>
      </span>
    </a>
    <button onclick='switchMainTheme()' class='btn float-btn' title='Switch theme'>
      <span>
       <svg id="light-icon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-sun-icon lucide-sun"><circle cx="12" cy="12" r="4"/><path d="M12 2v2"/><path d="M12 20v2"/><path d="m4.93 4.93 1.41 1.41"/><path d="m17.66 17.66 1.41 1.41"/><path d="M2 12h2"/><path d="M20 12h2"/><path d="m6.34 17.66-1.41 1.41"/><path d="m19.07 4.93-1.41 1.41"/></svg>
       <svg id="dark-icon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-moon-icon lucide-moon"><path d="M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401"/></svg>
       
      </span>
    </button>
  </div>

  <main>
    <h1>Gruvbox Wallpapers</h1>
EOF

# Generate sections
color=1
declare -a sections
declare -a sections_with_light

for subdir in ./wallpapers/*; do
  section="${subdir##*/}"
  sections+=("$section")
  has_light=$(check_has_light_folder "$subdir")
  
  if [ "$has_light" = "true" ]; then
    sections_with_light+=("$section")
  fi
  
  # Create the data file
  create_section_data "$section" "$subdir"
  
  # Add section to main page
  echo "    <h2 class='s$color clickable' onclick='activeSection(\"$section\")'>" >> index.html
  echo "      $(echo "$section" | tr a-z A-Z)" >> index.html
  echo "    </h2>" >> index.html
  echo "    <div class='section' id='$section'>" >> index.html
  
  # Add theme switcher if section has light variant
  if [ "$has_light" = "true" ]; then
    echo "      <div class='section-theme-switcher'>" >> index.html
    echo "        <div class='theme-toggle'>" >> index.html
    echo "          <button class='theme-btn active' onclick='switchSectionTheme(\"$section\", \"dark\")' id='$section-dark-btn'>Dark</button>" >> index.html
    echo "          <button class='theme-btn' onclick='switchSectionTheme(\"$section\", \"light\")' id='$section-light-btn'>Light</button>" >> index.html
    echo "        </div>" >> index.html
    echo "      </div>" >> index.html
  fi
  
  echo "      <div class='section-content' id='$section-content'>" >> index.html
  echo "        <div class='loading'>Loading...</div>" >> index.html
  echo "      </div>" >> index.html
  echo "    </div>" >> index.html

  color=$((color + 1))
  if [ "$color" -eq 8 ]; then
    color=1
  fi
done

# Add all section data scripts
for section in "${sections[@]}"; do
  echo "  <script src='${section}_data.js'></script>" >> index.html
done

# Add main JavaScript
cat >> index.html << 'EOF'
  <script>
    // Global state
    let activeSectionName = null;
    let sectionStates = {};

    // Initialize section state
    function initSectionState(section) {
      if (!sectionStates[section]) {
        sectionStates[section] = {
          currentTheme: 'dark',
          currentPages: { dark: 1, light: 1 },
          loaded: false
        };
      }
    }

    function activeSection(section) {
      hideAllSections();
      const targetSection = document.getElementById(section);
      
      targetSection.classList.add('selected');
      activeSectionName = section;
      
      initSectionState(section);
      
      // Load content if not already loaded
      if (!sectionStates[section].loaded) {
        loadSectionContent(section);
      }
      
      // Reset to dark theme
      if (window.sectionData[section].hasLight) {
        switchSectionTheme(section, 'dark');
      }
      
      setTimeout(() => {
        targetSection.scrollIntoView({ block: 'start', behavior: 'smooth' });
      }, 100);
    }

    function hideAllSections() {
      document.querySelectorAll('.section').forEach(s => {
        s.classList.remove('selected');
      });
      activeSectionName = null;
    }

    function loadSectionContent(section) {
      const contentDiv = document.getElementById(section + '-content');
      const data = window.sectionData[section];
      
      if (!data) {
        contentDiv.innerHTML = '<div class="loading">Error: Section data not found</div>';
        return;
      }
      
      let html = '';
      
      // Dark content
      if (data.dark.length > 0) {
        html += `<div class="subsection-content active" id="${section}-dark">`;
        
        // Dark pagination
        const darkPages = Math.ceil(data.dark.length / data.maxPerPage);
        if (darkPages > 1) {
          html += '<div class="pager">';
          for (let i = 1; i <= darkPages; i++) {
            const selectedClass = i === 1 ? ' selected' : '';
            html += `<button class="btn pager-btn${selectedClass}" onclick="loadPage('${section}', 'dark', ${i})">${i}</button>`;
          }
          html += '</div>';
        }
        
        html += `<div id="${section}-dark-content">`;
        html += generateImageGrid(data.dark.slice(0, data.maxPerPage));
        html += '</div>';
        html += '</div>';
      }
      
      // Light content
      if (data.hasLight && data.light.length > 0) {
        html += `<div class="subsection-content" id="${section}-light">`;
        
        // Light pagination
        const lightPages = Math.ceil(data.light.length / data.maxPerPage);
        if (lightPages > 1) {
          html += '<div class="pager">';
          for (let i = 1; i <= lightPages; i++) {
            const selectedClass = i === 1 ? ' selected' : '';
            html += `<button class="btn pager-btn${selectedClass}" onclick="loadPage('${section}', 'light', ${i})">${i}</button>`;
          }
          html += '</div>';
        }
        
        html += `<div id="${section}-light-content">`;
        html += generateImageGrid(data.light.slice(0, data.maxPerPage));
        html += '</div>';
        html += '</div>';
      }
      
      contentDiv.innerHTML = html;
      sectionStates[section].loaded = true;
    }

    function generateImageGrid(images) {
      let html = '<div class="c">';
      images.forEach(img => {
        html += `<a target="_blank" href="${img.src}">
          <img loading="lazy" src="${img.thumb}" alt="${img.alt}" width="200">
        </a>`;
      });
      html += '</div>';
      return html;
    }

    function switchSectionTheme(section, theme) {
      const darkBtn = document.getElementById(section + '-dark-btn');
      const lightBtn = document.getElementById(section + '-light-btn');
      const darkContent = document.getElementById(section + '-dark');
      const lightContent = document.getElementById(section + '-light');
      
      initSectionState(section);
      sectionStates[section].currentTheme = theme;
      
      // Update button states
      if (darkBtn && lightBtn) {
        darkBtn.classList.toggle('active', theme === 'dark');
        lightBtn.classList.toggle('active', theme === 'light');
      }
      
      // Switch content visibility
      if (darkContent && lightContent) {
        darkContent.classList.toggle('active', theme === 'dark');
        lightContent.classList.toggle('active', theme === 'light');
      }
      
      // Load first page of selected theme
      loadPage(section, theme, 1);
    }

    function loadPage(section, theme, page) {
      const data = window.sectionData[section];
      const images = data[theme];
      const startIdx = (page - 1) * data.maxPerPage;
      const endIdx = Math.min(startIdx + data.maxPerPage, images.length);
      const pageImages = images.slice(startIdx, endIdx);
      
      const contentDiv = document.getElementById(`${section}-${theme}-content`);
      if (contentDiv) {
        contentDiv.innerHTML = generateImageGrid(pageImages);
      }
      
      // Update pagination buttons
      const pagerButtons = document.getElementById(`${section}-${theme}`)?.getElementsByClassName('pager-btn');
      if (pagerButtons) {
        for (let i = 0; i < pagerButtons.length; i++) {
          pagerButtons[i].classList.toggle('selected', i === page - 1);
        }
      }
      
      initSectionState(section);
      sectionStates[section].currentPages[theme] = page;
    }

    // Main theme functions
    const HIDDEN_CLASS = 'hidden';

    function hideThemeSwitcher(currentTheme) {
      if (currentTheme === 'dark') {
        document.getElementById('dark-icon')?.classList.add(HIDDEN_CLASS);
        document.getElementById('light-icon')?.classList.remove(HIDDEN_CLASS);
      } else {
        document.getElementById('light-icon')?.classList.add(HIDDEN_CLASS);
        document.getElementById('dark-icon')?.classList.remove(HIDDEN_CLASS);
      }
    }

    function setMainTheme(newTheme) {
      document.documentElement.style.setProperty('color-scheme', newTheme);
      hideThemeSwitcher(newTheme);
    }

    function switchMainTheme() {
      const current = document.documentElement.style.getPropertyValue('color-scheme');
      setMainTheme(current === 'dark' ? 'light' : 'dark');
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
EOF

echo "      activeSection('${sections[0]}');" >> index.html

cat >> index.html << 'EOF'
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        setMainTheme('dark');
      } else {
        setMainTheme('light');
      }
    });
  </script>
</body>
</html>
EOF

echo "Build complete! Generated $(echo ${#sections[@]}) sections with dynamic content loading."
echo "Sections with light variants: ${sections_with_light[*]}"
