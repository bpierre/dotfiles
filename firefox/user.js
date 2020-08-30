// Important: keep the semicolons or a parsing
// error will prevent the file to be executed.
user_pref('widget.content.gtk-theme-override', 'Adwaita');
user_pref('browser.fixup.alternate.enabled', false);
user_pref('browser.urlbar.trimURLs', false);
user_pref('general.warnOnAboutConfig', false);
user_pref('layout.css.devPixelsPerPx', '2.5');
user_pref('ui.key.menuAccessKeyFocuses', false);
user_pref('devtools.theme', 'dark');
user_pref('browser.urlbar.clickSelectsAll', true);
user_pref('browser.urlbar.doubleClickSelectsAll', false);
user_pref('layout.word_select.stop_at_punctuation', true);
user_pref('media.mediasource.ignore_codecs', true);
user_pref('full-screen-api.warning.timeout', 0);
user_pref('image.mem.min_discard_timeout_ms', 2100000000);
user_pref('image.mem.max_decoded_image_kb', 30000);

// Hide title bar
user_pref('browser.tabs.drawInTitlebar', false);

// No warning on about:config
user_pref('browser.aboutConfig.showWarning', false);

// No warning when closing the browser
user_pref('browser.tabs.warnOnClose', false);

user_pref('gfx.font_rendering.fontconfig.max_generic_substitutions', 127);

user_pref('browser.aboutConfig.showWarning', false);
user_pref('browser.tabs.drawInTitlebar', true);

// Navigate in the URL bar suggestions using <tab>
user_pref('browser.urlbar.update1.restrictTabAfterKeyboardFocus', false);

// Don’t open the URL bar suggestions on focus.
user_pref('browser.urlbar.openViewOnFocus', false);

// Enable userChrome.css
user_pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);

// Acceleration
user_pref('gfx.webrender.all', true);
user_pref('gfx.webrender.enabled', true);
// This can cause issues with the Nvidia driver
user_pref('layers.acceleration.force-enabled', true);

// Scroll
user_pref('mousewheel.min_line_scroll_amount', 40);
user_pref('general.smoothScroll', false);
user_pref('general.smoothScroll.pages', false);
// user_pref("general.smoothScroll.lines.durationMaxMS", 125);
// user_pref("general.smoothScroll.lines.durationMinMS", 125);
// user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
// user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
// user_pref("general.smoothScroll.msdPhysics.enabled", true);
// user_pref("general.smoothScroll.other.durationMaxMS", 125);
// user_pref("general.smoothScroll.other.durationMinMS", 125);
// user_pref("general.smoothScroll.pages.durationMaxMS", 125);
// user_pref("general.smoothScroll.pages.durationMinMS", 125);
