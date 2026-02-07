#!/bin/bash

# 🎨 어린이용 간편 설치 스크립트 🚀
# 이 스크립트는 프로그램을 자동으로 설치해줘요!

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   🎨 PDF를 파워포인트로 바꾸는 마법 프로그램   ║"
echo "║           어린이용 간편 설치기 🚀              ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "안녕! 👋 프로그램을 설치해볼까요?"
echo ""

# 함수: 단계 표시
show_step() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📍 단계 $1: $2"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# 함수: 성공 메시지
show_success() {
    echo "✅ $1"
}

# 함수: 에러 메시지
show_error() {
    echo "❌ $1"
    echo "💡 부모님께 도움을 요청해보세요!"
}

# 단계 1: Python 확인
show_step "1" "Python이 설치되어 있는지 확인하고 있어요..."

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    show_success "Python을 찾았어요! ($PYTHON_VERSION) 🐍"
else
    show_error "Python이 설치되어 있지 않아요!"
    echo ""
    echo "Python을 먼저 설치해주세요:"
    echo "  🪟 Windows: https://www.python.org/downloads/"
    echo "  🍎 Mac: 터미널에서 'brew install python3' 또는 위 링크에서 다운로드"
    echo ""
    exit 1
fi

# 단계 2: Poppler 확인
show_step "2" "PDF 읽기 도구(Poppler)가 있는지 확인하고 있어요..."

if command -v pdfinfo &> /dev/null; then
    show_success "Poppler를 찾았어요! 📄"
else
    echo "⚠️  Poppler가 설치되어 있지 않아요!"
    echo ""
    echo "Poppler를 설치하려면:"
    echo ""
    
    # OS 감지
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "🐧 Linux 사용자:"
        echo "   다음 명령어를 실행해주세요:"
        echo "   sudo apt-get update"
        echo "   sudo apt-get install -y poppler-utils"
        echo ""
        read -p "지금 설치할까요? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt-get update
            sudo apt-get install -y poppler-utils
            show_success "Poppler 설치 완료!"
        else
            show_error "Poppler 설치가 필요해요!"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🍎 Mac 사용자:"
        echo "   터미널에서 다음 명령어를 실행해주세요:"
        echo "   brew install poppler"
        echo ""
        show_error "위 명령어로 Poppler를 설치한 후 다시 실행해주세요!"
        exit 1
    else
        echo "🪟 Windows 사용자:"
        echo "   http://blog.alivate.com.au/poppler-windows/"
        echo "   위 링크에서 Poppler를 다운로드하고 설치해주세요."
        echo "   부모님께 도움을 요청하세요! 👨‍👩‍👧"
        echo ""
        show_error "Poppler 설치 후 다시 실행해주세요!"
        exit 1
    fi
fi

# 단계 3: 가상환경 만들기
show_step "3" "프로그램을 위한 특별한 공간을 만들고 있어요... 🏗️"

if [ ! -d "venv" ]; then
    python3 -m venv venv
    if [ $? -eq 0 ]; then
        show_success "특별한 공간(가상환경)을 만들었어요!"
    else
        show_error "가상환경을 만드는데 실패했어요."
        exit 1
    fi
else
    show_success "특별한 공간이 이미 있어요!"
fi

# 단계 4: 가상환경 활성화
show_step "4" "특별한 공간으로 들어가고 있어요... 🚪"

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

show_success "특별한 공간으로 들어왔어요!"

# 단계 5: pip 업그레이드
show_step "5" "도구들을 최신 버전으로 업데이트하고 있어요... 🔧"

pip install --quiet --upgrade pip
show_success "도구 업데이트 완료!"

# 단계 6: 패키지 설치
show_step "6" "프로그램이 필요한 부품들을 설치하고 있어요... 📦"
echo "⏳ 이 단계는 시간이 좀 걸릴 수 있어요 (5-10분)."
echo "🍪 잠깐 쉬면서 쿠키라도 먹으면서 기다려봐요!"
echo ""

pip install -r requirements.txt

if [ $? -eq 0 ]; then
    show_success "모든 부품 설치 완료!"
else
    show_error "부품 설치 중 문제가 생겼어요."
    echo "💡 인터넷 연결을 확인하고 다시 시도해보세요!"
    exit 1
fi

# 완료 메시지
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║          🎉 축하합니다! 설치 완료! 🎉          ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "이제 프로그램을 사용할 수 있어요! 🚀"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 프로그램을 실행하는 방법:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1️⃣  다음 명령어를 입력하세요:"
echo "    python app.py"
echo ""
echo "2️⃣  인터넷 브라우저를 열고 주소창에 입력하세요:"
echo "    http://localhost:5000"
echo ""
echo "3️⃣  PDF 파일을 드래그해서 변환하세요! 🎨"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 도움이 필요하면 '어린이용_설치가이드.md' 파일을 읽어보세요!"
echo ""
echo "즐거운 시간 되세요! 화이팅! 💪✨"
echo ""
