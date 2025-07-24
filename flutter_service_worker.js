'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "5fcaa14207364e52875f17c367a65c2e",
"index.html": "3382bf0f9c6674f7c692b67a37af61be",
"/": "3382bf0f9c6674f7c692b67a37af61be",
"main.dart.js": "fb2e468bf2672e2edb3ebaec84e54520",
"favicon.png": "bcfb03ab4e915269535c7dd4d1f3bc6a",
"icons/Icon-192.png": "db4ecd109e74f421d0f5da1ac682bf25",
"icons/Icon-512.png": "e5b449d53df57cd28a44bb609347ea74",
"manifest.json": "429d5b80af5efc263b29fbd39e6c6d0c",
".git/config": "e22c6613111d8605f607c769701c621e",
".git/objects/95/808cfe59dc3863e013f2f41d8ff050e1ab2b79": "42a9e18c47ea5dc87779238ef4bab3a1",
".git/objects/95/20cc3adfcfece7a77712cdcb8ff55185ea032b": "fc8dbd05a8d1474b88ba9f5b12762710",
".git/objects/66/a29fc51a8460deb05e683b1fa5818e9ec89a2d": "94ff407d6db9c469965074b958cedeb6",
".git/objects/66/286674500a6ddcf2e9293d610a708a7e08a260": "0e1b5f901fcec47eea80b43bdee74852",
".git/objects/35/781c0b7bb87671bedf8de5f4c532e771d5f071": "68fdff750256c440a0a00069b4d68da4",
".git/objects/67/dd8481d0f61d57d6a0cb2bd2bd166f55c32f82": "8b51ba346fb99d9d4fcff4e7efea492e",
".git/objects/67/f9d04c6986d08f564e33a9ca5d60f2f6e506cf": "656102cc3c3f05faf10de435ae9ebb72",
".git/objects/93/400361f102b2c5b461201b4aa35507e9aa0104": "9997d88ca4ca94915196d7fa0b9327d2",
".git/objects/0e/6c79c1351fcb1d475c391f44f547129d907921": "06d2a888cf7fa28ecdbd567451c1050e",
".git/objects/a4/0d28e87395c4e2ded1c11f63928625a4ce6741": "84bde44cfbf737e9a9c0bc7f5b32cbc4",
".git/objects/a2/eb89a1ae91bd03be1475706ba246f62a17f210": "bab380d467672562bbcf3c95f50ffe43",
".git/objects/bd/547599255a14e1ad33eafa313bd85131302a7b": "d269f187005cd3eb9212820809a37ee7",
".git/objects/d6/176b2f8f5160d877777b9526d5fe6d0af7e518": "057c45f332eb0259e8abdde184ae9a60",
".git/objects/f3/1813d8412c7a04645fb05d90def483072b7281": "2778ab2adb0fa52fafdca95e0adccd55",
".git/objects/ee/1239293702eb8a470cb9c01ec7b6c829a9318d": "a7350f42983a8b56a029bdd01e8cdb8a",
".git/objects/ee/f6704ba69553fb69543e44a4e33db44203cc79": "fb8c1672b89fb9210067453e8aa4045c",
".git/objects/cf/bed8fcb80a880ca5de6f9f98306fadfb4cee10": "cfdfc71fde4f1d645b35a18fb612e570",
".git/objects/e4/1e524df9c594e81e2e0ea526f2cef24a4439ff": "c38d8acd4f04cf5d4b221caa88ee65f2",
".git/objects/e4/39f3b663cb65afcc40540f99e1255b7f9aca23": "e9c108412668051ec1167565d7065dcc",
".git/objects/fb/48dd184858203d12a45fe66abaa10b8af2a50f": "0ee1392a97da15b6aafadb356742d6eb",
".git/objects/ec/cc36ad8c478136f372a9c98ad67efa741f083e": "8fd92cfe7667edff987b4a7b0381dba8",
".git/objects/20/19cec54acfe007170087baa5a1a0965431f19f": "36675be610b0b45c1f68bc96bb14be14",
".git/objects/16/2b7b69ee2ea4a2bbc84127707c2756373ff4c5": "3e56269a80a47d779ea3393135dd3757",
".git/objects/89/c7479c71b624f846bd360613c690dff4936ae6": "926d85addc8e237393352b97488ec707",
".git/objects/45/5bd4547f253772abc0f7696921aa0ee1d3729b": "ed17b7d1866e91b6d91954582cdef5f1",
".git/objects/1f/9f43939c019dbd323f68f64e730b7b7d653535": "3f8366bb545f37fb04fb33d7961f6993",
".git/objects/73/345af51c41457c56e0ba3507e676cada1db17d": "78f08e17123286460a7cf7d0cc30df65",
".git/objects/26/d33521af10bcc7fd8cea344038eaaeb78d0ef5": "39554bb11371007e021a7fb3361ecd47",
".git/objects/26/09b48da018a9b1ba645b50b412a2ea43534e26": "5c7bc8fc4a83c1d4e108444f9c3a27bd",
".git/objects/21/f7d708910c2cbf528e28ecd4c06467f843f143": "644761b91478c6fa04c68948286c90ef",
".git/objects/9f/293e40777a142ad86e5c085b64f4b1b8aeeb30": "c6771b27d5701e648f66063e7e9693a1",
".git/objects/5c/2f30c9cb446423af285b128deb215f15e203de": "4aa542543bb7a7fbfd6eeab1d3c945cb",
".git/objects/09/aa51dba9d53d09f9365c8661593737a5cac02a": "c266c6f2740e08ced702450d9a6a2d8e",
".git/objects/5d/eee65f43a08a132e29565dc458c71e2c3f9fad": "0582e0e30645e062034840d0fe57e64f",
".git/objects/96/c40044232aa522ca4532aa796d70aad521059f": "1d985d93dcaa7994447ad51362d9b70b",
".git/objects/96/7ef314837b5dd584c4414e13ed999dda9290fb": "39b0fb7c18afd5dfcc8a0eddb60408ef",
".git/objects/54/a5592fa33a458a1c267bda4f3719d8953d34d2": "0a12f97fe095cc50bfd7b3e6df3cdeb8",
".git/objects/53/b4d7f097ce976691d9d97be9222d9a54bcc072": "b118c585ba92c28f387246bfa9ae9097",
".git/objects/5e/23dd9c6cb51e77f99d8d42340303bef426de75": "64bf75bd711c08778b8679f2d95e4d92",
".git/objects/01/b3fb8466d43e882a9e3823ca2d7150fd364339": "8ae810a78239c6a94d6e9a2387828774",
".git/objects/52/480a63b1f184ea74afb06662aa98fa98864864": "6f8b2cf71be2b4830601f9db57eded45",
".git/objects/52/4ac80279697870930a30a37fee312e0903f329": "5b88d27bb82f6957a5f683a8820373bb",
".git/objects/55/3ba4c4c5a9f10345ac198d464305a2bdb55b08": "1cb9c6182ae01b502189af1a3d9fdeb1",
".git/objects/64/13cb06224fb57f9b0fa4e288a185afa025f011": "298f8914e3b83837813eae5637827f43",
".git/objects/bf/5b1ad9b8b4c9b523d0d8e1c8c6b26893dff73b": "05962bebcab29180bab7a528539ed13d",
".git/objects/d4/f920603fb44253c895d4771ff751f5e7e008e1": "1b7e9b0065012c7c510e584e46b4e88e",
".git/objects/a7/6eb952d743fc967fc2f8375d95a007787918bc": "5c638f4b7baf4c2d4a9ad5abd650610f",
".git/objects/aa/1bc7a1d0a230292c2030732df3c75568033680": "e51bd6a758538e2b7969d697f2a641ea",
".git/objects/a8/647315e7530e7aed5b716853016d5421b45b94": "b6c441f885e637f17264793ae83f70b4",
".git/objects/c3/a3d3d3283e2313751080267db96ab2f65e7d0a": "473c5069b097732ecb8993aa4ae46815",
".git/objects/f0/4eb308266c210f6f9bd21c4ae5b833d709d9e9": "60ff1c9c7fc5c07ea002e993461127c2",
".git/objects/f0/365700d34f6f2776e33ffbfad0666a491f6414": "6d712ef260b7d42db5a67b183cee3fa6",
".git/objects/cb/68235b5611f8bb22914773693a55ddb7743546": "d9556638d055ffcf7357bb0275cc8bec",
".git/objects/46/05bcc1bc17e54a97e6530d171be9895db84d28": "f2349de3ec98e3da5e9e08a36d714844",
".git/objects/79/6f757f8232ae24fc75b32bd7972f1b0da7f233": "8025add9e687534ea7dfeada87836283",
".git/objects/12/0056b0f9f760f9e1014a1695a5d9aa192c379b": "1a6197a10ae828a2bc15d954e37ae02a",
".git/objects/85/61761b046791d8d7e2ca6eafdec5855ce8ea5e": "1356ace29015b0f77eb47a648c8a0268",
".git/objects/14/5515e57705947054d581bd172e8883d689f86e": "8c0dccda946e5f4246e5b809e8d93453",
".git/HEAD": "7fcb528cf35040c3e882ba68ac871ed0",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "050d1ff1d3e2155dc65541f1dcae7b31",
".git/logs/refs/heads/gh-test": "050d1ff1d3e2155dc65541f1dcae7b31",
".git/logs/refs/remotes/origin/gh-test": "26a8af0dd091ccf799b41fc7df9b1292",
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
".git/refs/heads/gh-test": "fbbed90a35d7964331467246ff11f4c4",
".git/refs/remotes/origin/gh-test": "fbbed90a35d7964331467246ff11f4c4",
".git/index": "79dfa9e488f7836481f15e0de8b47012",
".git/COMMIT_EDITMSG": "ab45692266285b0e96c6e0972220f445",
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
"assets/assets/icons/dice_1.svg": "02ea14ea7530445f9d8e4c8d7c2b1e6a",
"assets/assets/icons/selfChallenge.svg": "5ca5fc296e3c0a67c61d66d309a96a0c",
"assets/assets/icons/dice_3.svg": "55b8eab2e6acb3bf44560074ac52a9cd",
"assets/assets/icons/beer.svg": "84f3e1c4f06d617d5c3849f14d3309f5",
"assets/assets/icons/dice_2.svg": "75553178977eb4603984be94f9522ddd",
"assets/assets/icons/dice_6.svg": "34608a07fc00a3863427e1b4d1a51169",
"assets/assets/icons/dice_5.svg": "758cefec772252b166c4c74be4100e71",
"assets/assets/icons/dice_4.svg": "cc162dcb8d913f7f725b1b189715c899",
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
".idea/vcs.xml": "8c9c0403ab0f6457841c605f08a3340c",
".idea/workspace.xml": "47b8e116677fe915317cd414884a93d9",
".idea/modules.xml": "1eb3b065c55895e347308e50cd717dee",
".idea/web.iml": "52db5efd0fe9f576a1302b8c4b5eac6c",
".idea/misc.xml": "f460225ee7b0da88b858fdafab5eca69"
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
