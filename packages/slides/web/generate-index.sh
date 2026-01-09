#!/bin/bash
# Generate index.html with slide thumbnails
# Usage: ./generate-index.sh <dist_dir>

DIST_DIR="${1:-.}"

cat > "$DIST_DIR/index.html" << 'HEADER'
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Slides - momeemt</title>
  <style>
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
      background: #f5f5f5;
    }
    h1 { color: #333; margin-bottom: 1.5rem; }
    .slides {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 1.5rem;
    }
    .slide-card {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      overflow: hidden;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .slide-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 16px rgba(0,0,0,0.15);
    }
    .slide-thumbnail {
      width: 100%;
      aspect-ratio: 16 / 9;
      object-fit: contain;
      background: #2a2a2a;
      display: block;
    }
    .slide-info {
      padding: 1rem;
    }
    .slide-name {
      font-weight: 600;
      color: #333;
      margin-bottom: 0.75rem;
      font-size: 0.95rem;
      word-break: break-all;
    }
    .slide-actions {
      display: flex;
      gap: 0.5rem;
    }
    .btn {
      padding: 0.4rem 1rem;
      border-radius: 6px;
      font-size: 0.85rem;
      text-decoration: none;
      text-align: center;
      flex: 1;
    }
    .btn-view { background: #4a7c9c; color: white; }
    .btn-view:hover { background: #3a6c8c; }
    .btn-download { background: #666; color: white; }
    .btn-download:hover { background: #555; }
  </style>
</head>
<body>
  <h1>Slides</h1>
  <div class="slides">
HEADER

# Generate slide cards
for pdf in "$DIST_DIR"/*.pdf; do
  [ -f "$pdf" ] || continue
  name=$(basename "$pdf" .pdf)
  cat >> "$DIST_DIR/index.html" << CARD
    <div class="slide-card">
      <a href="/viewer.html?pdf=${name}.pdf">
        <img class="slide-thumbnail" src="/thumbnails/${name}.png" alt="${name}" loading="lazy">
      </a>
      <div class="slide-info">
        <div class="slide-name">${name}</div>
        <div class="slide-actions">
          <a class="btn btn-view" href="/viewer.html?pdf=${name}.pdf">View</a>
          <a class="btn btn-download" href="/${name}.pdf" download>Download</a>
        </div>
      </div>
    </div>
CARD
done

cat >> "$DIST_DIR/index.html" << 'FOOTER'
  </div>
</body>
</html>
FOOTER
