@echo off
chcp 65001 >nul
echo ====================================
echo  微生物学复习 - 一键部署脚本
echo ====================================
echo.

:: 设置变量
set "REPO_URL=https://github.com/Nqn7m1-010/microbiology-review.git"
set "WORK_DIR=C:\Users\32237\Desktop\微生物复习\微生物学"

cd /d "%WORK_DIR%"
echo 📁 当前目录: %CD%
echo.

:: 检查 git 是否安装
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 未检测到 Git，请先安装: https://git-scm.com/
    pause
    exit /b 1
)
echo ✅ Git 已安装
echo.

:: 初始化仓库（如果还没有）
if not exist ".git" (
    echo 📦 初始化 Git 仓库...
    git init
    git checkout -b main
)

:: 复制文件为 index.html
echo 📝 准备 index.html...
copy "微生物学复习软件.html" "index.html" >nul

:: 创建 GitHub Actions 工作流
echo 🔧 创建自动部署配置...
if not exist ".github\workflows" mkdir ".github\workflows"

(
echo name: Deploy to GitHub Pages
echo on:
echo   push:
echo     branches: [main]
echo jobs:
echo   deploy:
echo     runs-on: ubuntu-latest
echo     permissions:
echo       contents: read
echo       pages: write
echo       id-token: write
echo     environment:
echo       name: github-pages
echo       url: ${{ steps.deployment.outputs.page_url }}
echo     steps:
echo       - uses: actions/checkout@v4
echo       - uses: actions/configure-pages@v4
echo       - uses: actions/upload-pages-artifact@v3
echo         with:
echo           path: .
echo       - id: deployment
echo         uses: actions/deploy-pages@v4
) > ".github\workflows\deploy.yml"

echo ✅ 配置文件已创建
echo.

:: 添加远程仓库
echo 🔗 配置远程仓库...
git remote remove origin 2>nul
git remote add origin "%REPO_URL%"

:: 添加并提交
echo 📤 提交文件到 GitHub...
git add index.html .github/workflows/deploy.yml
git commit -m "自动部署: 复习系统 + CI/CD"

:: 推送
echo 🚀 推送到 GitHub...
git push -u origin main --force

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ 部署成功！
    echo.
    echo 🌐 访问地址:
    echo https://nqn7m1-010.github.io/microbiology-review/
    echo.
    echo 📌 后续只需编辑保存 微生物学复习软件.html，然后运行本脚本即可自动更新
) else (
    echo.
    echo ⚠️ 推送失败，请检查：
    echo 1. GitHub 仓库是否存在: https://github.com/Nqn7m1-010/microbiology-review
    echo 2. 是否有写入权限
    echo 3. 尝试手动运行: git push -u origin main
)

echo.
pause
