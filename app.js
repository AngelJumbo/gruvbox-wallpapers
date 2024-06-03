function loadPage(section, page) {
    let buttons = document.getElementById(section).getElementsByTagName("button");
    let currSel;
    for (let i in buttons) {
        if (buttons[i].classList?.contains("sel-btn")) {
            if (page - 1 == i) return;
            else {
                currSel = buttons[i];
                break;
            }
        }
    }

    fetch(section + "_page" + page + ".html")
        .then((response) => response.text())
        .then((data) => {
            document.getElementById(section + "-content").innerHTML = data;
            if (currSel) {
                currSel.classList.remove("sel-btn");
            }
            document.getElementById(section).getElementsByTagName("button")[page - 1].classList.add("sel-btn");
        });
}

function activeSection(section) {
    hideAll();

    const targetSection = document.getElementById(section);
    targetSection.style.display = "block";
    setTimeout(()=>{
    targetSection.scrollIntoView({ block: "start", behavior: "smooth" });
    },100)
}

function hideAll() {
    document.querySelectorAll(".section").forEach((s) => {
        s.style.display = "none";
    });
}


function switchTheme(){
    let currTheme = document.documentElement.style.getPropertyValue('color-scheme');
    console.log(currTheme);
    if (currTheme == "dark") {
        document.getElementsByClassName("fa-sun")[0].style.display = "none";
        document.getElementsByClassName("fa-moon")[0].style.display = "block";
        document.documentElement.style.setProperty('color-scheme', 'light');
    } else {
        document.getElementsByClassName("fa-moon")[0].style.display = "none";
        document.getElementsByClassName("fa-sun")[0].style.display = "block";
        document.documentElement.style.setProperty('color-scheme', 'dark');
    }
}