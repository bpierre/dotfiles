// Important: keep the semicolons or a parsing
// error will prevent the file to be executed.
// user_pref('widget.content.gtk-theme-override', 'Adwaita');
user_pref('browser.fixup.alternate.enabled', false);
user_pref('browser.urlbar.trimURLs', false);
user_pref('general.warnOnAboutConfig', false);
// user_pref('layout.css.devPixelsPerPx', '1.25');
user_pref('layout.css.devPixelsPerPx', '1.3');
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

// Compact UI density
user_pref('browser.uidensity', 1);

// No warning when closing the browser
user_pref('browser.tabs.warnOnClose', false);

user_pref('gfx.font_rendering.fontconfig.max_generic_substitutions', 127);

user_pref('browser.aboutConfig.showWarning', false);

// Navigate in the URL bar suggestions using <tab>
user_pref('browser.urlbar.update1.restrictTabAfterKeyboardFocus', false);

// Don’t open the URL bar suggestions on focus.
user_pref('browser.urlbar.openViewOnFocus', false);

// Enable userChrome.css
user_pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);

// Acceleration
// user_pref('gfx.webrender.all', true);
// user_pref('gfx.webrender.enabled', true);
// user_pref('layers.acceleration.force-enabled', true);

// VP9 video acceleration
// user_pref('media.ffmpeg.vaapi.enabled', true);
// user_pref('media.ffmpeg.vaapi-drm-display.enabled', true);

// Enable hardware VA-API decoding for WebRTC
// user_pref('media.navigator.mediadatadecoder_vpx_enabled', true);

// Use libvpx instead of ffvpx to decode vp9
// user_pref('media.ffvpx.enabled', false);

// Disable the remote data decoder process for VP8/VP9
// user_pref('media.rdd-vpx.enabled', false);

// Disable EGL on X11 (see also MOZ_X11_EGL=1 in ~/.profile)
// user_pref('gfx.x11-egl.force-disabled', false);
// user_pref('gfx.x11-egl.force-enabled', true);

// Scroll
user_pref('mousewheel.min_line_scroll_amount', 40);
user_pref('general.smoothScroll', false);
user_pref('general.smoothScroll.pages', false);
