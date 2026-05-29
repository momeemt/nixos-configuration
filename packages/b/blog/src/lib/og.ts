import path from 'node:path';
import { mkdirSync } from 'node:fs';
import { createRequire } from 'node:module';
import sharp from 'sharp';

type OgImageOptions = {
  title: string;
  description?: string;
  thumbnail: string;
};

const width = 1200;
const height = 630;
const textX = 92;
const titleTop = 124;
const titleSize = 54;
const titleLineHeight = 66;
const descriptionSize = 26;
const descriptionLineHeight = 38;
const require = createRequire(import.meta.url);
const notoSansJpRoot = path.dirname(require.resolve('@fontsource/noto-sans-jp/package.json'));
const fontConfigFile = path.join(process.cwd(), 'src/lib/fontconfig.conf');
const fontCacheDir = '/tmp/blog-og-fontconfig';

function fontPath(weight: 400 | 500) {
  return path.join(
    notoSansJpRoot,
    'files',
    `noto-sans-jp-japanese-${weight}-normal.woff2`
  );
}

function ensureFontConfig() {
  process.env.FONTCONFIG_FILE ??= fontConfigFile;
  process.env.XDG_CACHE_HOME ??= '/tmp';
  mkdirSync(fontCacheDir, { recursive: true });
}

function publicPath(src: string) {
  return path.join(process.cwd(), 'public', src.replace(/^\//, ''));
}

function escapeXml(value: string) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

function pangoSpan(value: string, color: string) {
  return `<span foreground="${color}">${escapeXml(value)}</span>`;
}

function score(value: string) {
  return Array.from(value).reduce((sum, char) => sum + (char.charCodeAt(0) < 128 ? 0.55 : 1), 0);
}

function trimTo(value: string, maxScore: number) {
  let output = value.trimEnd();

  while (score(`${output}...`) > maxScore && output.length > 0) {
    output = output.slice(0, -1);
  }

  return `${output.trimEnd()}...`;
}

function wrap(value: string, maxScore: number, maxLines: number) {
  const lines: string[] = [];
  let line = '';

  for (const char of Array.from(value.trim())) {
    if (char === '\n') {
      lines.push(line.trimEnd());
      line = '';
      continue;
    }

    const next = line + char;

    if (line && score(next) > maxScore) {
      lines.push(line.trimEnd());
      line = char.trimStart();
    } else {
      line = next;
    }
  }

  if (line) {
    lines.push(line.trimEnd());
  }

  if (lines.length <= maxLines) {
    return lines;
  }

  return [...lines.slice(0, maxLines - 1), trimTo(lines[maxLines - 1], maxScore)];
}

function textLayers({
  lines,
  x,
  top,
  size,
  lineHeight,
  color,
  weight = 400
}: {
  lines: string[];
  x: number;
  top: number;
  size: number;
  lineHeight: number;
  color: string;
  weight?: 400 | 500;
}) {
  return lines.map((line, index) => ({
    input: {
      text: {
        text: pangoSpan(line, color),
        font: `Noto Sans JP ${size}`,
        fontfile: fontPath(weight),
        dpi: 72,
        rgba: true
      }
    },
    left: x,
    top: top + index * lineHeight
  }));
}

export async function generateOgImage({
  title,
  description,
  thumbnail
}: OgImageOptions) {
  ensureFontConfig();
  const titleLines = wrap(title, 10, 4);
  const descriptionLines = description ? wrap(description, 20, 2) : [];
  const descriptionTop = titleTop + titleLines.length * titleLineHeight + 20;
  const thumbnailImage = await sharp(publicPath(thumbnail))
    .resize(420, 420, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();
  const svg = Buffer.from(`
    <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
      <rect width="${width}" height="${height}" fill="#eee"/>
      <rect x="40" y="40" width="1120" height="550" rx="34" fill="#fff"/>
      <rect x="694" y="90" width="420" height="420" rx="24" fill="#f7f7f7"/>
    </svg>
  `);

  return sharp(svg)
    .composite([
      ...textLayers({
        lines: titleLines,
        x: textX,
        top: titleTop,
        size: titleSize,
        lineHeight: titleLineHeight,
        color: '#222',
        weight: 500
      }),
      ...textLayers({
        lines: descriptionLines,
        x: textX + 2,
        top: descriptionTop,
        size: descriptionSize,
        lineHeight: descriptionLineHeight,
        color: '#777'
      }),
      { input: thumbnailImage, left: 694, top: 90 }
    ])
    .png()
    .toBuffer();
}
