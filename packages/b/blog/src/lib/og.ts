import path from 'node:path';
import sharp from 'sharp';

type OgImageOptions = {
  title: string;
  description?: string;
  thumbnail: string;
};

const width = 1200;
const height = 630;
const textX = 92;
const titleY = 166;
const titleSize = 54;
const titleLineHeight = 66;
const descriptionSize = 26;
const descriptionLineHeight = 38;
const fontFamily = 'Noto Sans JP, Hiragino Sans, Yu Gothic, Arial, sans-serif';

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

function textLines({
  lines,
  x,
  y,
  size,
  lineHeight,
  color,
  weight = 400
}: {
  lines: string[];
  x: number;
  y: number;
  size: number;
  lineHeight: number;
  color: string;
  weight?: number;
}) {
  return lines
    .map(
      (line, index) =>
        `<text x="${x}" y="${y + index * lineHeight}" fill="${color}" font-family="${fontFamily}" font-size="${size}" font-weight="${weight}">${escapeXml(line)}</text>`
    )
    .join('');
}

export async function generateOgImage({
  title,
  description,
  thumbnail
}: OgImageOptions) {
  const titleLines = wrap(title, 10, 4);
  const descriptionLines = description ? wrap(description, 20, 2) : [];
  const descriptionY = titleY + titleLines.length * titleLineHeight + 30;
  const thumbnailImage = await sharp(publicPath(thumbnail))
    .resize(420, 420, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();
  const svg = Buffer.from(`
    <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
      <rect width="${width}" height="${height}" fill="#eee"/>
      <rect x="40" y="40" width="1120" height="550" rx="34" fill="#fff"/>
      <rect x="694" y="90" width="420" height="420" rx="24" fill="#f7f7f7"/>
      ${textLines({ lines: titleLines, x: textX, y: titleY, size: titleSize, lineHeight: titleLineHeight, color: '#222', weight: 500 })}
      ${textLines({ lines: descriptionLines, x: textX + 2, y: descriptionY, size: descriptionSize, lineHeight: descriptionLineHeight, color: '#777' })}
    </svg>
  `);

  return sharp(svg)
    .composite([{ input: thumbnailImage, left: 694, top: 90 }])
    .png()
    .toBuffer();
}
