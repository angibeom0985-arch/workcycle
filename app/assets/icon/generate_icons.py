from PIL import Image, ImageDraw, ImageFont
import os

# 아이콘 크기
SIZE = 1024

def create_app_icon():
    """메인 앱 아이콘 생성"""
    img = Image.new('RGB', (SIZE, SIZE), color='#2563EB')
    draw = ImageDraw.Draw(img)
    
    # 달력 아이콘
    icon_size = int(SIZE * 0.6)
    left = (SIZE - icon_size) // 2
    top = (SIZE - icon_size) // 2 + 30
    
    # 달력 배경 (흰색)
    draw.rounded_rectangle(
        [(left, top), (left + icon_size, top + icon_size - 30)],
        radius=30,
        fill='white'
    )
    
    # 달력 헤더 (빨간색)
    header_height = int(icon_size * 0.25)
    draw.rounded_rectangle(
        [(left, top), (left + icon_size, top + header_height)],
        radius=30,
        fill='#ef4444'
    )
    draw.rectangle(
        [(left, top + 20), (left + icon_size, top + header_height)],
        fill='#ef4444'
    )
    
    # 달력 링 (빨간색)
    ring_width = 40
    ring_height = 60
    ring_y = top - 30
    
    # 왼쪽 링
    draw.rounded_rectangle(
        [(left + icon_size//3 - ring_width//2, ring_y), 
         (left + icon_size//3 + ring_width//2, ring_y + ring_height)],
        radius=10,
        fill='#ef4444'
    )
    
    # 오른쪽 링
    draw.rounded_rectangle(
        [(left + 2*icon_size//3 - ring_width//2, ring_y), 
         (left + 2*icon_size//3 + ring_width//2, ring_y + ring_height)],
        radius=10,
        fill='#ef4444'
    )
    
    # 날짜 텍스트
    try:
        font = ImageFont.truetype("arial.ttf", 120)
    except:
        font = ImageFont.load_default()
    
    text = "15"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    text_x = SIZE // 2 - text_width // 2
    text_y = SIZE // 2 + 50 - text_height // 2
    draw.text((text_x, text_y), text, fill='#1f2937', font=font)
    
    # 교대 근무 표시
    symbol_y = SIZE // 2 + 200
    symbol_size = 40
    
    # 주간 (노란색)
    draw.ellipse(
        [(SIZE//2 - 120 - symbol_size, symbol_y - symbol_size),
         (SIZE//2 - 120 + symbol_size, symbol_y + symbol_size)],
        fill='#fbbf24'
    )
    
    # 야간 (남색)
    draw.ellipse(
        [(SIZE//2 + 120 - symbol_size, symbol_y - symbol_size),
         (SIZE//2 + 120 + symbol_size, symbol_y + symbol_size)],
        fill='#4f46e5'
    )
    
    return img

def create_foreground_icon():
    """Adaptive 아이콘 foreground 생성"""
    img = Image.new('RGBA', (SIZE, SIZE), color=(0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 달력 아이콘
    icon_size = int(SIZE * 0.7)
    left = (SIZE - icon_size) // 2
    top = (SIZE - icon_size) // 2 + 30
    
    # 달력 배경 (흰색)
    draw.rounded_rectangle(
        [(left, top), (left + icon_size, top + icon_size - 30)],
        radius=30,
        fill='white'
    )
    
    # 달력 헤더 (빨간색)
    header_height = int(icon_size * 0.25)
    draw.rounded_rectangle(
        [(left, top), (left + icon_size, top + header_height)],
        radius=30,
        fill='#ef4444'
    )
    draw.rectangle(
        [(left, top + 20), (left + icon_size, top + header_height)],
        fill='#ef4444'
    )
    
    # 달력 링 (빨간색)
    ring_width = 45
    ring_height = 70
    ring_y = top - 40
    
    # 왼쪽 링
    draw.rounded_rectangle(
        [(left + icon_size//3 - ring_width//2, ring_y), 
         (left + icon_size//3 + ring_width//2, ring_y + ring_height)],
        radius=10,
        fill='#ef4444'
    )
    
    # 오른쪽 링
    draw.rounded_rectangle(
        [(left + 2*icon_size//3 - ring_width//2, ring_y), 
         (left + 2*icon_size//3 + ring_width//2, ring_y + ring_height)],
        radius=10,
        fill='#ef4444'
    )
    
    # 날짜 텍스트
    try:
        font = ImageFont.truetype("arial.ttf", 140)
    except:
        font = ImageFont.load_default()
    
    text = "15"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    text_x = SIZE // 2 - text_width // 2
    text_y = SIZE // 2 + 50 - text_height // 2
    draw.text((text_x, text_y), text, fill='#1f2937', font=font)
    
    # 교대 근무 표시
    symbol_y = SIZE // 2 + 220
    symbol_size = 45
    
    # 주간 (노란색)
    draw.ellipse(
        [(SIZE//2 - 130 - symbol_size, symbol_y - symbol_size),
         (SIZE//2 - 130 + symbol_size, symbol_y + symbol_size)],
        fill='#fbbf24'
    )
    
    # 야간 (남색)
    draw.ellipse(
        [(SIZE//2 + 130 - symbol_size, symbol_y - symbol_size),
         (SIZE//2 + 130 + symbol_size, symbol_y + symbol_size)],
        fill='#4f46e5'
    )
    
    return img

# 아이콘 생성 및 저장
if __name__ == '__main__':
    # 메인 아이콘
    icon = create_app_icon()
    icon.save('app_icon.png', 'PNG')
    print('✅ app_icon.png 생성 완료!')
    
    # Foreground 아이콘
    foreground = create_foreground_icon()
    foreground.save('app_icon_foreground.png', 'PNG')
    print('✅ app_icon_foreground.png 생성 완료!')
    
    print('\n📱 아이콘 생성이 완료되었습니다!')
    print('이제 다음 명령어를 실행하세요:')
    print('  dart run flutter_launcher_icons')
