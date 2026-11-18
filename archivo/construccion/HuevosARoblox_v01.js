const THREE = require('./node_modules/three/build/three.js');
const ctx = new Proxy({}, { get: (t, k) => (k === 'createRadialGradient' || k === 'createLinearGradient') ? () => ({ addColorStop() {} }) : (typeof k === 'string' ? () => {} : undefined), set: () => true });
const document = { createElement: () => ({ getContext: () => ctx }) };
const window = { matchMedia: () => ({ matches: false }) };
let code = require('fs').readFileSync('eggs_src.js', 'utf8') + '\nmodule.exports = { EGGS, buildEgg };';
const m = { exports: {} };
new Function('module', 'require', 'THREE', 'document', 'window', code)(m, require, THREE, document, window);
const A = [];
for (let c = 35; c <= 126; c++) if (c !== 92 && c !== 93) A.push(String.fromCharCode(c));
const B = A.length;
const one = (v) => { if (v < 0 || v >= B) throw new Error('one ' + v); return A[v]; };
const two = (v) => { v = Math.round(v); if (v < 0 || v >= B * B) throw new Error('two ' + v); return A[Math.floor(v / B)] + A[v % B]; };
const RAR = { comun: 'common', raro: 'rare', epico: 'epic', legendario: 'legendary', mitico: 'mythic', celestial: 'celestial', secreto: 'secret' };
const lines = [];
let maxPal = 0, total = 0;
for (const spec of m.exports.EGGS) {
  const { group, update } = m.exports.buildEgg(spec, false);
  try { update(0, null); } catch (e) {}
  group.updateMatrixWorld(true);
  const pal = [], palIdx = {};
  const ci = (mat) => { const h = mat.color.clone().convertLinearToSRGB().getHexString(); if (!(h in palIdx)) { palIdx[h] = pal.length; pal.push(h); } return palIdx[h]; };
  const flags = (o, mat) => {
    const gi = mat.emissive && (mat.emissive.r + mat.emissive.g + mat.emissive.b) > 0 ? mat.emissiveIntensity : 0;
    const glowT = gi >= 0.8 ? 2 : gi > 0 ? 1 : 0;
    const tr = mat.transparent ? Math.min(3, Math.max(1, Math.round((1 - mat.opacity) * 4))) : 0;
    const studs = Array.isArray(o.material) && o.material[2] && o.material[2].map ? 1 : 0;
    return (mat.metalness > 0.2 ? 1 : 0) | (studs << 1) | (glowT << 2) | (tr << 4);
  };
  const procedural = !spec.layerMotion;
  let layers = '', tiles = '', generic = '';
  let count = 0;
  group.traverse((o) => {
    if (!o.isMesh) return; const mat = [].concat(o.material)[0]; if (!mat.isMeshStandardMaterial || o.geometry.type !== 'BoxGeometry') return;
    const lg = o.parent && o.parent.parent === group && o.parent.userData.y !== undefined ? o.parent : null;
    const p = o.geometry.parameters;
    if (procedural && lg) {
      const i = Math.round((lg.userData.y - 0.25) / 0.5);
      if (p.depth === 0.06) {
        const a = Math.round(o.rotation.y / (Math.PI / 2));
        const f = ((a % 4) + 4) % 4;
        const w = (() => { const u = 2 * ((i + 0.5) / 12) - 1; const r = Math.pow(Math.max(0, 1 - Math.pow(Math.abs(u), 2.5)), 1 / 2.5) * (1 - 0.14 * u); return Math.max(1.6, Math.round(r * 4.4 / 1.14 / 0.4) * 0.4); })();
        const notch = Math.min(0.8, w * 0.22), fw = w - notch, n = Math.max(1, Math.round(fw / 0.55));
        const nx = Math.sin(f * Math.PI / 2), nz = Math.cos(f * Math.PI / 2);
        const along = nz * o.position.x - nx * o.position.z;
        const c = Math.round((along + fw / 2) / (fw / n) - 0.5);
        tiles += one(i) + one(f * 12 + c) + one(ci(mat)) + one(flags(o, mat));
        count++;
        return;
      }
      if (p.width >= p.depth) { layers += one(ci(mat)) + one(flags(o, mat)); count += 2; }
      return;
    }
    const pos = new THREE.Vector3(), q = new THREE.Quaternion(), s = new THREE.Vector3();
    o.matrixWorld.decompose(pos, q, s);
    const size = [p.width * Math.abs(s.x), p.height * Math.abs(s.y), p.depth * Math.abs(s.z)];
    if (size.some((v) => v < 0.01)) return;
    const e = new THREE.Euler().setFromQuaternion(q, 'XYZ');
    const deg = [e.x, e.y, e.z].map((r) => ((Math.round(r * 180 / Math.PI) % 360) + 360) % 360);
    const rotated = deg.some((d) => d !== 0);
    generic += (rotated ? '!' : '') ;
    let rec = [pos.x, pos.y, pos.z].map((v) => two((v + 20) * 100)).join('') + size.map((v) => two(v * 100)).join('') + one(ci(mat)) + one(flags(o, mat));
    if (rotated) rec += deg.map((d) => two(d)).join('');
    generic += rec;
    count++;
  });
  maxPal = Math.max(maxPal, pal.length);
  if (pal.length > B) throw new Error('palette ' + spec.id);
  total += count;
  lines.push([spec.id, RAR[spec.rarity], spec.name, pal.join(''), procedural ? 1 : 0, layers, tiles, generic]);
}
const fs = require('fs');
fs.writeFileSync('alphabet.txt', A.join(''));
fs.writeFileSync('designs.json', JSON.stringify(lines));
console.log('alphabet', B, 'maxPal', maxPal, 'parts', total, 'bytes', JSON.stringify(lines).length);
