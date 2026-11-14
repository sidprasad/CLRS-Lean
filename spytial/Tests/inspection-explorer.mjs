import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const dependency = path.join(root, '.lake/packages/spytialLean');
const load = relative => import(pathToFileURL(path.join(dependency, relative)).href);
const { leanDocument, expandExplorer, settled } = await load('render/infoview-test.mjs');
const { correspondingAtoms } = await load('widget/dist/inspection.js');
const { chromium } = await load('render/node_modules/@playwright/test/index.mjs');
const file = 'src/CLRSLean/FourthEdition/Chapter_13/Section_13_1_Red_Black_Trees.lean';
const text = fs.readFileSync(path.join(root, file), 'utf8');
const lines = text.split('\n');
const headerLine = lines.findIndex(l => l.includes('theorem redBlackShape_repaint_rotateLeft_red_red'));
process.chdir(root);
const doc = await leanDocument(file, text);
let browser;
try {
  const [header] = await doc.widgets(headerLine);
  assert.ok(header?.props.explorer, JSON.stringify(doc.diagnostics));
  const points = header.props.explorer.points;
  assert.deepEqual(points.map(p => p.inspection.term), ['input', 'rotated', 'repaired']);
  assert.deepEqual(points.map(p => p.point.title), [null, 'After rotation', 'After repaint']);
  const repaintLine = lines.findIndex(l => l.includes('theorem noRedRed_repaint_black'));
  const [repaint] = await doc.widgets(repaintLine);
  assert.equal(repaint.props.explorer.points.length, 1);
  const repaintPoint = repaint.props.explorer.points[0];
  assert.ok(repaintPoint.inspection.facts.some(f => f.includes('left') && f.includes('NoRedRed')));
  assert.ok(repaintPoint.inspection.facts.some(f => f.includes('right') && f.includes('NoRedRed')));
  assert.ok(!repaintPoint.cndSpec.includes('✓'));
  assert.equal(await doc.source(header, headerLine),
    fs.readFileSync(path.join(dependency, '.lake/build/js/spytialWidget.js'), 'utf8'));
  for (let i = 0; i < points.length; i++) {
    const line = lines.findIndex(l => l.includes(['spytial input', 'spytial rotated', 'spytial repaired'][i]));
    const widgets = await doc.widgets(line);
    assert.equal(widgets.length, 1);
    assert.deepEqual(widgets[0].props, points[i]);
  }
  const bAtoms = points.map(p => p.dataInstance.atoms.find(a => a.label === 'b').id);
  assert.notEqual(bAtoms[0], bAtoms[2]);
  assert.ok(correspondingAtoms(points[0], points[2]).some(m =>
    m.previous === bAtoms[0] && m.current === bAtoms[2]));
  assert.ok(points.every(p => p.inspection.facts.length &&
    p.localContext.some(d => d.name === 'hab') && p.observations.length));
  browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1300, height: 1100 } });
  const errors = [];
  page.on('pageerror', e => errors.push(e.stack ?? e.message));
  await page.setContent('<html><body><div id="root"></div></body></html>');
  await page.evaluate(props => { window.__CASE__ = props; }, header.props);
  await page.addScriptTag({ path: path.join(dependency, 'render/dist/harness.js') });
  await expandExplorer(page, 3);
  await settled(page, 2);
  assert.equal(await page.getByLabel('Left inspection point').inputValue(), '0');
  assert.equal(await page.getByLabel('Right inspection point').inputValue(), '2');
  await page.getByLabel('Right inspection point').selectOption('1');
  await settled(page, 2);
  await page.getByRole('button', { name: 'Step through', exact: true }).click();
  await settled(page, 1);
  await page.getByRole('button', { name: 'Next', exact: true }).click();
  await settled(page, 1);
  assert.equal(await page.getByLabel('Inspection point', { exact: true }).inputValue(), '1');
  await page.getByRole('button', { name: 'All points', exact: true }).click();
  await settled(page, 3);
  const states = await page.locator('webcola-cnd-graph').evaluateAll(gs => gs.map(g => ({
    layout: g.getLayoutState(), seed: g.getLastSeedState?.(),
  })));
  for (let i = 0; i < points.length; i++) {
    const positions = new Map(states[i].layout.positions.map(p => [p.id, p]));
    for (const relation of points[i].dataInstance.relations.filter(r =>
      ['node_1', 'node_3'].includes(r.name))) for (const { atoms: [parent, child] } of relation.tuples) {
      if (!positions.has(parent) || !positions.has(child)) continue;
      const p = positions.get(parent), c = positions.get(child);
      assert.ok(c.y > p.y);
      assert.ok(relation.name === 'node_1' ? c.x < p.x : c.x > p.x);
    }
  }
  const prior = states[0].layout.positions.find(p => p.id === bAtoms[0]);
  const seed = states[2].seed.positions.find(p => p.id === bAtoms[2]);
  assert.equal(seed.x, prior.x);
  assert.equal(seed.y, prior.y);
  assert.deepEqual(errors, []);
  assert.deepEqual(await page.evaluate(() => window.__spytialEvents.filter(e =>
    ['constraint-error', 'layout-generation-error'].includes(e))), []);
  assert.deepEqual(doc.diagnostics.flatMap(d => d.diagnostics).filter(d => d.severity === 1), []);
  await page.screenshot({ path: path.join(root, '.lake/rotation-explorer.png'), fullPage: true });
  fs.writeFileSync(path.join(root, '.lake/rotation-explorer.json'), JSON.stringify(header.props, null, 2));
  console.log(`Actual CLRS-Lean file and installed Spytial-Lean passed: collapsed disclosure, theorem + line widgets, captions, comparison/step/all controls, b ${bAtoms.join(' → ')}, identity seeds and tree constraints.`);
} finally { await browser?.close(); doc.close(); }
