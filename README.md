# PDF to PPTX Converter with OCR

OCR 기술을 활용하여 PDF 형식의 이미지 슬라이드를 PowerPoint(PPTX) 파일로 변환하는 웹 애플리케이션입니다.

## 주요 기능

- 📄 **PDF to PPTX 변환**: PDF 파일을 PowerPoint 형식으로 변환
- 🔍 **OCR 텍스트 인식**: PaddleOCR 3.0을 사용한 정확한 한글/영문 텍스트 추출
- 📐 **레이아웃 유지**: 원본 텍스트의 위치와 크기를 정확하게 보존
- 🖼️ **이미지 보존**: 텍스트 이외의 이미지 요소는 그대로 유지
- 🌐 **웹 기반 인터페이스**: 브라우저에서 쉽게 접근 가능한 사용자 친화적 UI
- ⚡ **드래그 앤 드롭**: 파일을 드래그하여 간편하게 업로드

## 기술 스택

- **Backend**: Flask (Python)
- **OCR Engine**: PaddleOCR 2.9.1 with PaddlePaddle 3.3.0
- **PDF Processing**: pdf2image
- **PPTX Generation**: python-pptx
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)

## 보안

⚠️ **중요**: 프로덕션 환경에서 사용하기 전에 [SECURITY.md](SECURITY.md) 문서를 반드시 확인하세요.

- ✅ 모든 의존성이 최신 보안 버전으로 업데이트됨
- ✅ PaddlePaddle 3.3.0 (이전 버전의 보안 취약점 해결)
- ✅ 디버그 모드 기본적으로 비활성화
- ✅ 파일 자동 정리 (1시간 후)
- ⚠️ 프로덕션 사용 시 추가 보안 레이어 필요 (인증, HTTPS, 방화벽 등)

## 시스템 요구사항

- Python 3.8 이상
- Poppler (PDF 변환을 위한 시스템 라이브러리)
- 최소 4GB RAM (OCR 처리를 위해)

## 설치 방법

### 1. 시스템 의존성 설치

#### Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y poppler-utils
```

#### macOS:
```bash
brew install poppler
```

#### Windows:
- Poppler for Windows를 다운로드하여 설치: http://blog.alivate.com.au/poppler-windows/
- 환경 변수 PATH에 poppler의 bin 디렉토리 추가

### 2. Python 패키지 설치

```bash
# 가상환경 생성 (권장)
python -m venv venv

# 가상환경 활성화
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
```

## 사용 방법

### 방법 1: Docker 사용 (권장)

가장 쉬운 방법입니다. Docker가 설치되어 있다면:

```bash
# 이미지 빌드 및 실행
docker-compose up -d

# 또는 Docker만 사용
docker build -t pdf-converter .
docker run -p 5000:5000 pdf-converter
```

서버가 시작되면 `http://localhost:5000`에서 접근할 수 있습니다.

### 방법 2: 직접 실행

### 1. 서버 실행

```bash
python app.py
```

서버가 시작되면 `http://localhost:5000`에서 접근할 수 있습니다.

**개발 모드로 실행 (디버깅)**:
```bash
export FLASK_DEBUG=1  # Windows: set FLASK_DEBUG=1
python app.py
```

**주의**: 프로덕션 환경에서는 절대 디버그 모드를 사용하지 마세요!

### 2. 웹 인터페이스 사용

1. 웹 브라우저에서 `http://localhost:5000` 접속
2. PDF 파일을 업로드 영역에 드래그하거나 "파일 선택" 버튼 클릭
3. "변환 시작" 버튼을 클릭하여 변환 진행
4. 변환 완료 후 "PPTX 다운로드" 버튼으로 파일 다운로드

### 3. API 사용 (선택사항)

직접 API를 호출하여 사용할 수도 있습니다:

```bash
curl -X POST -F "file=@your_file.pdf" http://localhost:5000/api/upload
```

## 프로젝트 구조

```
project/
├── app.py                  # Flask 백엔드 서버
├── requirements.txt        # Python 의존성
├── templates/
│   └── index.html         # 메인 웹 페이지
├── static/
│   ├── css/
│   │   └── style.css      # 스타일시트
│   └── js/
│       └── main.js        # 프론트엔드 로직
├── uploads/               # 업로드된 PDF 임시 저장소
└── outputs/               # 변환된 PPTX 출력 저장소
```

## 작동 원리

1. **PDF 업로드**: 사용자가 PDF 파일을 웹 인터페이스를 통해 업로드
2. **이미지 변환**: pdf2image를 사용하여 각 PDF 페이지를 고해상도 이미지로 변환 (300 DPI)
3. **OCR 처리**: PaddleOCR이 각 이미지에서 텍스트를 인식하고 위치/크기 정보 추출
4. **PPTX 생성**: 
   - 각 페이지를 새 슬라이드로 생성
   - 원본 이미지를 배경으로 설정
   - OCR로 인식된 텍스트를 정확한 위치에 텍스트박스로 배치
   - 폰트 크기를 원본과 유사하게 조정
5. **다운로드**: 완성된 PPTX 파일을 사용자에게 제공

## 제한사항

- 최대 파일 크기: 50MB
- 지원 형식: PDF만 가능
- OCR 정확도는 원본 이미지 품질에 따라 달라질 수 있음
- 복잡한 레이아웃의 경우 완벽한 재현이 어려울 수 있음

## 문제 해결

### PaddleOCR 설치 오류
```bash
pip install paddlepaddle==2.6.0 -i https://mirror.baidu.com/pypi/simple
pip install paddleocr==2.7.3
```

### Poppler 관련 오류
- `pdf2image.exceptions.PDFInfoNotInstalledError` 발생 시 Poppler 설치 확인

### 메모리 부족 오류
- 대용량 PDF의 경우 DPI를 낮춰서 처리 (app.py에서 `dpi=300`을 `dpi=150`으로 변경)

## 라이선스

MIT License

## 기여

이슈 제보 및 풀 리퀘스트를 환영합니다!

## 관련 링크

- [PaddleOCR GitHub](https://github.com/PaddlePaddle/PaddleOCR)
- [python-pptx Documentation](https://python-pptx.readthedocs.io/)
- [pdf2image Documentation](https://github.com/Belval/pdf2image)
