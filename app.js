function loadPage(section, page) {
    let buttons = document.getElementById(section).getElementsByTagName("button");
    let currSel;
    for (let i in buttons) {
        if (buttons[i].classList?.contains("selected")) {
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
                currSel.classList.remove("selected");
            }
            document.getElementById(section).getElementsByTagName("button")[page - 1].classList.add("selected");
        });
}

function activeSection(section) {
    hideAll();

    const targetSection = document.getElementById(section);
    targetSection.focus();
    targetSection.classList.add("selected");
    setTimeout(() => {
        targetSection.scrollIntoView({ block: "start", behavior: "smooth" });
    }, 100);
}

function hideAll() {
    document.querySelectorAll(".section").forEach((s) => {
        s.classList.remove("selected");
        // s.style.display = "none";
    });
}
const HIDDEN_CLASS = "hidden";

function hideThemeSwitcher(currentTheme) {
    if (currentTheme == "dark") {
        document.getElementById("dark-icon")?.classList.add(HIDDEN_CLASS);
        document.getElementById("light-icon")?.classList.remove(HIDDEN_CLASS);
    } else {
        document.getElementById("light-icon")?.classList.add(HIDDEN_CLASS);
        document.getElementById("dark-icon")?.classList.remove(HIDDEN_CLASS);
    }
}
function getCurrentTheme() {
    const fromProperty = document.documentElement.style.getPropertyValue("color-scheme");
    if (fromProperty) return fromProperty;
    const prefersTheme = window.matchMedia("(prefers-color-scheme: dark)") ? "dark" : "light";
    return prefersTheme;
}

function setTheme(newTheme) {
    document.documentElement.style.setProperty("color-scheme", newTheme);
    hideThemeSwitcher(newTheme);
}

function switchTheme() {
    let currentTheme = getCurrentTheme();
    console.debug("Start theme switching to " + currentTheme + " theme");
    setTheme(currentTheme == "dark" ? "light" : "dark");
}

function initColorTheme() {
    const currentTheme = getCurrentTheme();
    console.debug("Current theme is " + currentTheme + "");
    setTheme(currentTheme);
}
