const PG=(()=>{
  function studTexture(){const c=document.createElement('canvas');c.width=c.height=64;const g=c.getContext('2d');g.fillStyle='#fff';g.fillRect(0,0,64,64);
    const gr=g.createRadialGradient(28,28,4,32,32,22);gr.addColorStop(0,'rgba(255,255,255,1)');gr.addColorStop(.7,'rgba(235,235,235,1)');gr.addColorStop(1,'rgba(150,150,150,1)');
    g.fillStyle='rgba(0,0,0,.18)';g.beginPath();g.arc(34,35,19,0,7);g.fill();g.fillStyle=gr;g.beginPath();g.arc(32,32,18,0,7);g.fill();
    const t=new THREE.CanvasTexture(c);t.wrapS=t.wrapT=THREE.RepeatWrapping;t.anisotropy=4;return t;}
  const STUD=studTexture();
  const cache={},geo={};
  function m(color,o={}){const k=[color,o.e||0,o.ei||0,o.op||1,o.rough??.7,o.metal||0,o.own?Math.random():0].join('|');if(cache[k])return cache[k];
    const mt=new THREE.MeshStandardMaterial({color,roughness:o.rough??.7,metalness:o.metal||0,emissive:o.e!==undefined?o.e:0,emissiveIntensity:o.ei||0,transparent:(o.op||1)<1,opacity:o.op||1,depthWrite:(o.op||1)>=.9});
    mt.userData.base=o.ei||0;return cache[k]=mt;}
  function g3(w,h,d){const k=w+'|'+h+'|'+d;return geo[k]||(geo[k]=new THREE.BoxGeometry(w,h,d));}
  const edge=new THREE.LineBasicMaterial({color:0x10141c,transparent:true,opacity:.22});
  function bx(w,h,d,color,o={}){const s=m(color,o);let mats=s;
    if(o.studs){const t=STUD.clone();t.needsUpdate=true;t.repeat.set(Math.max(1,Math.round(w)),Math.max(1,Math.round(d)));const top=new THREE.MeshStandardMaterial({color,map:t,roughness:.7,emissive:s.emissive,emissiveIntensity:s.emissiveIntensity,transparent:s.transparent,opacity:s.opacity});mats=[s,s,top,s,s,s];}
    const me=new THREE.Mesh(g3(w,h,d),mats);me.castShadow=o.cast!==false;me.receiveShadow=true;if(o.line)me.add(new THREE.LineSegments(new THREE.EdgesGeometry(g3(w,h,d)),edge));return me;}
  function put(p,me,x,y,z,rx=0,ry=0,rz=0){me.position.set(x,y,z);me.rotation.set(rx,ry,rz);p.add(me);return me;}
  function ball(r,color,o={}){const me=new THREE.Mesh(new THREE.SphereGeometry(r,16,12),m(color,o));me.castShadow=o.cast!==false;return me;}
  function dotTex(){const c=document.createElement('canvas');c.width=c.height=64;const g=c.getContext('2d');const gr=g.createRadialGradient(32,32,0,32,32,32);gr.addColorStop(0,'rgba(255,255,255,1)');gr.addColorStop(.35,'rgba(255,255,255,.8)');gr.addColorStop(1,'rgba(255,255,255,0)');g.fillStyle=gr;g.fillRect(0,0,64,64);return new THREE.CanvasTexture(c);}
  function starTex(){const c=document.createElement('canvas');c.width=c.height=64;const g=c.getContext('2d');g.translate(32,32);const gr=g.createRadialGradient(0,0,0,0,0,30);gr.addColorStop(0,'rgba(255,255,255,1)');gr.addColorStop(1,'rgba(255,255,255,0)');g.fillStyle=gr;
    g.beginPath();for(let i=0;i<8;i++){const r=i%2?6:30,a=i*Math.PI/4;g.lineTo(Math.cos(a)*r,Math.sin(a)*r);}g.closePath();g.fill();g.beginPath();g.arc(0,0,8,0,7);g.fill();return new THREE.CanvasTexture(c);}
  function flakeTex(){const c=document.createElement('canvas');c.width=c.height=64;const g=c.getContext('2d');g.translate(32,32);g.strokeStyle='#fff';g.lineWidth=5;g.lineCap='round';
    for(let i=0;i<6;i++){g.save();g.rotate(i*Math.PI/3);g.beginPath();g.moveTo(0,0);g.lineTo(0,-26);g.moveTo(0,-14);g.lineTo(-7,-21);g.moveTo(0,-14);g.lineTo(7,-21);g.stroke();g.restore();}return new THREE.CanvasTexture(c);}
  const DOT=dotTex(),STAR=starTex(),FLAKE=flakeTex();
  function particles(n,o){const geoP=new THREE.BufferGeometry(),pos=new Float32Array(n*3),col=new Float32Array(n*3);const seeds=[];
    for(let i=0;i<n;i++){seeds.push({a:Math.random()*6.28,r:Math.random(),t:Math.random(),s:.5+Math.random(),i});const c=new THREE.Color(o.colors[i%o.colors.length]);col.set([c.r,c.g,c.b],i*3);}
    geoP.setAttribute('position',new THREE.BufferAttribute(pos,3));geoP.setAttribute('color',new THREE.BufferAttribute(col,3));
    const pts=new THREE.Points(geoP,new THREE.PointsMaterial({size:o.size||.6,map:o.tex||DOT,vertexColors:true,transparent:true,depthWrite:false,blending:o.normal?THREE.NormalBlending:THREE.AdditiveBlending}));
    pts.userData={seeds,fn:o.fn};pts.frustumCulled=false;return pts;}
  function stepParticles(p,t,dt){const a=p.geometry.attributes.position.array;p.userData.seeds.forEach((s,i)=>{const v=p.userData.fn(s,t,dt);a[i*3]=v[0];a[i*3+1]=v[1];a[i*3+2]=v[2];});p.geometry.attributes.position.needsUpdate=true;}

  const SKINS={
    fire:{name:'Pingüino Inferno',rarity:'MÍTICO',rc:['#ff3d00','#ffb300'],price:2500,tag:'FUEGO',desc:'Tu pingüino de siempre, pero en llamas: cresta de fuego, bufanda de magma, grietas de lava, ojos de brasa y un anillo de fuego a sus pies.',aura:[0xff3d00,0xffb300]},
    ice:{name:'Pingüino Glacial',rarity:'LEGENDARIO',rc:['#00c6ff','#7b5cff'],price:1800,tag:'HIELO',desc:'Todo de hielo, con las mismas manchas de pingüino: azul profundo y panza de escarcha, corona de cristales y fragmentos que orbitan.',aura:[0x3fd0ff,0x9b7bff]},
    santa:{name:'Pingüino Santa',rarity:'ÉPICO',rc:['#e53935','#43a047'],price:999,tag:'NAVIDAD',desc:'Gorro de Santa, barba esponjosa, cinturón dorado, regalo en la aleta y regalitos girando a su alrededor. ¡Jo, jo, jo!',aura:[0xff3b3b,0x2fd35a]},
    reindeer:{name:'Pingüino Reno',rarity:'ÉPICO',rc:['#8d5a2b','#ff2a2a'],price:999,tag:'NAVIDAD',desc:'Diadema de reno con astas y foquitos de colores, nariz roja que brilla, cascabeles y luces navideñas que parpadean.',aura:[0xff2a2a,0xffd23f]},
    classic:{name:'Pingüino Clásico',rarity:'COMÚN',rc:['#5b6b80','#8fa3bd'],price:0,tag:'INICIAL',desc:'El pingüino de siempre con su bufanda roja.'},
  };

  function aura(root,cols,ups,o={}){const g=new THREE.Group();g.position.y=.12;root.add(g);
    const disc=new THREE.Mesh(new THREE.CircleGeometry(4.2,40),new THREE.MeshBasicMaterial({color:cols[0],transparent:true,opacity:.35,depthWrite:false,blending:THREE.AdditiveBlending}));disc.rotation.x=-Math.PI/2;g.add(disc);
    const r1=new THREE.Mesh(new THREE.TorusGeometry(4.2,.16,6,48),new THREE.MeshBasicMaterial({color:cols[0]}));r1.rotation.x=Math.PI/2;g.add(r1);
    const r2=new THREE.Mesh(new THREE.TorusGeometry(3.3,.1,6,40),new THREE.MeshBasicMaterial({color:cols[1]}));r2.rotation.x=Math.PI/2;g.add(r2);
    const dashes=new THREE.Group();g.add(dashes);for(let i=0;i<12;i++){const a=i/12*Math.PI*2;const d=new THREE.Mesh(g3(.9,.08,.3),new THREE.MeshBasicMaterial({color:i%2?cols[0]:cols[1]}));d.position.set(Math.cos(a)*5,0,Math.sin(a)*5);d.rotation.y=-a;dashes.add(d);}
    const beam=new THREE.Mesh(new THREE.CylinderGeometry(4.6,4.2,9,32,1,true),new THREE.MeshBasicMaterial({color:cols[1],transparent:true,opacity:.05,side:THREE.DoubleSide,depthWrite:false,blending:THREE.AdditiveBlending}));beam.position.y=4.5;g.add(beam);
    const rise=particles(40,{colors:cols.concat([0xffffff]),size:.45,tex:STAR,fn:(s,t)=>{const k=(s.t+t*.35*s.s)%1;const a=s.a+t*.8;return[Math.cos(a)*3.8,k*9,Math.sin(a)*3.8];}});g.add(rise);
    ups.push((t,dt)=>{dashes.rotation.y=t*.9;r2.rotation.z=-t*1.3;const k=.5+.5*Math.sin(t*3);disc.material.opacity=.22+k*.2;r1.scale.setScalar(1+k*.05);beam.material.opacity=.02+k*.04;stepParticles(rise,t,dt);});return g;}

  function build(id,opts={}){
    const root=new THREE.Group(),P=new THREE.Group();P.position.y=2.33;root.add(P);
    const ups=[];let light=null;
    const c={body:0x1e2833,belly:0xffffff,face:0xffffff,beak:0xf39c1f,feet:0xf39c1f,sclera:0xffffff,pupil:0x0b0f14,cheek:0xff9eb0};
    const o={body:{line:true},belly:{},face:{},beak:{},feet:{},pupil:{},sclera:{}};
    if(id==='fire'){Object.assign(c,{body:0x1c1a22,belly:0xfff3dc,face:0xfff3dc,pupil:0xff3a00,cheek:0xff6a3d});o.body={line:true,e:0x3a0a00,ei:.12};o.belly={e:0xffb347,ei:.25};o.face={e:0xffb347,ei:.2};o.pupil={e:0xff3a00,ei:1.6};o.beak={e:0xff8a00,ei:.25};o.feet={e:0xff6a00,ei:.3};}
    if(id==='ice'){Object.assign(c,{body:0x2a6cc0,belly:0xeefcff,face:0xeefcff,beak:0x9fe6ff,feet:0x7fd6ff,pupil:0x0a2a78,cheek:0x9fe0ff});o.body={line:true,e:0x1e5cff,ei:.3,op:.86,rough:.08,metal:.1};o.belly={e:0xbff3ff,ei:.35,op:.95,rough:.05};o.face={e:0xbff3ff,ei:.35,op:.95,rough:.05};o.beak={e:0x6fd3ff,ei:.4,op:.9,rough:.05};o.feet={e:0x3fb6ff,ei:.4,op:.9,rough:.05};o.pupil={e:0x2a7fff,ei:.9};}
    put(P,bx(3,3,2.8,c.body,o.body),0,-.5,0);put(P,bx(2.7,1.9,2.6,c.body,o.body),0,1.95,0);
    put(P,bx(2.2,2.5,.2,c.belly,o.belly),0,-.6,-1.45);put(P,bx(2.2,1.2,.16,c.face,o.face),0,2.05,-1.35);
    for(const s of [-1,1]){put(P,bx(.62,.72,.12,c.sclera,Object.assign({cast:false},o.sclera)),s*.58,2.15,-1.46);put(P,bx(.36,.46,.1,c.pupil,Object.assign({cast:false},o.pupil)),s*.55,2.08,-1.53);put(P,bx(.13,.13,.06,0xffffff,{e:0xffffff,ei:1,cast:false}),s*.49,2.2,-1.59);
      put(P,bx(.45,.28,.08,c.cheek,{cast:false}),s,1.62,-1.45);
      const f=new THREE.Group();f.position.set(s*1.55,.6,0);f.name='flip'+s;P.add(f);put(f,bx(.4,2.2,1.5,c.body,o.body),s*.15,-1,0,0,0,s*.18);
      put(P,bx(1,.35,1.4,c.feet,o.feet),s*.75,-2.15,-.35);}
    put(P,bx(.9,.42,.95,c.beak,o.beak),0,1.62,-1.75);
    const flipL=P.getObjectByName('flip-1'),flipR=P.getObjectByName('flip1');
    const scarf=(col,oo={})=>{put(P,bx(3.1,.65,2.9,col,Object.assign({line:true},oo)),0,1.05,0);const tl=put(P,bx(.75,1.7,.3,col,oo),.9,.3,-1.55);return tl;};
    const S=SKINS[id];if(S.aura&&opts.aura!==false)aura(root,S.aura,ups);

    if(id==='classic'){scarf(0xd8302a);put(P,bx(2.8,.7,2.7,0xd8302a),0,3.15,0);put(P,bx(.9,.9,.9,0xffffff),0,3.8,0);}
    if(id==='fire'){
      const tail=scarf(0xff5a00,{e:0xff3a00,ei:.7});const tf=new THREE.Group();tf.position.set(.9,-.6,-1.55);P.add(tf);const tfl=bx(.6,1.2,.6,0xffb300,{e:0xff8a00,ei:1,cast:false,op:.9});tfl.position.y=-.5;tfl.rotation.y=Math.PI/4;tf.add(tfl);
      for(const s of [-1,1]){put(P,bx(.9,.24,.12,0xff3a00,{e:0xff3a00,ei:1.2,cast:false}),s*.6,2.62,-1.5,0,0,s*-.35);
        [[-1.3,.6],[-.2,-.5],[.5,.7],[-1.6,-.8]].forEach(([y,z],i)=>put(P,bx(.08,.8-i*.1,.22,0xff4a00,{e:0xff4a00,ei:1.1,cast:false}),s*1.51,y,z,.4*(i-1),0,0));
        put(P,bx(.08,.6,.2,0xff4a00,{e:0xff4a00,ei:1.1,cast:false}),s*1.36,2.2,.5,.4,0,0);}
      const crest=new THREE.Group();crest.position.set(0,2.85,.15);P.add(crest);const flames=[];
      [[0,0,0,1.4,2.8,0xd41a00],[.6,0,.3,1,2.1,0xf03c00],[-.6,0,.3,1,2.1,0xf03c00],[0,0,.75,.9,1.9,0xe02800],[.32,.25,-.2,.75,1.7,0xff7a00],[-.32,.25,-.2,.75,1.5,0xffa000],[0,.5,0,.55,1.3,0xffd23f]].forEach(([x,y,z,w,h,col],i)=>{
        const fg=new THREE.Group();fg.position.set(x,y,z);crest.add(fg);const me=bx(w,h,w,col,{e:col,ei:i>3?1:.75,cast:false,op:.95});me.position.y=h/2;me.rotation.y=Math.PI/4;fg.add(me);flames.push({fg,ph:Math.random()*6});});
      for(const s of [-1,1]){const fg=new THREE.Group();fg.position.set(s*.15,-2.2,0);(s<0?flipL:flipR).add(fg);const me=bx(.55,1,.55,0xff5a00,{e:0xff4a00,ei:.9,cast:false,op:.9});me.position.y=-.35;me.rotation.y=Math.PI/4;fg.add(me);flames.push({fg,ph:Math.random()*6,small:true});}
      const ring=new THREE.Group();ring.position.y=.1;root.add(ring);for(let i=0;i<12;i++){const a=i/12*Math.PI*2;const fg=new THREE.Group();fg.position.set(Math.cos(a)*3.1,0,Math.sin(a)*3.1);ring.add(fg);const col=[0xd41a00,0xff5a00,0xffa000][i%3];const h=1.2+(i%3)*.5;const me=bx(.6,h,.6,col,{e:col,ei:.9,cast:false,op:.9});me.position.y=h/2;me.rotation.y=Math.PI/4;fg.add(me);flames.push({fg,ph:i,ring:true});}
      const puddle=new THREE.Mesh(new THREE.CircleGeometry(3.4,32),new THREE.MeshBasicMaterial({color:0xff5a00,transparent:true,opacity:.55,depthWrite:false,blending:THREE.AdditiveBlending}));puddle.rotation.x=-Math.PI/2;puddle.position.y=.15;root.add(puddle);
      const embers=particles(120,{colors:[0xff3d00,0xff8a00,0xffd23f,0xffb300],size:.5,fn:(s,t)=>{const k=(s.t+t*.5*s.s)%1;const r=(1+s.r*2.6)*(1-k*.5);return[Math.cos(s.a+t*.7)*r,1+k*10,Math.sin(s.a+t*.7)*r];}});root.add(embers);
      light=new THREE.PointLight(0xff6a00,.6,14,2);light.position.set(0,9,-4);root.add(light);
      ups.push((t,dt)=>{flames.forEach(f=>{const k=.82+Math.sin(t*14+f.ph)*.14+Math.sin(t*23+f.ph)*.08;f.fg.scale.set(1,k*(f.small?1.1:1),1);f.fg.rotation.z=Math.sin(t*3+f.ph)*.12;});ring.rotation.y=t*.8;tf.scale.y=.8+Math.sin(t*16)*.2;
        stepParticles(embers,t,dt);light.intensity=.55+Math.sin(t*17)*.15+Math.sin(t*29)*.08;puddle.material.opacity=.4+Math.sin(t*5)*.12;});}
    if(id==='ice'){
      scarf(0xbff3ff,{e:0x9fe6ff,ei:.5,op:.9,rough:.05});
      const crown=new THREE.Group();crown.position.set(0,2.9,0);P.add(crown);const crys=[];
      [[0,0,0,.6,2.8,0],[.75,0,.2,.45,2,-.35],[-.75,0,.2,.45,2,.35],[.4,0,.8,.4,1.6,-.2],[-.4,0,.8,.4,1.6,.2],[1.05,0,-.4,.35,1.3,-.6],[-1.05,0,-.4,.35,1.3,.6]].forEach(([x,y,z,w,h,rz],i)=>{
        const me=bx(w,h,w,i%2?0xe6faff:0xa9e9ff,{e:0x7fdcff,ei:.8,op:.88,rough:.05,cast:false});me.position.set(x-Math.sin(rz)*h/2,y+h/2*Math.cos(rz),z);me.rotation.set(0,Math.PI/4,rz);crown.add(me);crys.push(me);});
      for(let i=0;i<5;i++){const h=1.2+i%2*.7;put(P,bx(.38,h,.38,0xd8f6ff,{e:0x7fdcff,ei:.7,op:.88,rough:.05}),-.8+i*.4,.6+h/2,1.4,-.5,Math.PI/4,0);}
      for(let i=0;i<4;i++)put(P,bx(.22,.6+i%2*.3,.22,0xeefcff,{e:0xbff3ff,ei:.6,op:.9,cast:false}),-.45+i*.3,1.05,-1.82);
      for(const s of [-1,1])for(let i=0;i<3;i++)put(s<0?flipL:flipR,bx(.18,.5+i*.15,.18,0xeefcff,{e:0xbff3ff,ei:.6,op:.9,cast:false}),s*.15,-2.2-i*.1,-.4+i*.4);
      const orb=new THREE.Group();orb.position.y=4;root.add(orb);for(let i=0;i<7;i++){const a=i/7*Math.PI*2;const sh=bx(.5,1.3,.5,i%2?0xe6faff:0x8fe3ff,{e:0x6fd3ff,ei:.9,op:.88,rough:.05,cast:false});sh.position.set(Math.cos(a)*3.6,Math.sin(i*1.7)*1.2,Math.sin(a)*3.6);sh.rotation.set(.4,a,.3);orb.add(sh);}
      const frost=new THREE.Mesh(new THREE.CircleGeometry(3.6,6),new THREE.MeshBasicMaterial({color:0xbff3ff,transparent:true,opacity:.5,depthWrite:false}));frost.rotation.x=-Math.PI/2;frost.position.y=.14;root.add(frost);
      const flakes=particles(40,{colors:[0xffffff,0xbff3ff,0x9fd8ff],size:1.1,tex:FLAKE,fn:(s,t)=>{const a=s.a+t*.5*s.s;return[Math.cos(a)*(2.5+s.r*2),1+((s.t*9+t*.6)%9),Math.sin(a)*(2.5+s.r*2)];}});root.add(flakes);
      const sparkle=particles(50,{colors:[0xffffff,0xbff3ff],size:.7,tex:STAR,fn:(s,t)=>[Math.cos(s.a)*(1.5+s.r*2.5),1+s.t*9,Math.sin(s.a)*(1.5+s.r*2.5)]});root.add(sparkle);
      light=new THREE.PointLight(0x6fd3ff,1.2,20,2);light.position.set(0,6,-3);root.add(light);
      ups.push((t,dt)=>{stepParticles(flakes,t,dt);stepParticles(sparkle,t,dt);sparkle.material.size=.4+Math.abs(Math.sin(t*5))*.6;orb.rotation.y=t*.9;orb.children.forEach((c,i)=>c.rotation.y+=dt*2);
        crys.forEach((c,i)=>c.material.emissiveIntensity=.6+.5*Math.max(0,Math.sin(t*3-i)));frost.rotation.z=t*.3;});}
    if(id==='santa'){
      const sc=new THREE.Group();P.add(sc);for(let i=0;i<5;i++)put(sc,bx(.62,.67,2.92,i%2?0xffffff:0xd8302a,{line:true}),-1.24+i*.62,1.05,0);put(P,bx(.75,1.7,.3,0xd8302a),.9,.3,-1.55);for(let i=0;i<3;i++)put(P,bx(.77,.3,.32,0xffffff),.9,.9-i*.6,-1.56);
      put(P,bx(3.1,.5,2.9,0x1e1e1e,{line:true}),0,-.9,0);put(P,bx(.9,.7,.15,0xffd23f,{e:0xffb300,ei:.5,metal:.4,rough:.3}),0,-.9,-1.52);put(P,bx(.45,.35,.18,0x1e1e1e),0,-.9,-1.56);
      put(P,bx(3,.8,2.9,0xffffff,{studs:true,line:true}),0,3.2,0);
      const hat=new THREE.Group();hat.position.set(0,3.6,0);P.add(hat);const segs=[];let parent=hat;
      [[2.5,1.1],[1.9,1],[1.35,.9],[.85,.8]].forEach(([w,h],i)=>{const sg=new THREE.Group();sg.position.y=i?segs[i-1].h:0;parent.add(sg);put(sg,bx(w,h,w,0xd8302a,{line:true}),0,h/2,0);segs.push({g:sg,h});parent=sg;});
      const pom=bx(1,1,1,0xffffff,{studs:true,line:true});pom.position.set(0,1.2,0);parent.add(pom);const pomStar=ball(.25,0xffd23f,{e:0xffd23f,ei:1.2});pomStar.position.set(0,1.85,0);parent.add(pomStar);
      put(P,bx(2.4,1.3,.7,0xffffff,{studs:true,line:true}),0,.95,-1.6);put(P,bx(1.7,.9,.6,0xf4f6f8,{line:true}),0,.0,-1.6);put(P,bx(.9,.7,.5,0xffffff,{line:true}),0,-.7,-1.55);
      for(const s of [-1,1])put(P,bx(1,.38,.35,0xffffff,{line:true}),s*.6,1.42,-1.9,0,0,s*.25);put(P,bx(.6,.3,.3,0xffffff),0,1.25,-1.95);
      const gift=new THREE.Group();gift.position.set(-.3,-2.1,-.6);flipL.add(gift);put(gift,bx(1.5,1.5,1.5,0x2e9b4a,{line:true}),0,0,0);put(gift,bx(1.55,1.55,.3,0xd8302a),0,0,0);put(gift,bx(.3,1.55,1.55,0xd8302a),0,0,0);put(gift,bx(.7,.4,.3,0xffd23f,{e:0xffb300,ei:.4}),0,.95,0,0,0,.6);put(gift,bx(.7,.4,.3,0xffd23f,{e:0xffb300,ei:.4}),0,.95,0,0,0,-.6);
      const orb=new THREE.Group();orb.position.y=4.5;root.add(orb);[[0xd8302a,0xffd23f],[0x2e9b4a,0xd8302a],[0x2f6fd6,0xffffff],[0xffd23f,0x2e9b4a],[0xff6fae,0xffffff]].forEach(([a,b],i)=>{const g=new THREE.Group();const an=i/5*Math.PI*2;g.position.set(Math.cos(an)*3.8,Math.sin(i*2)*.8,Math.sin(an)*3.8);orb.add(g);put(g,bx(.9,.9,.9,a,{line:true}),0,0,0);put(g,bx(.95,.95,.2,b),0,0,0);put(g,bx(.2,.95,.95,b),0,0,0);});
      const cane=new THREE.Group();cane.position.set(1.2,0,1.5);cane.rotation.z=-.3;P.add(cane);for(let i=0;i<6;i++)put(cane,bx(.3,.5,.3,i%2?0xffffff:0xd8302a),0,-1.2+i*.5,0);put(cane,bx(.3,.3,.9,0xd8302a),0,1.75,-.3);put(cane,bx(.3,.6,.3,0xffffff),0,1.45,-.75);
      const snow=particles(70,{colors:[0xffffff,0xffffff,0xffe28a],size:.55,tex:STAR,fn:(s,t)=>{const k=(s.t+t*.12*s.s)%1;return[Math.cos(s.a)*(1.5+s.r*3)+Math.sin(t+s.a)*.4,10-k*10,Math.sin(s.a)*(1.5+s.r*3)];}});root.add(snow);
      light=new THREE.PointLight(0xffd23f,.7,16,2);light.position.set(0,7,-3);root.add(light);
      ups.push((t,dt)=>{segs.forEach((s,i)=>{if(i)s.g.rotation.z=-.22-Math.sin(t*2.2)*.06*i;s.g.rotation.x=Math.sin(t*1.7)*.04*i;});stepParticles(snow,t,dt);orb.rotation.y=-t*.8;orb.children.forEach((g,i)=>{g.rotation.y=t*2+i;g.position.y=Math.sin(t*2+i)*.8;});pomStar.material.emissiveIntensity=.6+Math.abs(Math.sin(t*4))*1.2;});}
    if(id==='reindeer'){
      scarf(0x7a4a28);
      put(P,bx(2.8,.5,2.7,0x8a5530,{line:true,studs:true}),0,3.15,0);put(P,bx(3,.3,.3,0x8a5530,{line:true}),0,3,-1.2);
      const bulbs=[];const BC=[0xff3b5c,0xffd23f,0x3fd0ff,0x7dff7a,0xff7ae0];
      for(const s of [-1,1]){
        const ant=new THREE.Group();ant.position.set(s*.85,3.3,.2);ant.rotation.z=-s*.35;P.add(ant);
        put(ant,bx(.35,2.4,.35,0xc89a5a,{line:true}),0,1.2,0);put(ant,bx(.3,1.2,.3,0xd9ad6c,{line:true}),s*.45,1.5,0,0,0,-s*.9);put(ant,bx(.3,1,.3,0xd9ad6c,{line:true}),s*.35,2.3,-.1,0,0,-s*.8);put(ant,bx(.3,.9,.3,0xd9ad6c,{line:true}),-s*.3,2.1,0,0,0,s*.7);
        [[0,2.4,0],[s*.9,1.9,0],[s*.7,2.7,-.1],[-s*.55,2.5,0]].forEach(([x,y,z],i)=>{const b=ball(.2,BC[(i+(s>0?2:0))%5],{e:BC[(i+(s>0?2:0))%5],ei:1,own:true,cast:false});b.position.set(x,y,z);ant.add(b);bulbs.push(b);});
        put(P,bx(.9,.45,.3,0x8a5530,{line:true}),s*1.55,2.95,.1,0,0,s*.5);put(P,bx(.6,.25,.32,0xf0b9a0),s*1.6,2.95,.05,0,0,s*.5);}
      const nose=ball(.42,0xff1a1a,{e:0xff1a1a,ei:1.8,rough:.2,own:true});nose.position.set(0,1.62,-2.25);P.add(nose);
      put(P,bx(3.12,.4,2.92,0xc62828,{line:true}),0,.55,0);const bells=[];
      [-.8,0,.8].forEach(x=>{const b=ball(.32,0xffd23f,{e:0xffb300,ei:.5,metal:.5,rough:.25});b.position.set(x,.2,-1.6);P.add(b);bells.push(b);});
      const wrap=new THREE.Group();P.add(wrap);for(let i=0;i<16;i++){const a=i/16*Math.PI*2;const y=-1.6+i/16*1.6;const b=ball(.18,BC[i%5],{e:BC[i%5],ei:1,own:true,cast:false});b.position.set(Math.cos(a)*1.62,y,Math.sin(a)*1.52);wrap.add(b);bulbs.push(b);}
      light=new THREE.PointLight(0xff2020,1.4,14,2);light.position.set(0,4,-3.4);root.add(light);
      const sp=particles(60,{colors:[0xff3b3b,0xffd23f,0xffffff,0x7dff7a],size:.6,tex:STAR,fn:(s,t)=>{const a=s.a+t*.5;return[Math.cos(a)*(2+s.r*1.8),1+((s.t*8+t*.4)%8),Math.sin(a)*(2+s.r*1.8)];}});root.add(sp);
      ups.push((t,dt)=>{const k=.5+.5*Math.sin(t*4);nose.material.emissiveIntensity=1+k*2.4;light.intensity=.6+k*1.8;nose.scale.setScalar(1+k*.14);bells.forEach((b,i)=>b.position.x=[-.8,0,.8][i]+Math.sin(t*9+i)*.05);
        bulbs.forEach((b,i)=>b.material.emissiveIntensity=((Math.floor(t*4)+i)%3===0)?2.2:.3);stepParticles(sp,t,dt);});}

    const base=P.position.y;
    function update(t,dt,mode='idle'){
      const hop=mode==='happy'?Math.abs(Math.sin(t*5))*1.2:Math.abs(Math.sin(t*2.2))*.18;P.position.y=base+hop;
      const a=mode==='happy'?Math.sin(t*10):Math.sin(t*2.2)*.3;flipL.rotation.z=-.15-Math.max(0,a)*(mode==='happy'?1.6:.5);flipR.rotation.z=.15+Math.max(0,-a)*(mode==='happy'?1.6:.5);
      ups.forEach(f=>f(t,dt));}
    return {group:root,update,flipL,flipR};
  }
  function thumbs(ids,size=256){const r=new THREE.WebGLRenderer({antialias:true,alpha:true,preserveDrawingBuffer:true});r.setSize(size,size);r.outputEncoding=THREE.sRGBEncoding;
    const out={};ids.forEach(id=>{const sc=new THREE.Scene();sc.add(new THREE.HemisphereLight(0xffffff,0x8899bb,.9));const d=new THREE.DirectionalLight(0xffffff,.8);d.position.set(-5,8,-8);sc.add(d);
      const p=build(id,{aura:false});p.update(1.3,0);sc.add(p.group);const cam=new THREE.PerspectiveCamera(32,1,.1,100);cam.position.set(4.5,6.2,-13);cam.lookAt(0,4.4,0);r.render(sc,cam);out[id]=r.domElement.toDataURL();});
    r.dispose();return out;}
  return {build,thumbs,SKINS,bx,put,m,ball,particles,stepParticles,STUD,STAR,FLAKE};
})();
