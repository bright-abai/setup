Create a policies file at /etc/firefox/policies/policies.json:
```
{
  "policies": {
    "Homepage": {
      "URL": "https://www.example.com",
      "Locked": true,
      "StartPage": "homepage"
    },
    "ManagedBookmarks": [
      {
        "toplevel_name": "Pinned Sites"
      },
      {
        "name": "Example Site 1",
        "url": "https://www.example1.com"
      },
      {
        "name": "Example Site 2",
        "url": "https://www.example2.com"
      }
    ],
    "WebsiteFilter": {
      "Block": ["<all_urls>"],
      "Exceptions": [
        "https://allowed-site1.com/*",
        "https://allowed-site2.com/*",
        "https://*.google.com/*",
        "https://*.wikipedia.org/*"
      ]
    },
    "Preferences": {
      "browser.startup.page": {
        "Value": 1,
        "Status": "locked"
      }
    }
  }
}
```

```
"Homepage": {
  "URL": "https://site1.com|https://site2.com|https://site3.com",
  "Locked": true,
  "StartPage": "homepage"
}
```

```
{
  "policies": {
    "Homepage": {
      "URL": "https://www.google.com",
      "Locked": true,
      "StartPage": "homepage"
    },
    "WebsiteFilter": {
      "Block": ["<all_urls>"],
      "Exceptions": [
        "https://*.google.com/*",
        "https://*.wikipedia.org/*",
        "https://*.github.com/*",
        "https://stackoverflow.com/*",
        "https://allowed-educational-site.com/*"
      ]
    },
    "Bookmarks": [
      {
        "Title": "Google",
        "URL": "https://www.google.com",
        "Placement": "toolbar"
      },
      {
        "Title": "Wikipedia",
        "URL": "https://www.wikipedia.org",
        "Placement": "toolbar"
      }
    ],
    "DisablePrivateBrowsing": true,
    "NoDefaultBookmarks": true,
    "DontCheckDefaultBrowser": true
  }
}
```
