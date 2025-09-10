# WinPlusH-dotNet

一个极简的 C# .NET 控制台应用程序，用于模拟 Win+H 组合键激活 Windows 语音输入工具。

## 特性

- 🔇 **静默运行** - 无控制台窗口，无输出
- 🎯 **单一功能** - 仅执行 Win+H 快捷键
- 📦 **极小体积** - 单文件可执行程序
- 🖊️ **笔按键适配** - 完美适用于 Windows Ink 笔按键配置

## 系统要求

- Windows 10/11
- 若使用「框架依赖」发布（AnyCPU 或当前脚本生成的 x64/ARM64 单文件）：需要已安装 .NET 6.0 Runtime 或更高版本
- 若使用「自包含」发布（下文可选方式）：无需安装 .NET Runtime（体积更大）

## 构建说明

### 选项 1: AnyCPU 可移植版本（推荐，框架依赖）
兼容 x64 和 ARM64，需设备已安装 .NET 6+ Runtime：
```powershell
dotnet publish -c Release
```

### 选项 2: 架构特定单文件版本（当前脚本配置为框架依赖）
当前仓库里的发布命令使用的是「框架依赖 + 单文件」方式（带有 `/p:PublishSingleFile=true` 且 `--self-contained false`），因此仍然需要目标机器预装 .NET Runtime：
```powershell
# x64 版本
dotnet publish -c Release -r win-x64 --self-contained false /p:PublishSingleFile=true

# ARM64 版本  
dotnet publish -c Release -r win-arm64 --self-contained false /p:PublishSingleFile=true
```

如果你希望生成「无需 .NET Runtime」的真正独立可执行文件，请使用「自包含（Self-contained）」发布（体积会显著增大）：

```powershell
# x64 自包含单文件
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true

# ARM64 自包含单文件
dotnet publish -c Release -r win-arm64 --self-contained true /p:PublishSingleFile=true
```

可选优化（按需）：
- 添加修剪以减少体积：在命令后附加 `/p:PublishTrimmed=true`（注意可能有反射相关风险，需自行验证）。

### 方法 3: 批处理脚本
运行 `build-all.bat` 一次性构建所有版本（当前脚本构建的是「框架依赖」版本，需 .NET Runtime）。

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

### AnyCPU 可移植版本（推荐，框架依赖）
位置：`bin/Release/net6.0/publish/`
- **WinPlusH-dotNet.exe** (151KB) - 主程序，兼容 x64/ARM64
- 附带文件：WinPlusH-dotNet.dll, .deps.json, .runtimeconfig.json
- **优点**：一个版本兼容所有架构
- **要求**：设备需安装 .NET 6+ Runtime

### 架构特定单文件版本（框架依赖，当前脚本默认）
- **x64**: `bin/Release/net6.0/win-x64/publish/WinPlusH-dotNet.exe` (163KB)
- **ARM64**: `bin/Release/net6.0/win-arm64/publish/WinPlusH-dotNet.exe` (155KB)
- **说明**：仍需安装 .NET Runtime（因为使用的是框架依赖发布）
- **优点**：每个架构有独立文件；启动快；体积较小
- **缺点**：目标机器需要 .NET Runtime

### 自包含单文件版本（可选）
- 发布命令：见上文「自包含（Self-contained）」示例
- **说明**：无需安装 .NET Runtime
- **优点**：零依赖，拿来即用
- **缺点**：体积较大（通常几十 MB 级别）；每个架构需要单独构建

### 推荐使用策略
- **企业/IT 环境**：AnyCPU 框架依赖版本（统一管理，体积小），确保通过软件中心或镜像预装 .NET 运行时
- **个人/便携使用**：若希望完全无依赖，请按「自包含单文件版本」方式发布并分发对应架构文件

## 故障排查（SCD 自包含发布）

### NU1100: 无法解析 Microsoft.NETCore.App.Runtime / ILLink 包
现象：自包含发布时出现如下错误（示例）：

- 无法解析 `Microsoft.NETCore.App.Runtime.win-<arch>`
- 无法解析 `Microsoft.NET.ILLink.Tasks` / `Microsoft.NET.ILLink.Analyzers`

原因：本机未配置 NuGet 源，导致无法从 nuget.org 拉取运行时包/裁剪器包。

解决：
1) 添加 nuget.org 源（一次性）：

```powershell
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
```

2) 如仍失败，可清理缓存后再试：

```powershell
dotnet nuget locals all --clear
```

3) 重新执行自包含发布命令（见上文）。

### 警告 NETSDK1138（net6.0 已到达 EOL）
- 含义：.NET 6 已不再接收安全更新，建议尽快迁移至 .NET 8 LTS。
- 影响：可继续构建与运行，但建议择机升级 `TargetFramework` 到 `net8.0` 以获得长期支持与更好的裁剪/发布体验。
