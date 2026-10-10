# Branding v1

`app-icon.png` is the approved athlete icon. `Cover.svg` is the supplied source
illustration. The SVG includes transparent overflow to the left; the export is
cropped to the opaque rectangle (78.8287, 1.26831, 441.2843, 621.15769).

`cover.png` is the Flutter startup image. It fills the available screen with
`BoxFit.cover`, keeping its proportions. Its image is decoded before the first
Flutter frame is released. The one-second hold starts after the Android native
splash has faded out, then `/home` crossfades in over 400 ms. Back does not
return to the cover. iOS and pre-Android-12 launches have no native exit wait.

Android launcher icons include legacy density exports and an adaptive icon with
padded foreground for system masks. Android 12+ uses the branded app icon on a
solid white background before Flutter shows the full cover. The native vector
animation lasts 1000 ms, and its exit fade lasts 320 ms. The athlete pulses the
start point, draws its route, and moves its arrow. On older Android versions,
the native window fills its bounds with the cover bitmap; Flutter then crops
the image proportionally. Both day and night launch themes use the same colors.

iOS launcher images include all sizes in the existing AppIcon catalog. The
native launch storyboard fills the view with the cover using aspect fill.
iOS changes must be built and checked on macOS/Xcode.

To regenerate PNGs and native resources, install Node.js and Sharp, then run:

```sh
npm install --no-save sharp
node tool/generate_branding.cjs
```

`BRANDING_SHARP_MODULE` may point to an existing Sharp installation. Commit the
generated resources; the app itself has no dependency on Node.js or Sharp.

`animation-paths.json` contains vector layers traced from the approved icon;
native resources can also be regenerated without Sharp with
`node tool/generate_splash.cjs`. The branding generator runs this step last,
so it preserves the animated splash when rebuilding launcher icons.
