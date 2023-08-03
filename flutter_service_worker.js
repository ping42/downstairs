'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "be047386d858d249a59a323402fd4bcf",
"icons/Icon-maskable-192.png": "7192c4041308844d51c6d62b72e8e4fc",
"icons/Icon-192.png": "7192c4041308844d51c6d62b72e8e4fc",
"icons/Icon-512.png": "be047386d858d249a59a323402fd4bcf",
"icons/favicon.png": "7a26ea9d4e61122fc023b84e5acdb148",
"index.html": "c714e7aa394200ad6a158e08c6c33da0",
"/": "c714e7aa394200ad6a158e08c6c33da0",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"manifest.json": "6116aa19d7aceb7ec2ad7c364c6d14fa",
"favicon.png": "170dd3e9ddd91110221033598aeae473",
"assets/fonts/MaterialIcons-Regular.otf": "cfd614e5b54cf6c91cfc446f65623896",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "ee04183c1e6eaf01e83732c9079d56e9",
"assets/assets/images/monkey_hit.png": "67e08b13ec04ee575bf053e5da07075e",
"assets/assets/images/background_05.png": "bfe98e3458033cd378297414e7711042",
"assets/assets/images/monkey_jump.png": "22801902d6814db065a729030b043ed5",
"assets/assets/images/background_03.png": "a7ac5a232a9623369a92224813a17306",
"assets/assets/images/background_02.png": "2e5e868777faffa0645d232221a45459",
"assets/assets/images/chef_jump.png": "307a0af76dbdee699c52ef99d0c9753b",
"assets/assets/images/background_01.png": "b9f3b135ad511b813dd659a9032a871b",
"assets/assets/images/background_06.png": "8deff2b1f4fa31b289f78e265f385902",
"assets/assets/images/platform_normal_short.png": "19e7fcb6811b134efffc5c6064ab1307",
"assets/assets/images/background_04.png": "5e085155446f84bfa7eae243866736d1",
"assets/assets/images/chef_run.png": "9ae18c4322c70e847e9d3309802eec90",
"assets/assets/images/platform_spikes.png": "0a80f0f2b94ba46e6390b6ac2bb92349",
"assets/assets/images/monkey_dead.png": "54fa96958ff9a9e872dce0acfdcc2066",
"assets/assets/images/monkey_run.png": "9016b1aaf5881ffcb0d6573049ee2c0c",
"assets/assets/images/platform_normal_long.png": "69ff4e2b22eab50aac009cf1a5fde953",
"assets/assets/images/chef_idle.png": "0c71a9b9530b22b15f1993c3ee46d36d",
"assets/assets/images/monkey_idle.png": "80a563f9652036c73c9217ad5b36b4b5",
"assets/assets/images/downstairs_logo.png": "fe9c99bd91607deb54de6c3a5ba68e78",
"assets/assets/audio/background.mp3": "a7c21348a70f24bd44d2fb5589308ed2",
"assets/assets/audio/effect.mp3": "b739898500e7e937437de3fe8cf8cc5c",
"assets/AssetManifest.json": "df6710dac632a3df8eddb605db86ad42",
"assets/NOTICES": "fa53b8670f50a819c9372f7b7050b7ea",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"version.json": "2dd47f343ab1269467a79bbc7f533a58",
"main.dart.js": "dfa9094efa6fc730db0f0a06926b9ddd",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
