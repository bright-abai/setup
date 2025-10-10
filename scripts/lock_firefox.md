# How to whitelist sites

Create a file `policies.json` in `/etc/firefox/policies`, it will be read by firefox each time it starts. 
If on Win10, the path is "C:\Program Files\Mozilla Firefox\distribution"

To remove restrictions, rename file to 'policies_backup' using `sudo mv policies.json policies_backup`

The contents of `policies.json`:

```
{
  "policies": {
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    "Homepage": {
      "URL": "about:newtab",
      "Locked": true,
      "StartPage": "homepage"
    },
    "ExtensionSettings": {
      "*": {
        "installation_mode": "blocked"
      }
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
            "url": "https://www.edclub.com/sportal/program-3.game"
          },
          {
            "name": "Онлайн пазлы",
            "url": "https://pazlyonline.com"
          },
          {
            "name": "Шахматы",
            "url": "https://www.247chess.com"
          }
        ]
      },
      {
        "name": "Старшая",
        "children": [
          {
            "name": "Search & Reference",
            "children": [
              {
                "name": "Wikipedia",
                "url": "https://www.wikipedia.org"
              },
              {
                "name": "Reddit",
                "url": "https://www.reddit.com"
              }
            ]
          },
          {
            "name": "Computer Science Theory",
            "children": [
              {
                "name": "How does Internet work?",
                "url": "https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/How_does_the_Internet_work"
              },
              {
                "name": "Your first website",
                "url": "https://developer.mozilla.org/en-US/docs/Learn_web_development/Getting_started/Your_first_website"
              },
              {
                "name": "C++ Reference",
                "url": "https://www.cplusplus.com"
              },
              {
                "name": "GeeksforGeeks",
                "url": "https://www.geeksforgeeks.org"
              },
              {
                "name": "Blender 3D Docs",
                "url": "https://docs.blender.org/manual/en/latest/"
              },
              {
                "name": "Godot Engine Docs",
                "url": "https://godotengine.org"
              },
              {
                "name": "Renpy Visual Novel Engine",
                "url": "https://renpy.org/doc/html/quickstart.html"
              },
              {
                "name": "Python Lower Secondary",
                "url": "https://pyflo.net/"
              },
              {
                "name": "Java JetBrains Course",
                "url": "https://hyperskill.org/courses/17-java-developer"
              }
            ]
          },
          {
            "name": "Coding Practice & Version Control",
            "children": [
              {
                "name": "OnlineGDB Compiler",
                "url": "https://www.onlinegdb.com"
              },
              {
                "name": "Online Python IDE",
                "url": "https://www.online-python.com"
              },
              {
                "name": "Beecrowd (URI) Problems",
                "url": "https://www.beecrowd.com"
              },
              {
                "name": "Codeforces Competitions",
                "url": "https://codeforces.com"
              },
              {
                "name": "Shadertoy: Shader Programming",
                "url": "https://www.shadertoy.com"
              },
              {
                "name": "GitHub",
                "url": "https://github.com"
              }
            ]
          },
          {
            "name": "AI Tools",
            "children": [
              {
                "name": "Claude AI",
                "url": "https://claude.ai"
              }
            ]
          },
          {
            "name": "Creative Resources",
            "children": [
              {
                "name": "Images",
                "children": [
                  {
                    "name": "Freepik",
                    "url": "https://www.freepik.com"
                  },
                  {
                    "name": "Pexels",
                    "url": "https://www.pexels.com"
                  },
                  {
                    "name": "Unsplash",
                    "url": "https://unsplash.com"
                  },
                  {
                    "name": "Pixabay",
                    "url": "https://pixabay.com"
                  },
                  {
                    "name": "Flickr",
                    "url": "https://www.flickr.com"
                  }
                ]
              },
              {
                "name": "Audio",
                "children": [
                  {
                    "name": "Freesound",
                    "url": "https://freesound.org"
                  },
                  {
                    "name": "SoundCloud",
                    "url": "https://soundcloud.com"
                  },
                  {
                    "name": "Zapsplat",
                    "url": "https://www.zapsplat.com"
                  },
                  {
                    "name": "Bensound",
                    "url": "https://www.bensound.com"
                  }
                ]
              },
              {
                "name": "3D Models",
                "children": [
                  {
                    "name": "Mixamo Characters",
                    "url": "https://www.mixamo.com"
                  },
                  {
                    "name": "TurboSquid",
                    "url": "https://www.turbosquid.com"
                  },
                  {
                    "name": "Sketchfab",
                    "url": "https://sketchfab.com"
                  }
                ]
              },
              {
                "name": "Design Tools",
                "children": [
                  {
                    "name": "Canva",
                    "url": "https://www.canva.com"
                  },
                  {
                    "name": "Figma",
                    "url": "https://www.figma.com"
                  }
                ]
              }
            ]
          },
          {
            "name": "Utilities & Tools",
            "children": [
              {
                "name": "FreeConvert",
                "url": "https://www.freeconvert.com"
              },
              {
                "name": "ShortURL",
                "url": "https://shorturl.at"
              },
              {
                "name": "WordPress",
                "url": "https://wordpress.com"
              }
            ]
          }
        ]
      }
    ],
    "WebsiteFilter": {
      "Block": ["<all_urls>"],
      "Exceptions": [
        "*://bright.edupage.org/*",

        "__comment_primary": "Primary Education",
        "*://*.igraemsa.ru/*",
        "*://*.edclub.com/*",
        "*://pazlyonline.com/*",
        "*://*.247chess.com/*",

        "__comment_search": "Search & Reference",
        "*://*.wikipedia.org/*",
        "*://*.reddit.com/*",

        "__comment_cs_theory": "Computer Science Theory & Documentation",
        "*://developer.mozilla.org/*",
        "*://*.w3schools.com/*",
        "*://*.stackoverflow.com/*",
        "*://*.stackexchange.com/*",
        "*://*.superuser.com/*",
        "*://*.cplusplus.com/*",
        "*://*.geeksforgeeks.org/*",
        "*://docs.blender.org/*",
        "*://godotengine.org/*",
        "*://*.godotengine.org/*",
        "*://renpy.org/*",
        "*://*.renpy.org/*",
        "*://pyflo.net/*",
        "*://*.pyflo.net/*",
        "*://hyperskill.org/*",
        "*://*.hyperskill.org/*",

        "__comment_coding": "Coding Practice & Version Control",
        "*://onlinegdb.com/*",
        "*://*.onlinegdb.com/*",
        "*://*.online-python.com/*",
        "*://beecrowd.com/*",
        "*://*.beecrowd.com/*",
        "*://codeforces.com/*",
        "*://*.codeforces.com/*",
        "*://*.shadertoy.com/*",
        "*://github.com/*",
        "*://*.github.com/*",

        "__comment_ai": "AI Tools",
        "*://claude.ai/*",
        "*://*.claude.ai/*",
        "*://anthropic.com/*",
        "*://*.anthropic.com/*",

        "__comment_creative": "Creative Resources & Design",
        "*://*.freepik.com/*",
        "*://*.pexels.com/*",
        "*://*.unsplash.com/*",
        "*://*.pixabay.com/*",
        "*://*.flickr.com/*",
        "*://*.canva.com/*",
        "*://*.figma.com/*",
        "*://*.freesound.org/*",
        "*://*.soundcloud.com/*",
        "*://*.zapsplat.com/*",
        "*://*.bensound.com/*",
        "*://mixamo.com/*",
        "*://*.mixamo.com/*",
        "*://*.turbosquid.com/*",
        "*://*.sketchfab.com/*",

        "__comment_utilities": "Utilities & Tools",
        "*://*.freeconvert.com/*",
        "*://shorturl.at/*",
        "*://*.wordpress.com/*",

        "__comment_google": "Google Services",
        "*://gmail.com/*",
        "*://*.gmail.com/*",
        "*://mail.google.com/*",
        "*://accounts.google.com/*",
        "*://*.google.com/*",
        "*://workspace.google.com/*",
        "*://drive.google.com/*",
        "*://docs.google.com/*"
      ]
    }
  }
}
```
