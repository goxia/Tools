# WinPlusH-dotNet

这是一个极简的 C# .NET 控制台应用程序，用于模拟 Win+H 组合键激活 Windows 语音输入工具。

一个极简的 C# .NET 控制台应用程序，用于模拟 Win+H 组合键激活 Windows 语音输入工具。

## 特性

- 🔇 **静默运行** - 无控制台窗口，无输出
- 🎯 **单一功能** - 仅执行 Win+H 快捷键
- 📦 **极小体积** - 单文件可执行程序
- 🖊️ **笔按键适配** - 完美适用于 Windows Ink 笔按键配置

## 系统要求

- Windows 10/11
- .NET 6.0 Runtime 或更高版本

## 构建说明

### 选项 1: AnyCPU 可移植版本（推荐）
兼容 x64 和 ARM64，需要设备已安装 .NET 6+ Runtime：
```powershell
dotnet publish -c Release
```

### 选项 2: 架构特定单文件版本  
无需 .NET Runtime，但需为每个架构单独编译：
```powershell
# x64 版本
dotnet publish -c Release -r win-x64 --self-contained false /p:PublishSingleFile=true

# ARM64 版本  
dotnet publish -c Release -r win-arm64 --self-contained false /p:PublishSingleFile=true
```

### 方法 3: 批处理脚本
运行 `build-all.bat` 一次性构建所有版本

## 使用方法

### 直接运行
双击 `WinPlusH-dotNet.exe` 即可激活语音输入。

### Windows Ink 笔按键配置
1. 打开 Windows 设置 → 设备 → 笔和 Windows Ink
2. 选择笔按钮自定义
3. 选择"启动应用"
4. 浏览并选择 `WinPlusH-dotNet.exe`

## 技术实现

程序使用 Windows API (`user32.dll`) 中的 `keybd_event` 函数模拟键盘输入：
- 按下左 Windows 键 (VK_LWIN)
- 按下 H 键 (VK_H)  
- 按正确顺序释放按键
- 程序立即退出

## 项目结构

```
WinPlusH-dotNet/
├── Program.cs                # 主程序代码
├── WinPlusH-dotNet.csproj   # 项目配置
└── README.md                # 本文档
```

## 输出文件

### AnyCPU 可移植版本（推荐）
位置：`bin/Release/net6.0/publish/`
- **WinPlusH-dotNet.exe** (151KB) - 主程序，兼容 x64/ARM64
- 附带文件：WinPlusH-dotNet.dll, .deps.json, .runtimeconfig.json
- **优点**：一个版本兼容所有架构
- **要求**：设备需安装 .NET 6+ Runtime

### 架构特定单文件版本
- **x64**: `bin/Release/net6.0/win-x64/publish/WinPlusH-dotNet.exe` (163KB)
- **ARM64**: `bin/Release/net6.0/win-arm64/publish/WinPlusH-dotNet.exe` (155KB)
- **优点**：无需安装 .NET Runtime
- **缺点**：需要为不同架构准备不同文件

### 推荐使用策略
- **企业/IT 环境**：AnyCPU 版本（统一管理）
- **个人/便携使用**：架构特定单文件版本（无依赖）
