let selectedFile = null;
let outputFilename = null;

// Get elements
const uploadArea = document.getElementById('uploadArea');
const fileInput = document.getElementById('fileInput');
const fileInfo = document.getElementById('fileInfo');
const fileName = document.getElementById('fileName');
const fileSize = document.getElementById('fileSize');
const convertBtn = document.getElementById('convertBtn');
const progressSection = document.getElementById('progressSection');
const progressFill = document.getElementById('progressFill');
const progressText = document.getElementById('progressText');
const resultSection = document.getElementById('resultSection');

// Drag and drop events
uploadArea.addEventListener('dragover', (e) => {
    e.preventDefault();
    uploadArea.classList.add('dragover');
});

uploadArea.addEventListener('dragleave', () => {
    uploadArea.classList.remove('dragover');
});

uploadArea.addEventListener('drop', (e) => {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
    
    const files = e.dataTransfer.files;
    if (files.length > 0) {
        handleFileSelect(files[0]);
    }
});

// File input change
fileInput.addEventListener('change', (e) => {
    if (e.target.files.length > 0) {
        handleFileSelect(e.target.files[0]);
    }
});

// Handle file selection
function handleFileSelect(file) {
    if (!file.name.toLowerCase().endsWith('.pdf')) {
        alert('PDF 파일만 업로드할 수 있습니다.');
        return;
    }
    
    if (file.size > 50 * 1024 * 1024) {
        alert('파일 크기는 50MB를 초과할 수 없습니다.');
        return;
    }
    
    selectedFile = file;
    
    // Show file info
    fileName.textContent = file.name;
    fileSize.textContent = formatFileSize(file.size);
    
    uploadArea.style.display = 'none';
    fileInfo.style.display = 'flex';
    convertBtn.style.display = 'block';
}

// Remove file
function removeFile() {
    selectedFile = null;
    fileInput.value = '';
    
    uploadArea.style.display = 'block';
    fileInfo.style.display = 'none';
    convertBtn.style.display = 'none';
}

// Convert file
async function convertFile() {
    if (!selectedFile) {
        alert('파일을 선택해주세요.');
        return;
    }
    
    // Hide convert button and show progress
    convertBtn.style.display = 'none';
    progressSection.style.display = 'block';
    progressFill.style.width = '0%';
    
    const formData = new FormData();
    formData.append('file', selectedFile);
    
    try {
        // Simulate progress
        let progress = 0;
        const progressInterval = setInterval(() => {
            progress += 5;
            if (progress <= 90) {
                progressFill.style.width = progress + '%';
            }
        }, 300);
        
        const response = await fetch('/api/upload', {
            method: 'POST',
            body: formData
        });
        
        clearInterval(progressInterval);
        
        const data = await response.json();
        
        if (response.ok && data.success) {
            progressFill.style.width = '100%';
            outputFilename = data.output_file;
            
            setTimeout(() => {
                progressSection.style.display = 'none';
                resultSection.style.display = 'block';
            }, 500);
        } else {
            throw new Error(data.error || '변환 중 오류가 발생했습니다.');
        }
    } catch (error) {
        alert('오류: ' + error.message);
        progressSection.style.display = 'none';
        convertBtn.style.display = 'block';
    }
}

// Download file
function downloadFile() {
    if (outputFilename) {
        window.location.href = `/api/download/${outputFilename}`;
    }
}

// Reset form
function resetForm() {
    selectedFile = null;
    outputFilename = null;
    fileInput.value = '';
    
    uploadArea.style.display = 'block';
    fileInfo.style.display = 'none';
    convertBtn.style.display = 'none';
    progressSection.style.display = 'none';
    resultSection.style.display = 'none';
}

// Format file size
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}
