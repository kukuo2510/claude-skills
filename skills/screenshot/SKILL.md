---
name: screenshot
description: 截取使用者的 Windows 桌面畫面（或拿剪貼簿／最新一張快捷鍵截圖）給 Claude 看。當使用者說「/screenshot」「截圖看一下」「你看我的螢幕」「看我剛剛截的圖」，或任務需要看桌面程式、遊戲、錯誤視窗等瀏覽器以外的畫面時使用。網頁畫面優先用 claude-in-chrome。
---

# 截圖給 Claude 看

腳本：`~/.claude/skills/screenshot/capture.ps1`，每次輸出存好的圖片路徑（一行一個），再用 Read 打開那些路徑來看。

## 選哪種模式

| 使用者的意思 | 指令 |
|---|---|
| 「看我的螢幕」「截圖看一下」 | `powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\skills\screenshot\capture.ps1"` |
| 只看某個螢幕 | 先加 `-List` 看有幾個螢幕，再用 `-Screen 2` |
| 「看我剛剛截的圖」（用 Win+Shift+S 等快捷鍵截的） | 先試 `-Mode clip`（剪貼簿）；失敗再用 `-Mode latest`（Pictures\Screenshots 最新一張） |
| 需要看小字、細節 | 加 `-MaxWidth 0` 不縮圖（預設會縮到寬 1920） |

## 規則

- 只在使用者要求或當下任務確實需要時才截全螢幕；截圖會拍到所有視窗，可能包含私人內容。看到密碼、私訊、帳號資料等不相關的敏感內容，不要複述。
- `-Mode latest` 會回報截圖時間；如果明顯是很久以前的圖，先跟使用者確認是不是那張。
- 這個 skill 只能「看」，不能點擊或打字。
- 截圖存在 `%TEMP%\claude-screenshots\`，自動只留最近 20 張。
