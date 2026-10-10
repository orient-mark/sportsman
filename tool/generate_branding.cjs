// npm install --no-save sharp, then: node tool/generate_branding.cjs
// BRANDING_SHARP_MODULE can point to a bundled Sharp installation.
const fs = require('node:fs/promises');
const path = require('node:path');
const sharp = require(process.env.BRANDING_SHARP_MODULE || 'sharp');
const root = path.resolve(__dirname, '..');
const assets = path.join(root, 'assets/branding');
const background = process.argv.includes('--organizer') ? '#0B0B0B' : '#FFFFFF';

async function write(file, data) {
  const target = path.join(root, file);
  await fs.mkdir(path.dirname(target), { recursive: true });
  await fs.writeFile(target, data);
}

async function main() {
  const master = path.join(assets, 'app-icon.png');
  // Crop the exported SVG to its opaque illustration, leaving out overflow.
  const svg = (await fs.readFile(path.join(assets, 'Cover.svg'), 'utf8'))
    .replace('width="521" height="623" viewBox="0 0 521 623"',
      'width="441.2843" height="621.15769" viewBox="78.8287 1.26831 441.2843 621.15769"');
  const cover = await sharp(Buffer.from(svg)).resize({height: 1500}).flatten({background: '#9BD9ED'}).png().toBuffer();
  await write('assets/branding/cover.png', cover);
  for (const [density, size] of Object.entries({mdpi:48, hdpi:72, xhdpi:96, xxhdpi:144, xxxhdpi:192})) {
    await write(`android/app/src/main/res/mipmap-${density}/ic_launcher.png`, await sharp(master).resize(size, size).flatten({background}).png().toBuffer());
  }
  const small = await sharp(master).resize(264,264).flatten({background}).png().toBuffer();
  const foreground = await sharp({create:{width:432,height:432,channels:4,background}})
    .composite([{input:small,left:84,top:84}]).png().toBuffer();
  await write('android/app/src/main/res/drawable-xxxhdpi/ic_launcher_foreground.png', foreground);
  await write('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml', `<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
`);
  await write('android/app/src/main/res/values/branding.xml', `<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="launcher_background">${background}</color>
    <color name="launch_sky">#9BD9ED</color>
    <color name="launch_water">#9ECBC3</color>
</resources>
`);
  // Android's legacy starting window uses the cover; Flutter then uses BoxFit.cover.
  await write('android/app/src/main/res/drawable-nodpi/launch_cover.png', cover);
  const launch = `<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/launch_sky" />
    <item><bitmap android:gravity="fill" android:src="@drawable/launch_cover" /></item>
</layer-list>
`;
  for (const folder of ['drawable','drawable-v21']) {
    await write(`android/app/src/main/res/${folder}/launch_background.xml`, launch);
  }
  for (const night of [false,true]) {
    const normalParent = night ? 'Theme.Black.NoTitleBar' : 'Theme.Light.NoTitleBar';
    const theme = `<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/${normalParent}">
        <item name="android:windowBackground">@drawable/launch_background</item>
        <item name="android:statusBarColor">@color/launch_sky</item>
        <item name="android:navigationBarColor">@color/launch_water</item>
        <item name="android:windowLightStatusBar">true</item>
        <item name="android:windowLightNavigationBar">true</item>
    </style>
    <style name="NormalTheme" parent="@android:style/${normalParent}">
        <item name="android:windowBackground">@color/launch_sky</item>
    </style>
</resources>
`;
    await write(`android/app/src/main/res/values${night ? '-night' : ''}/styles.xml`, theme);
    await write(`android/app/src/main/res/values${night ? '-night' : ''}-v31/styles.xml`, theme.replace(
      '<item name="android:windowBackground">@drawable/launch_background</item>',
      `<item name="android:windowBackground">@color/launch_sky</item>
        <item name="android:windowSplashScreenBackground">@color/launch_sky</item>
        <item name="android:windowSplashScreenAnimatedIcon">@mipmap/ic_launcher</item>
        <item name="android:windowSplashScreenIconBackgroundColor">@color/launcher_background</item>`));
  }
  const iconDir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
  const catalog = JSON.parse(await fs.readFile(path.join(root, iconDir, 'Contents.json'), 'utf8'));
  const sizes = new Map(catalog.images.map(item => [item.filename, Math.round(parseFloat(item.size) * parseFloat(item.scale))]));
  for (const [filename, size] of sizes) {
    await write(`${iconDir}/${filename}`, await sharp(master).resize(size,size).flatten({background}).removeAlpha().png().toBuffer());
  }
  for (const scale of [1,2,3]) {
    await write(`ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage${scale===1?'':`@${scale}x`}.png`,
      await sharp(Buffer.from(svg)).resize({height:621*scale}).flatten({background:'#9BD9ED'}).removeAlpha().png().toBuffer());
  }
  const storyboardPath = 'ios/Runner/Base.lproj/LaunchScreen.storyboard';
  let storyboard = await fs.readFile(path.join(root, storyboardPath), 'utf8');
  storyboard = storyboard.replace('contentMode="center" image="LaunchImage"', 'contentMode="scaleAspectFill" image="LaunchImage"');
  storyboard = storyboard.replace(/<constraints>[\s\S]*?<\/constraints>/,
    `<constraints>
                            <constraint firstItem="YRO-k0-Ey4" firstAttribute="leading" secondItem="Ze5-6b-2t3" secondAttribute="leading" id="cover-leading"/>
                            <constraint firstItem="YRO-k0-Ey4" firstAttribute="trailing" secondItem="Ze5-6b-2t3" secondAttribute="trailing" id="cover-trailing"/>
                            <constraint firstItem="YRO-k0-Ey4" firstAttribute="top" secondItem="Ze5-6b-2t3" secondAttribute="top" id="cover-top"/>
                            <constraint firstItem="YRO-k0-Ey4" firstAttribute="bottom" secondItem="Ze5-6b-2t3" secondAttribute="bottom" id="cover-bottom"/>
                        </constraints>`);
  storyboard = storyboard.replace('<image name="LaunchImage" width="168" height="185"/>', '<image name="LaunchImage" width="441" height="621"/>');
  await write(storyboardPath, storyboard);
  require('node:child_process').execFileSync(process.execPath, [path.join(__dirname, 'generate_splash.cjs'), ...process.argv.slice(2)], {stdio:'inherit'});
  console.log(`Branding generated: ${root}`);
}
main().catch(error => { console.error(error); process.exitCode=1; });
