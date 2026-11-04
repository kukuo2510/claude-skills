# claude-skills

我自己寫、自己在用的 [Claude Code](https://claude.com/claude-code) skill。

## 安裝

把想要的 skill 資料夾複製到 `~/.claude/skills/` 底下，重開 Claude Code 就能用：

```powershell
git clone https://github.com/kukuo2510/claude-skills.git
Copy-Item -Recurse claude-skills\skills\screenshot "$env:USERPROFILE\.claude\skills\"
```

## Skill 清單

### [screenshot](skills/screenshot/)（Windows）

讓 Claude 自己截你的桌面來看，不用裝任何東西（只用內建的 PowerShell + .NET）。

- `/screenshot` 或說「截圖看一下」：截全部螢幕，多螢幕可以指定其中一個
- 「看我剛剛截的圖」：拿剪貼簿裡的圖，或 `Pictures\Screenshots` 最新一張（用 Win+Shift+S、PrtScn 截的圖不用另外存檔）
- 自動處理螢幕縮放（125%、150%），太寬的圖會縮到 1920 省 token
- 只能看，不能點擊或打字

## 授權

MIT
