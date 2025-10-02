# How to whitelist sites

Create a file `policies.json` in `/etc/firefox/policies`, it will be read by firefox each time it starts. 

To remove restrictions, rename file to 'policies_backup' using `sudo mv policies.json policies_backup`

The contents of `policies.json`:

```
{
    "policies": {
    "Homepage": {
      "URL": "https://wikipedia.org",
      "Locked": true,
      "StartPage": "homepage"
    },
    "ManagedBookmarks": [
      {
        "toplevel_name": "Bright International School"
      },
      {
        "name": "Началка",
        "children": [
        {
                "name": "Умные игры",
                "url": "https://igraemsa.ru"
        },
        {
                "name": "Печатание",
                "url": "https://edclub.com/sportal/program-3.game"
        },
        {
                "name": "Онлайн пазлы",
                "url": "https://pazlyonline.com"
        },
        {
                "name": "Шахматы",
                "url": "https://247chess.com"
        }
        ]
      },
      {
        "name": "Старшая",
        "children": [

        {
                "name": "Wikipedia",
                "url": "https://wikipedia.org"
        },
        {
                "name": "Github version control",
                "url": "https://github.com"
        },
        {
                "name": "Blender 3D modelling docs",
                "url": "https://docs.blender.org/manual/en/latest/"
        },
        {
                "name": "How does Internet work?",
                "url": "https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/How_does_the_Internet_work"
        },
        {
                "name": "Your first website",
                "url": "https://developer.mozilla.org/en-US/docs/Learn_web_development/Getting_started/Your_first_website"
        },
        {
                "name": "Python Lower Secondary",
                "url": "https://pyflo.net/"
        },
        {
                "name": "Java JetBrains course",
                "url": "https://hyperskill.org/courses/17-java-developer"
        },
        {
                "name": "Canva: Visual Suite for everyone",
                "url": "https://canva.com"
        },
        {
                "name": "Renpy quickstart",
                "url": "https://renpy.org/doc/html/quickstart.html"
        },
        {
                "name": "Claude: a better alternative to ChatGPT in programming",
                "url": "https://claude.ai"
        },
        {
                "name": "Shadertoy: shader programming",
                "url": "https://shadertoy.com"
        }
        ]
      }
    ],
    "WebsiteFilter": {
      "Block": ["<all_urls>"],
      "Exceptions": [
        "*://bright.edupage.org/*",
        "*://*.gle.com/*",
        "*://*.igraemsa.ru/*",
        "*://*.edclub.com/*",
        "*://pazlyonline.com/*",
        "*://*.247chess.com/*",
        "*://*.wikipedia.org/*",
        "*://github.com/*",
        "*://docs.blender.org/*",
        "*://developer.mozilla.org/*",
        "*://w3schools.com/*",
        "*://reddit.com/*",
        "*://pyflo.net/*",
        "*://onlinegdb.com/*",
        "*://cplusplus.com/*",
        "*://geeksforgeeks.org/*",
        "*://gmail.com/*",
        "*://freepik.com/*",
        "*://pexels.com/*",
        "*://canva.com/*",
        "*://figma.com/*",
        "*://freesound.com/*",
        "*://freeconvert.com/*",
        "*://shorturl.at/*",
        "*://wordpress.com/*",
        "*://renpy.org/*",
        "*://godotengine.org/*",
        "*://github.com/*",
        "*://superuser.org/*",
        "*://hyperskill.org/*",
        "*://claude.ai/*",
        "*://*.shadertoy.com/*",
        "*://mixamo.com/*"
      ]
    }
    }
}
```
