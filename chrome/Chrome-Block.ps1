$base = "HKLM:\SOFTWARE\Policies\Google\Chrome"

# Clear existing policies to avoid conflicts
foreach ($key in "URLBlocklist", "URLAllowlist") {
    Remove-Item -Path "$base\$key" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path "$base\$key" -Force | Out-Null
}

# Block everything
Set-ItemProperty -Path "$base\URLBlocklist" -Name "1" -Value "*" -Type String

# Allowed domains (an entry also covers all its subdomains)
$allowedUrls = @(
    "typerun.top",
    "10fastfingers.com",
    "scratch.mit.edu",
    "chromeexperiments.com",
    "onecompiler.com",
    "pseudoeditor.com",
    "codeforces.com",
    "shadertoy.com",
    "drawsql.app",
    "wikipedia.org",
    "developer.mozilla.org",
    "w3schools.com",
    "pyflo.net",
    "bright.edupage.org",
    "gmail.com",
    "google.com",
    "github.com",
    "github.io",
    "freepik.com",
    "pexels.com",
    "unsplash.com",
    "pixabay.com",
    "photopea.com",
    "canva.com",
    "figma.com",
    "cubic-bezier.com",
    "mixamo.com",
    "turbosquid.com",
    "sketchfab.com",
    "typingstudy.com",
    "learningapps.org",
    "wordwall.net",
    "blockly.games",
    "studio.code.org",
    "baamboozle.com",
    "biliquest.web.app"
)

$i = 1
foreach ($url in $allowedUrls) {
    Set-ItemProperty -Path "$base\URLAllowlist" -Name "$i" -Value $url -Type String
    $i++
}

Write-Host "Blocked all URLs, allowed $($allowedUrls.Count) entries." -ForegroundColor Green