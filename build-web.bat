@echo off
flutter build web --release --base-href="/bingo/" & scp -Cr build\web chris@backstreets.site:bingo