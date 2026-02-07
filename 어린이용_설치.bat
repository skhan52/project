@echo off
chcp 65001 >nul
cls

REM 🎨 어린이용 간편 설치 스크립트 (Windows용) 🚀
REM 이 스크립트는 프로그램을 자동으로 설치해줘요!

echo.
echo ╔══════════════════════════════════════════════════╗
echo ║   🎨 PDF를 파워포인트로 바꾸는 마법 프로그램   ║
echo ║      어린이용 간편 설치기 (Windows용) 🚀       ║
echo ╚══════════════════════════════════════════════════╝
echo.
echo 안녕! 👋 프로그램을 설치해볼까요?
echo.

REM 단계 1: Python 확인
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📍 단계 1: Python이 설치되어 있는지 확인하고 있어요...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python이 설치되어 있지 않아요!
    echo.
    echo Python을 먼저 설치해주세요:
    echo   🌐 https://www.python.org/downloads/
    echo.
    echo 설치할 때 "Add Python to PATH" 옵션을 꼭 체크하세요! ✅
    echo.
    echo 💡 부모님께 도움을 요청해보세요!
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo ✅ Python을 찾았어요! (%PYTHON_VERSION%) 🐍
echo.

REM 단계 2: Poppler 확인
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📍 단계 2: PDF 읽기 도구(Poppler)가 있는지 확인하고 있어요...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

where pdfinfo >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Poppler가 설치되어 있지 않아요!
    echo.
    echo Poppler를 설치하려면:
    echo   🌐 http://blog.alivate.com.au/poppler-windows/
    echo.
    echo 위 링크에서 Poppler를 다운로드하고 설치해주세요.
    echo 부모님께 도움을 요청하세요! 👨‍👩‍👧
    echo.
    echo ❌ Poppler 설치 후 다시 실행해주세요!
    pause
    exit /b 1
)

echo ✅ Poppler를 찾았어요! 📄
echo.

REM 단계 3: 가상환경 만들기
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📍 단계 3: 프로그램을 위한 특별한 공간을 만들고 있어요... 🏗️
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

if not exist "venv" (
    python -m venv venv
    if %errorlevel% neq 0 (
        echo ❌ 가상환경을 만드는데 실패했어요.
        echo 💡 부모님께 도움을 요청해보세요!
        pause
        exit /b 1
    )
    echo ✅ 특별한 공간(가상환경)을 만들었어요!
) else (
    echo ✅ 특별한 공간이 이미 있어요!
)
echo.

REM 단계 4: 가상환경 활성화
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📍 단계 4: 특별한 공간으로 들어가고 있어요... 🚪
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

call venv\Scripts\activate.bat
echo ✅ 특별한 공간으로 들어왔어요!
echo.

REM 단계 5: pip 업그레이드
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📍 단계 5: 도구들을 최신 버전으로 업데이트하고 있어요... 🔧
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

python -m pip install --quiet --upgrade pip
echo ✅ 도구 업데이트 완료!
echo.

REM 단계 6: 패키지 설치
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📍 단계 6: 프로그램이 필요한 부품들을 설치하고 있어요... 📦
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo ⏳ 이 단계는 시간이 좀 걸릴 수 있어요 (5-10분).
echo 🍪 잠깐 쉬면서 쿠키라도 먹으면서 기다려봐요!
echo.

pip install -r requirements.txt

if %errorlevel% neq 0 (
    echo.
    echo ❌ 부품 설치 중 문제가 생겼어요.
    echo 💡 인터넷 연결을 확인하고 다시 시도해보세요!
    pause
    exit /b 1
)

echo ✅ 모든 부품 설치 완료!
echo.

REM 완료 메시지
echo.
echo ╔══════════════════════════════════════════════════╗
echo ║          🎉 축하합니다! 설치 완료! 🎉          ║
echo ╚══════════════════════════════════════════════════╝
echo.
echo 이제 프로그램을 사용할 수 있어요! 🚀
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📝 프로그램을 실행하는 방법:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 1️⃣  다음 명령어를 입력하세요:
echo     python app.py
echo.
echo 2️⃣  인터넷 브라우저를 열고 주소창에 입력하세요:
echo     http://localhost:5000
echo.
echo 3️⃣  PDF 파일을 드래그해서 변환하세요! 🎨
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 💡 도움이 필요하면 '어린이용_설치가이드.md' 파일을 읽어보세요!
echo.
echo 즐거운 시간 되세요! 화이팅! 💪✨
echo.
pause
