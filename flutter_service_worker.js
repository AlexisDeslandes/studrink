'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "5fcaa14207364e52875f17c367a65c2e",
"index.html": "0a8ddf2db0af76b3d4917c1100689d9d",
"/": "0a8ddf2db0af76b3d4917c1100689d9d",
"main.dart.js": "fb2e468bf2672e2edb3ebaec84e54520",
"favicon.png": "bcfb03ab4e915269535c7dd4d1f3bc6a",
"icons/Icon-192.png": "db4ecd109e74f421d0f5da1ac682bf25",
"icons/Icon-512.png": "e5b449d53df57cd28a44bb609347ea74",
"manifest.json": "429d5b80af5efc263b29fbd39e6c6d0c",
"assets/AssetManifest.json": "a0b3773b5ad1c94d6874b747800ae869",
"assets/NOTICES": "7696d45715b3b1bf14449e7847375786",
"assets/FontManifest.json": "cf3c681641169319e61b61bd0277378f",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "e9f2f143310604845f8aa26c42ad5f55",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/assets/screenshots/screen4.png": "ac63022285aecf1f4ebc87a2f7d4141b",
"assets/assets/screenshots/screen1.png": "261997b23c66fc4905562674c14f8e4a",
"assets/assets/screenshots/screen2.png": "3aed046dc46f3c1ab9f3c0411a2e84e3",
"assets/assets/screenshots/screen3.png": "d07d1df2f94e7b7f1d7af9baad815d85",
"assets/assets/icons/steal.svg": "cabb6beab6be818557af3ad6ed724a08",
"assets/assets/icons/dice_1.svg": "f654b58b803a2199e55971473818996d",
"assets/assets/icons/selfChallenge.svg": "5ca5fc296e3c0a67c61d66d309a96a0c",
"assets/assets/icons/dice_3.svg": "b9fef9c379645703d271831490d72c0b",
"assets/assets/icons/beer.svg": "84f3e1c4f06d617d5c3849f14d3309f5",
"assets/assets/icons/dice_2.svg": "fef31c3d2f2fb78ba432a35741e813cd",
"assets/assets/icons/dice_6.svg": "71fc08c6da3ce54178068487141b6450",
"assets/assets/icons/dice_5.svg": "096da89952062540e0c38e8513806e82",
"assets/assets/icons/dice_4.svg": "0e883b109c88b90d856cc55cba0b2769",
"assets/assets/icons/noEffect.svg": "a0bb02fb2827484b547a9576529d3bba",
"assets/assets/icons/turnLose.svg": "0f6e5686908b989bea5f3aa99e7b9931",
"assets/assets/icons/jail.svg": "a18101b20d5510a9490674b135b61e1b",
"assets/assets/icons/battle.svg": "6a182e639e7339e297d07f21ff1770cb",
"assets/assets/icons/selfMoving.svg": "ec5734e6d1703fda94e20b89dedf4ce3",
"assets/assets/icons/conditionKey.svg": "40070651533a8b0256e9c5821e124377",
"assets/assets/icons/finish.svg": "e32321e1df2904c75500f3875277f331",
"assets/assets/icons/selfMovingPlayerChose.svg": "0c01635362d68e9d41699f33d61fad41",
"assets/assets/icons/maskey.svg": "51b3353000568321e477157438bf0639",
"assets/assets/icons/selfThrowDice.svg": "a35a059a19aed21e0a1032946c4c3873",
"assets/assets/icons/otherMoving.svg": "e04f80cd134206756ac1dd5e6f48a32a",
"assets/assets/icons/goose.svg": "34ca0392320f3ff0e16fd309fb2ae8fd",
"assets/assets/icons/ifElse.svg": "0c01635362d68e9d41699f33d61fad41",
"assets/assets/games/games.json": "484b209a71283e8517f68a2e755df697"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
