# 截圖給 Claude 看。輸出存檔路徑（一行一個）。
# 用法：
#   capture.ps1                 截全部螢幕（每個螢幕一張）
#   capture.ps1 -Screen 1       只截第 1 個螢幕（從 1 開始數）
#   capture.ps1 -Mode clip      拿剪貼簿裡的圖
#   capture.ps1 -Mode latest    拿 Pictures\Screenshots 裡最新的一張
#   capture.ps1 -List           列出所有螢幕
param(
    [ValidateSet('screen', 'clip', 'latest')] [string]$Mode = 'screen',
    [int]$Screen = 0,
    [int]$MaxWidth = 1920,
    [switch]$List
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
# 讓座標以實際像素計算，不然有縮放（125%、150%）的螢幕會截不完整
Add-Type -Name Dpi -Namespace Win32 -MemberDefinition '[DllImport("user32.dll")] public static extern bool SetProcessDPIAware();'
[Win32.Dpi]::SetProcessDPIAware() | Out-Null

$outDir = Join-Path $env:TEMP 'claude-screenshots'
New-Item -ItemType Directory -Force $outDir | Out-Null
# 只留最近 20 張，避免越積越多
Get-ChildItem $outDir -File | Sort-Object LastWriteTime -Descending | Select-Object -Skip 20 | Remove-Item -Force

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Save-Scaled([System.Drawing.Image]$img, [string]$path) {
    # 太寬的圖縮小，省 token 也比較好讀
    if ($MaxWidth -gt 0 -and $img.Width -gt $MaxWidth) {
        $h = [int]($img.Height * $MaxWidth / $img.Width)
        $small = New-Object System.Drawing.Bitmap $MaxWidth, $h
        $g = [System.Drawing.Graphics]::FromImage($small)
        $g.InterpolationMode = 'HighQualityBicubic'
        $g.DrawImage($img, 0, 0, $MaxWidth, $h)
        $g.Dispose()
        $small.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
        $small.Dispose()
    } else {
        $img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    $path
}

$screens = [System.Windows.Forms.Screen]::AllScreens

if ($List) {
    $i = 1
    foreach ($s in $screens) {
        $b = $s.Bounds
        "螢幕 $i：$($b.Width)x$($b.Height)，位置 ($($b.X),$($b.Y))$(if ($s.Primary) { '，主螢幕' })"
        $i++
    }
    return
}

switch ($Mode) {
    'clip' {
        $img = [System.Windows.Forms.Clipboard]::GetImage()
        if (-not $img) { Write-Error '剪貼簿裡沒有圖片' }
        Save-Scaled $img (Join-Path $outDir "clip-$stamp.png")
        $img.Dispose()
    }
    'latest' {
        $f = Get-ChildItem (Join-Path $env:USERPROFILE 'Pictures\Screenshots') -File -Include *.png, *.jpg -Recurse |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $f) { Write-Error 'Pictures\Screenshots 裡沒有截圖' }
        "$($f.FullName)（截於 $($f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))）"
    }
    'screen' {
        $targets = if ($Screen -gt 0) {
            if ($Screen -gt $screens.Count) { Write-Error "只有 $($screens.Count) 個螢幕" }
            , @($screens[$Screen - 1])
        } else { $screens }
        $i = if ($Screen -gt 0) { $Screen } else { 1 }
        foreach ($s in $targets) {
            $b = $s.Bounds
            $bmp = New-Object System.Drawing.Bitmap $b.Width, $b.Height
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            $g.CopyFromScreen($b.Location, [System.Drawing.Point]::Empty, $b.Size)
            $g.Dispose()
            Save-Scaled $bmp (Join-Path $outDir "screen$i-$stamp.png")
            $bmp.Dispose()
            $i++
        }
    }
}
