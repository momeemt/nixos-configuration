import path from 'node:path';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { createElement } from 'react';
import satori, { type FontWeight } from 'satori';
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

function fontPath(weight: FontWeight) {
  return path.join(
    notoSansJpRoot,
    'files',
    `noto-sans-jp-japanese-${weight}-normal.woff`
  );
}

function publicPath(src: string) {
  return path.join(process.cwd(), 'public', src.replace(/^\//, ''));
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

async function textImage({
  titleLines,
  descriptionLines,
  descriptionTop
}: {
  titleLines: string[];
  descriptionLines: string[];
  descriptionTop: number;
}) {
  const fontFamily = 'Noto Sans JP';
  const fontStyle = 'normal';
  const fonts = [
    {
      name: fontFamily,
      data: readFileSync(fontPath(400)),
      weight: 400 as const,
      style: fontStyle
    },
    {
      name: fontFamily,
      data: readFileSync(fontPath(500)),
      weight: 500 as const,
      style: fontStyle
    }
  ];
  const textNodes = [
    ...titleLines.map((line, index) =>
      createElement(
        'div',
        {
          key: `title-${index}`,
          style: {
            position: 'absolute',
            left: textX,
            top: titleTop + index * titleLineHeight,
            color: '#222',
            fontFamily,
            fontSize: titleSize,
            fontWeight: 500,
            lineHeight: 1
          }
        },
        line
      )
    ),
    ...descriptionLines.map((line, index) =>
      createElement(
        'div',
        {
          key: `description-${index}`,
          style: {
            position: 'absolute',
            left: textX + 2,
            top: descriptionTop + index * descriptionLineHeight,
            color: '#777',
            fontFamily,
            fontSize: descriptionSize,
            fontWeight: 400,
            lineHeight: 1
          }
        },
        line
      )
    )
  ];
  const svg = await satori(
    createElement(
      'div',
      {
        style: {
          position: 'relative',
          display: 'flex',
          width,
          height,
          backgroundColor: 'transparent'
        }
      },
      textNodes
    ),
    {
      width,
      height,
      fonts
    }
  );

  return sharp(Buffer.from(svg)).png().toBuffer();
}

function backgroundSvg() {
  return Buffer.from(`
    <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
      <rect width="${width}" height="${height}" fill="#eee"/>
      <rect x="40" y="40" width="1120" height="550" rx="34" fill="#fff"/>
      <rect x="694" y="90" width="420" height="420" rx="24" fill="#f7f7f7"/>
    </svg>
  `);
}

export async function generateOgImage({
  title,
  description,
  thumbnail
}: OgImageOptions) {
  const titleLines = wrap(title, 10, 4);
  const descriptionLines = description ? wrap(description, 20, 2) : [];
  const descriptionTop = titleTop + titleLines.length * titleLineHeight + 20;
  const renderedText = await textImage({
    titleLines,
    descriptionLines,
    descriptionTop
  });
  const thumbnailImage = await sharp(publicPath(thumbnail))
    .resize(420, 420, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();

  return sharp(backgroundSvg())
    .composite([
      { input: renderedText, left: 0, top: 0 },
      { input: thumbnailImage, left: 694, top: 90 }
    ])
    .png()
    .toBuffer();
}
