'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "flutter_bootstrap.js": "5bb2f2e1ab040dea0c466a6bda1b7c11",
"version.json": "5fcaa14207364e52875f17c367a65c2e",
"index.html": "59f7b5315d8667e9e9fb5a264c2508d4",
"/": "59f7b5315d8667e9e9fb5a264c2508d4",
"main.dart.js": "fb2e468bf2672e2edb3ebaec84e54520",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "bcfb03ab4e915269535c7dd4d1f3bc6a",
"icons/Icon-192.png": "db4ecd109e74f421d0f5da1ac682bf25",
"icons/Icon-512.png": "e5b449d53df57cd28a44bb609347ea74",
"manifest.json": "429d5b80af5efc263b29fbd39e6c6d0c",
".git/config": "8c3a671a1adfb825c58c83c853a5b060",
".git/objects/0d/0df08f7c3e147a8ae36017cf81a96e35b73717": "106e868f28a72727fb6fb0fa71123633",
".git/objects/0d/f5e6670a3cc1f77c29f3239d1a10847fc6e6b9": "211bebe6ad57716334685765d75c4b8d",
".git/objects/9b/d3accc7e6a1485f4b1ddfbeeaae04e67e121d8": "784f8e1966649133f308f05f2d98214f",
".git/objects/58/31840272dc1c691085a1cda9eff0467b035365": "adfbc6c173c4e9b037c82eb43ea9b9d0",
".git/objects/fc/670d19e6e092a6aaa54a55eee38b010849b592": "db30ba7b07ab1aaa8d98491333de54a7",
".git/objects/c1/49badcd597751c055ef28f6c1a39743ee5247a": "86ce4ae74d89c58b4a8a4cbdfa817046",
".git/objects/21/4215a03b2343798e31d9cbcc9d8029380a11ad": "b0486f433d29368a047e2605d1a4d154",
".git/objects/81/2fc29e6e527d5a11916d195b90e7614c7f6379": "3d0f7a285be4e7cf45a4e4d358ae8768",
".git/objects/2f/5cc8a5666866cabe32f29ca881cb0d62bf49bd": "efc2c4346f61190dfbaa3b3cf7556de8",
".git/objects/9a/54a12e07518d774d1aec7f8994c2ac75cc147f": "62e5b19dc0e38064163a0f5de7638115",
".git/objects/5b/5e93ddf3229838516f15e746f79679a0293370": "fa5151f9150768ea3b09051e10c6481a",
".git/objects/dc/11fdb45a686de35a7f8c24f3ac5f134761b8a9": "761c08dfe3c67fe7f31a98f6e2be3c9c",
".git/objects/b6/04fe898e618cce2d39715a6b94d3451fd6514a": "c79026dbbd333d5f5156819c1bb7f3c4",
".git/objects/b9/6a5236065a6c0fb7193cb2bb2f538b2d7b4788": "4227e5e94459652d40710ef438055fe5",
".git/objects/e1/7ccb1c34e1455bf615294dc0509afa05983386": "74294090e31c4b5f6ab96a70dd123c91",
".git/objects/2d/cf3542c874e33cd8ab86ceb6f0ec444228aa78": "66baad0ae5d874f09b6eee790095bc65",
".git/objects/48/37533a8ffb636e111644446b8b5254d152a146": "54ab11d80a5332cf91fd2999264849ea",
".git/objects/70/a234a3df0f8c93b4c4742536b997bf04980585": "d95736cd43d2676a49e58b0ee61c1fb9",
".git/objects/76/8651b2e249c2517c7b37bdbeea0a5d8bfbb707": "495b1c4fefa633f6afe4dc5840ebe18f",
".git/objects/49/a0d21ace80faf876c580f9e47d7183c378b193": "9652fbde866081feeb2fd7c6142c6ef3",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "abccdd4a9907a2c48d9b6532025ee24c",
".git/logs/refs/heads/gh-pages": "abccdd4a9907a2c48d9b6532025ee24c",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/gh-pages": "e315f8686d5ebc651d7352cad3a1a6de",
".git/index": "7d3b1cf7711abfa18bef79c1460f523a",
".git/COMMIT_EDITMSG": "75f5284685a59fc95e814eb31013c6d7",
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
"assets/assets/games/games.json": "484b209a71283e8517f68a2e755df697",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c"
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
