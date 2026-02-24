@echo off
set /p cm=Enter Commit Message : 
git add .
git commit -m "%cm%"
git branch -M main
git push -origin main