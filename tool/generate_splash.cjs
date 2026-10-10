// Regenerate native Android animation resources from the approved vector layers.
const fs = require('node:fs/promises');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const res = path.join(root, 'android/app/src/main/res');
const header = '<?xml version="1.0" encoding="utf-8"?>\n';
const ns = 'xmlns:android="http://schemas.android.com/apk/res/android"';
const circle = (x,y,r) => `M${x-r},${y}a${r},${r} 0,1 0,${2*r},0a${r},${r} 0,1 0,-${2*r},0`;
const floatAnim = (property,from,to,offset,duration) =>
  `<objectAnimator android:propertyName="${property}" android:valueFrom="${from}" android:valueTo="${to}" android:valueType="floatType" android:startOffset="${offset}" android:duration="${duration}" android:interpolator="@android:interpolator/fast_out_slow_in"/>`;
const pulseAnim = (property,offset,duration) => `<objectAnimator android:startOffset="${offset}" android:duration="${duration}" android:interpolator="@android:interpolator/accelerate_decelerate">
    <propertyValuesHolder android:propertyName="${property}" android:valueType="floatType">
        <keyframe android:fraction="0" android:value="1"/>
        <keyframe android:fraction="0.5" android:value="1.24"/>
        <keyframe android:fraction="1" android:value="1"/>
    </propertyValuesHolder>
</objectAnimator>`;
async function write(file,data){await fs.mkdir(path.dirname(path.join(res,file)),{recursive:true});await fs.writeFile(path.join(res,file),header+data+'\n');}
async function main(){
  const organizer=process.argv.includes('--organizer');
  const artwork=JSON.parse(await fs.readFile(path.join(root,'assets/branding/animation-paths.json'),'utf8'));
  const targets=[];
  const animations=[];
  function target(name,resource,body){targets.push(`<target android:name="${name}" android:animation="@animator/${resource}"/>`);animations.push(write(`animator/${resource}.xml`,`<set ${ns}>${body}</set>`));}
  let moving='';
  if(!organizer){
    const route='M228 245 C268 245 270 268 271 286 C272 306 289 309 308 309 C321 309 323 325 328 338 C334 354 349 356 366 357 C379 358 381 372 401.8 377.2';
    const coords=route.match(/[MC]|-?\d+(?:\.\d+)?/g);let index=0;
    const motion=coords.map(s=>/[MC]/.test(s)?s:String(Number((Number(s)-(index++%2?377.2:401.8)).toFixed(2)))).join(' ');
    moving=`<path android:name="route" android:pathData="${route}" android:fillColor="#00000000" android:strokeColor="#FF8400" android:strokeWidth="14" android:strokeLineCap="round" android:strokeLineJoin="round" android:trimPathEnd="0"/>
        <group android:name="node0" android:pivotX="228" android:pivotY="245"><path android:pathData="${circle(228,245,16.5)}" android:fillColor="#FF8400"/></group>
        <group android:name="arrow" android:pivotX="401.8" android:pivotY="377.2" android:translateX="-173.8" android:translateY="-132.2" android:scaleX="0.48" android:scaleY="0.48">
            <path android:name="arrow_shape" android:pathData="${artwork.arrow}" android:fillColor="#FF8400" android:fillAlpha="0"/>
        </group>`;
    target('node0','splash_pulse_0',pulseAnim('scaleX',0,240)+pulseAnim('scaleY',0,240));
    target('route','splash_route',floatAnim('trimPathEnd',0,1,240,660));
    target('arrow_shape','splash_arrow_alpha',floatAnim('fillAlpha',0,1,240,30));
    target('arrow','splash_arrow_motion',`<objectAnimator android:propertyXName="translateX" android:propertyYName="translateY" android:pathData="${motion}" android:startOffset="240" android:duration="660" android:interpolator="@android:interpolator/fast_out_slow_in"/>`+floatAnim('scaleX',0.48,1,240,660)+floatAnim('scaleY',0.48,1,240,660));
  }else{
    moving=`<path android:pathData="${artwork.route}" android:fillColor="#FF8400"/>`;
    [[228.5,247,20],[311.5,324,20.5],[400,397,20.5]].forEach(([x,y,r],i)=>{
      moving+=`<group android:name="node${i}" android:pivotX="${x}" android:pivotY="${y}"><path android:pathData="${circle(x,y,r)}" android:fillColor="#FF8400"/></group>`;
      target(`node${i}`,`splash_pulse_${i}`,['scaleX','scaleY'].map(property=>pulseAnim(property,i*230,200)+pulseAnim(property,720,240)).join(''));
    });
  }
  // The art stays inside Android's circular safe region, on its original solid background.
  await write('drawable/splash_icon_vector.xml',`<vector ${ns} android:width="288dp" android:height="288dp" android:viewportWidth="512" android:viewportHeight="512">
    <group android:name="art" android:pivotX="256" android:pivotY="256" android:scaleX="0.64" android:scaleY="0.64">
        <path android:pathData="${artwork.qr}" android:fillColor="${organizer?'#FFFFFF':'#0B0B0B'}" android:fillType="evenOdd"/>
        <path android:pathData="${artwork.islands}" android:fillColor="#FF8400" android:fillType="evenOdd"/>
        ${moving}
    </group>
</vector>`);
  // A final no-op target keeps the native animation duration at exactly one second.
  target('art','splash_duration',floatAnim('rotation',0,0,0,1000));
  await Promise.all(animations);
  await write('drawable/splash_icon_animated.xml',`<animated-vector ${ns} android:drawable="@drawable/splash_icon_vector">${targets.join('\n')}</animated-vector>`);
  for(const night of [false,true]){
    const file=`values${night?'-night':''}-v31/styles.xml`;
    const parent=night?'Theme.Black.NoTitleBar':'Theme.Light.NoTitleBar';
    await write(file,`<resources>
    <style name="LaunchTheme" parent="@android:style/${parent}">
        <item name="android:windowBackground">@color/launcher_background</item>
        <item name="android:windowSplashScreenBackground">@color/launcher_background</item>
        <item name="android:windowSplashScreenAnimatedIcon">@drawable/splash_icon_animated</item>
        <item name="android:windowSplashScreenAnimationDuration">1000</item>
        <item name="android:statusBarColor">@color/launcher_background</item>
        <item name="android:navigationBarColor">@color/launcher_background</item>
        <item name="android:windowLightStatusBar">${!organizer}</item>
        <item name="android:windowLightNavigationBar">${!organizer}</item>
    </style>
    <style name="NormalTheme" parent="@android:style/${parent}">
        <item name="android:windowBackground">@color/launch_sky</item>
    </style>
</resources>`);
  }
  console.log('Native splash generated:',root);
}
main().catch(e=>{console.error(e);process.exitCode=1;});
