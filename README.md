# claude-skills

**English** | [繁體中文](README.zh-TW.md)

[Claude Code](https://claude.com/claude-code) skills I wrote and use myself.

## Install

Copy the skill folder you want into `~/.claude/skills/`, then restart Claude Code:

```powershell
git clone https://github.com/kukuo2510/claude-skills.git
Copy-Item -Recurse claude-skills\skills\screenshot "$env:USERPROFILE\.claude\skills\"
```

## Skills

### [screenshot](skills/screenshot/) (Windows)

Lets Claude take a screenshot of your desktop and look at it. Nothing to install: it only uses the built-in PowerShell and .NET.

- `/screenshot` or "take a screenshot": captures every monitor, or one monitor you pick
- "look at the screenshot I just took": reads the image on the clipboard, or the newest file in `Pictures\Screenshots`. Screenshots taken with Win+Shift+S or PrtScn work without saving them first
- Handles display scaling (125%, 150%), and shrinks wide images to 1920 px to save tokens
- View only: it cannot click or type

> The skill's instructions are written in Traditional Chinese. Claude understands them fine, and it replies in whatever language you use.

## License

MIT
