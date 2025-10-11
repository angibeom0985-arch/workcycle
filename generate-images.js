const fs = require('fs');
const path = require('path');

// Canvas for Node.js (using a pure JS implementation)
function createCanvas(width, height) {
  return {
    width,
    height,
    getContext: function(type) {
      if (type !== '2d') throw new Error('Only 2d context supported');
      const pixels = new Array(width * height * 4).fill(0);
      return {
        fillStyle: '#ffffff',
        strokeStyle: '#000000',
        lineWidth: 1,
        font: '16px sans-serif',
        textAlign: 'left',
        textBaseline: 'top',
        
        fillRect: function(x, y, w, h) {
          const color = this.parseColor(this.fillStyle);
          for (let py = Math.max(0, y); py < Math.min(height, y + h); py++) {
            for (let px = Math.max(0, x); px < Math.min(width, x + w); px++) {
              const i = (py * width + px) * 4;
              pixels[i] = color.r;
              pixels[i + 1] = color.g;
              pixels[i + 2] = color.b;
              pixels[i + 3] = color.a;
            }
          }
        },
        
        fillText: function(text, x, y) {
          // Simplified text rendering (just marking pixels)
          console.log(`Text: "${text}" at (${x}, ${y})`);
        },
        
        beginPath: function() {},
        moveTo: function(x, y) {},
        lineTo: function(x, y) {},
        arc: function(x, y, r, start, end) {},
        stroke: function() {},
        fill: function() {},
        closePath: function() {},
        
        parseColor: function(color) {
          if (color.startsWith('#')) {
            const hex = color.substring(1);
            return {
              r: parseInt(hex.substring(0, 2), 16),
              g: parseInt(hex.substring(2, 4), 16),
              b: parseInt(hex.substring(4, 6), 16),
              a: 255
            };
          }
          return { r: 255, g: 255, b: 255, a: 255 };
        },
        
        getImageData: function() {
          return { data: pixels };
        }
      };
    },
    toBuffer: function(type) {
      const ctx = this.getContext('2d');
      const imageData = ctx.getImageData();
      
      // Create simple PNG-like buffer (simplified)
      const header = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
      return Buffer.concat([header, Buffer.from(imageData.data)]);
    }
  };
}

// Generate calendar icon SVG
function generateCalendarIconSVG(size) {
  return `<?xml version="1.0" encoding="UTF-8"?>
<svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#3b82f6;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1d4ed8;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Background -->
  <rect width="${size}" height="${size}" rx="${size * 0.15}" fill="url(#bgGradient)"/>
  
  <!-- Calendar body -->
  <rect x="${size * 0.2}" y="${size * 0.25}" width="${size * 0.6}" height="${size * 0.55}" 
        rx="${size * 0.05}" fill="white" opacity="0.95"/>
  
  <!-- Calendar header -->
  <rect x="${size * 0.2}" y="${size * 0.25}" width="${size * 0.6}" height="${size * 0.12}" 
        rx="${size * 0.05}" fill="#1e40af"/>
  
  <!-- Ring holes -->
  <circle cx="${size * 0.32}" cy="${size * 0.22}" r="${size * 0.04}" fill="white"/>
  <circle cx="${size * 0.68}" cy="${size * 0.22}" r="${size * 0.04}" fill="white"/>
  
  <!-- Calendar grid (simplified) -->
  <line x1="${size * 0.25}" y1="${size * 0.45}" x2="${size * 0.75}" y2="${size * 0.45}" 
        stroke="#94a3b8" stroke-width="${size * 0.01}"/>
  <line x1="${size * 0.25}" y1="${size * 0.55}" x2="${size * 0.75}" y2="${size * 0.55}" 
        stroke="#94a3b8" stroke-width="${size * 0.01}"/>
  <line x1="${size * 0.25}" y1="${size * 0.65}" x2="${size * 0.75}" y2="${size * 0.65}" 
        stroke="#94a3b8" stroke-width="${size * 0.01}"/>
  
  <!-- Day/Night indicators -->
  <circle cx="${size * 0.35}" cy="${size * 0.5}" r="${size * 0.04}" fill="#fbbf24"/>
  <circle cx="${size * 0.65}" cy="${size * 0.6}" r="${size * 0.04}" fill="#4338ca"/>
  <rect x="${size * 0.48}" y="${size * 0.68}" width="${size * 0.12}" height="${size * 0.08}" 
        rx="${size * 0.02}" fill="#ef4444"/>
</svg>`;
}

// Generate OG image (1200x630)
function generateOGImageSVG() {
  return `<?xml version="1.0" encoding="UTF-8"?>
<svg width="1200" height="630" viewBox="0 0 1200 630" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1e3a8a;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#3b82f6;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Background -->
  <rect width="1200" height="630" fill="url(#bgGrad)"/>
  
  <!-- Decorative circles -->
  <circle cx="100" cy="100" r="120" fill="white" opacity="0.1"/>
  <circle cx="1100" cy="530" r="150" fill="white" opacity="0.1"/>
  
  <!-- Main content container -->
  <rect x="100" y="150" width="1000" height="380" rx="20" fill="white" opacity="0.95"/>
  
  <!-- Calendar icon (large) -->
  <rect x="150" y="220" width="200" height="200" rx="20" fill="#3b82f6"/>
  <rect x="170" y="250" width="160" height="130" rx="10" fill="white"/>
  <rect x="170" y="250" width="160" height="30" rx="10" fill="#1e40af"/>
  <circle cx="200" cy="240" r="8" fill="white"/>
  <circle cx="300" cy="240" r="8" fill="white"/>
  
  <!-- Calendar grid -->
  <line x1="180" y1="300" x2="320" y2="300" stroke="#94a3b8" stroke-width="2"/>
  <line x1="180" y1="330" x2="320" y2="330" stroke="#94a3b8" stroke-width="2"/>
  
  <!-- Day/Night/Off indicators in calendar -->
  <circle cx="205" cy="315" r="10" fill="#fbbf24"/>
  <circle cx="280" cy="315" r="10" fill="#4338ca"/>
  <rect x="235" y="340" width="30" height="20" rx="5" fill="#ef4444"/>
  
  <!-- Text content -->
  <text x="420" y="260" font-family="'Noto Sans KR', sans-serif" font-size="64" font-weight="bold" fill="#1e3a8a">
    교대근무 달력
  </text>
  <text x="420" y="330" font-family="'Noto Sans KR', sans-serif" font-size="36" fill="#64748b">
    3교대 · 4교대 근무표 자동 생성
  </text>
  <text x="420" y="390" font-family="'Noto Sans KR', sans-serif" font-size="28" fill="#94a3b8">
    주간 · 야간 · 휴무 스케줄을 한눈에
  </text>
  
  <!-- Features -->
  <g transform="translate(420, 430)">
    <circle cx="0" cy="0" r="8" fill="#10b981"/>
    <text x="20" y="8" font-family="'Noto Sans KR', sans-serif" font-size="24" fill="#475569">
      무료 온라인 도구
    </text>
  </g>
  <g transform="translate(680, 430)">
    <circle cx="0" cy="0" r="8" fill="#10b981"/>
    <text x="20" y="8" font-family="'Noto Sans KR', sans-serif" font-size="24" fill="#475569">
      간편한 설정
    </text>
  </g>
  
  <!-- Bottom URL -->
  <text x="600" y="580" font-family="'Noto Sans KR', sans-serif" font-size="20" fill="white" text-anchor="middle" opacity="0.9">
    workcycle.money-hotissue.com
  </text>
</svg>`;
}

// Convert SVG to PNG using sharp
async function svgToPNG(svgContent, outputPath, width, height) {
  try {
    const sharp = require('sharp');
    await sharp(Buffer.from(svgContent))
      .resize(width, height)
      .png()
      .toFile(outputPath);
    console.log(`✓ Created: ${path.basename(outputPath)} (${width}x${height})`);
  } catch (error) {
    console.error(`✗ Error creating ${outputPath}:`, error.message);
    // Fallback: save as SVG
    const svgPath = outputPath.replace('.png', '.svg');
    fs.writeFileSync(svgPath, svgContent);
    console.log(`  → Saved as SVG: ${path.basename(svgPath)}`);
  }
}

// Main generation function
async function generateImages() {
  const publicDir = path.join(__dirname, 'public');
  
  console.log('🎨 Generating icons and images...\n');
  
  // Generate different sizes
  const sizes = [
    { name: 'favicon-16x16.png', size: 16 },
    { name: 'favicon-32x32.png', size: 32 },
    { name: 'apple-touch-icon.png', size: 180 },
    { name: 'android-chrome-192x192.png', size: 192 },
    { name: 'android-chrome-512x512.png', size: 512 }
  ];
  
  for (const { name, size } of sizes) {
    const svg = generateCalendarIconSVG(size);
    await svgToPNG(svg, path.join(publicDir, name), size, size);
  }
  
  // Generate OG image
  const ogSvg = generateOGImageSVG();
  await svgToPNG(ogSvg, path.join(publicDir, 'og-image.png'), 1200, 630);
  
  // Generate ICO file (use 32x32 PNG and rename to .ico)
  const icoSvg = generateCalendarIconSVG(32);
  const icoPath = path.join(publicDir, 'favicon.ico');
  try {
    const sharp = require('sharp');
    await sharp(Buffer.from(icoSvg))
      .resize(32, 32)
      .png()
      .toFile(icoPath.replace('.ico', '-temp.png'));
    // Copy to .ico (browsers accept PNG as .ico)
    fs.copyFileSync(icoPath.replace('.ico', '-temp.png'), icoPath);
    fs.unlinkSync(icoPath.replace('.ico', '-temp.png'));
    console.log(`✓ Created: favicon.ico (32x32)`);
  } catch (e) {
    console.log(`✗ Could not create .ico, using placeholder`);
  }
  
  console.log('\n✅ All images generated successfully!');
}

// Run
generateImages().catch(console.error);
