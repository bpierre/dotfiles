// Important: keep the semicolons or a parsing
// error will prevent the file to be executed.

// Disable wake lock to prevent crashes (mWakeLockType assert in Nightly 151)
user_pref("dom.wakelock.enabled", false);

// const remoteDebug = false;
user_pref("devtools.chrome.enabled", false);
user_pref("devtools.debugger.remote-enabled", false);
user_pref("devtools.debugger.prompt-connection", true);

user_pref("layout.css.devPixelsPerPx", "2"); // 2x scaling
user_pref("browser.fixup.alternate.enabled", false); // don't fixup URLs
user_pref("ui.key.menuAccessKeyFocuses", false); // don't focus the menu bar with alt
user_pref("devtools.theme", "dark"); // devtools dark theme
user_pref("layout.word_select.stop_at_punctuation", true); // select words only
user_pref("full-screen-api.warning.timeout", 0); // disable full-screen warning

user_pref("browser.tabs.notes.enabled", false); // disable tab notes

// Scroll
user_pref("mousewheel.min_line_scroll_amount", 40); // scroll amount
user_pref("general.smoothScroll", false); // disable smooth scroll
user_pref("general.smoothScroll.pages", false); // disable smooth scroll for pages

// Hide the title bar
user_pref("browser.tabs.drawInTitlebar", false);

// Other tabs settings
user_pref("browser.tabs.tooltipsShowPidAndActiveness", false); // don't show pid
user_pref("browser.tabs.hoverPreview.showThumbnails", false); // don't show thumbnails

// about:config warning
user_pref("browser.aboutConfig.showWarning", false);

// Compact UI
user_pref("browser.uidensity", 1);

// Disable opened tabs warning on close
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.warnOnQuit", false);

user_pref("browser.ml.linkPreview.enabled", false);

// Other URL bar things
user_pref("browser.urlbar.clickSelectsAll", true);
user_pref("browser.urlbar.doubleClickSelectsAll", false);
user_pref("browser.urlbar.suggest.quickactions", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.trimURLs", false);

user_pref("view_source.wrap_long_lines", true);

// Enable userChrome.css
// user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// VA-API hardware video acceleration
user_pref("media.ffmpeg.vaapi.enabled", true);

// Attempt to fix crashes by not force-enabling HW decoding (vaapi should be enough)
// user_pref("media.hardware-video-decoding.force-enabled", false);

user_pref("widget.wayland.opaque-region.enabled", false);
