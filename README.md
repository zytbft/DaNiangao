# 🎍 DaNiangao - 打年糕休闲游戏

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-orange.svg)
![Swift](https://img.shields.io/badge/swift-5.9-red.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**一款以中国新年捣年糕为灵感的节奏类休闲游戏**

[English](README.md) | 简体中文

</div>

---

## 📖 项目概述

DaNiangao（打年糕）是一款精心设计的 macOS 休闲游戏，融合了传统中国年糕文化元素与现代游戏机制。玩家需要在精确时机按下按钮，将移动的面团打成完美年糕，体验传统中国新年的欢乐氛围。

**游戏特色：**
- 🎯 **精准时机判定** - 完美/良好两级评分系统
- 🎨 **精美视觉效果** - 多种年糕皮肤和随机图案
- 🏆 **20个挑战关卡** - 难度递进，考验技巧
- 💰 **金币与商店系统** - 收集金币，解锁炫酷皮肤
- ⚡ **流畅动画效果** - 锤子敲击、年糕旋转等丰富动效

---

## ✨ 核心功能

### 🎮 游戏机制
- **水平路径移动** - 面团从左向右匀速移动
- **精准时机判定** - 完美区域(85%-95%)得100分，良好区域(75%-85%)得50分
- **3次机会制** - 每局拥有3次尝试机会
- **关卡进度系统** - 达成目标分数和命中数过关

### 🎨 年糕皮肤系统

| 皮肤名称 | 颜色主题 | 价格 |
|---------|---------|------|
| 经典白 | 米白色系 | 免费 |
| 落日红 | 红橙渐变 | 500 金币 |
| 海洋蓝 | 紫蓝渐变 | 300 金币 |
| 森林绿 | 绿色渐变 | 250 金币 |
| 薰衣草紫 | 紫粉渐变 | 350 金币 |
| 珊瑚粉 | 粉色渐变 | 400 金币 |
| 薄荷绿 | 青绿渐变 | 200 金币 |

### 🎨 随机图案
- **漩涡(Swirl)** - 螺旋点状图案
- **锯齿(Zigzag)** - 不规则放射线条
- **圆点(Dots)** - 同心圆分布点
- **波浪(Waves)** - 弧形波纹
- **螺旋(Spiral)** - 曲线螺旋线
- **爆发(Burst)** - 曲线光芒

### 💰 金币系统
- 每局通关获得 **30 金币**
- 通关失败获得 **15 金币**
- 金币用于购买年糕皮肤

### ⚒️ 锤子系统
- 日式木柄锤子设计
- 金属质感锤头
- 流畅敲击动画

---

## 🛠️ 技术栈

| 技术 | 说明 | 版本 |
|------|------|------|
| **SwiftUI** | 用户界面框架 | macOS 14.0+ |
| **Swift** | 编程语言 | 5.9+ |
| **XcodeGen** | 项目生成工具 | 15.0+ |
| **Combine** | 响应式编程 | 内置框架 |
| **UserDefaults** | 数据持久化 | 内置框架 |

### 架构模式
- **MVVM (Model-View-ViewModel)** - 清晰的项目架构
- **ObservableObject** - 状态管理
- **Combine** - 数据流处理

---

## 📋 环境要求

### 系统要求
- **操作系统**: macOS 14.0 (Sonoma) 或更高版本
- **处理器**: Apple Silicon 或 Intel
- **内存**: 最低 4GB RAM
- **存储空间**: 约 100MB 可用空间

### 开发工具
- **Xcode**: 15.0 或更高版本
- **Swift**: 5.9 或更高版本
- **XcodeGen**: 项目生成工具

---

## 🚀 安装与配置

### 步骤 1: 安装 XcodeGen

如果你还没有安装 XcodeGen，请先安装：

```bash
# 使用 Homebrew 安装（推荐）
brew install xcodegen

# 或使用 MacPorts
sudo port install xcodegen
```

### 步骤 2: 克隆项目

```bash
git clone <repository-url>
cd 12打年糕
```

### 步骤 3: 生成 Xcode 项目

```bash
xcodegen generate
```

### 步骤 4: 在 Xcode 中打开

```bash
open DaNiangao.xcodeproj
```

### 步骤 5: 构建并运行

1. 在 Xcode 中选择 **DaNiangao** scheme
2. 按 **⌘R** 或点击运行按钮
3. 游戏将在新窗口中启动

### 快速启动（使用命令行）

```bash
# 构建 Release 版本
xcodebuild -project DaNiangao.xcodeproj -scheme DaNiangao -configuration Release build

# 运行应用
open ~/Library/Developer/Xcode/DerivedData/DaNiangao-*/Build/Products/Release/DaNiangao.app
```

---

## 📖 使用指南

### 🎮 如何游戏

1. **启动游戏** - 运行应用进入主菜单
2. **开始游戏** - 点击"开始游戏"按钮
3. **选择关卡** - 从关卡选择界面选择要挑战的关卡
4. **准备阶段** - 等待 3-2-1 倒计时
5. **打击年糕** - 当面团移动到目标区域时：
   - 按 **空格键**
   - 或 **点击屏幕**
6. **判定结果** - 根据时机的精准度获得分数
7. **通关条件** - 达成目标分数和命中数即可过关

### 🎨 皮肤商店使用

1. **进入商店** - 点击右上角的金币图标或"皮肤商店"按钮
2. **浏览皮肤** - 查看所有可用的年糕皮肤
3. **购买皮肤** - 使用金币购买未拥有的皮肤
4. **选择皮肤** - 点击已拥有的皮肤进行装备
5. **确认使用** - 选中的皮肤将立即生效

### ⚙️ 设置功能

- **音效开关** - 开启/关闭游戏音效
- **重置进度** - 清除所有游戏数据（谨慎使用）

### ⌨️ 快捷键

| 按键 | 功能 |
|------|------|
| **空格键** | 打击年糕 |
| **⌘Q** | 退出游戏 |
| **⌘,** | 打开设置 |

---

## 📁 项目结构

```
DaNiangao/
├── App/                          # 应用入口
│   ├── main.swift               # 应用主函数
│   ├── DaNiangaoApp.swift      # AppDelegate
│   └── ContentView.swift        # 主视图导航
├── Models/                       # 数据模型
│   ├── Level.swift              # 关卡数据模型
│   ├── GameState.swift          # 游戏状态
│   └── GameResult.swift         # 游戏结果
├── ViewModels/                   # 视图模型
│   └── GameViewModel.swift      # 游戏逻辑与状态管理
├── Views/                        # 视图层
│   ├── MainMenuView.swift       # 主菜单
│   ├── LevelSelectView.swift    # 关卡选择
│   ├── GamePlayView.swift       # 游戏主界面
│   ├── ResultView.swift         # 结果结算
│   ├── SkinShopView.swift       # 皮肤商店
│   ├── SettingsView.swift        # 设置页面
│   └── Components/              # 组件
│       ├── MochiDoughView.swift # 年糕视图
│       ├── MalletView.swift     # 锤子视图
│       ├── GamePathView.swift   # 游戏路径
│       └── ScoreDisplayView.swift
├── Utilities/                    # 工具类
│   ├── Constants.swift          # 常量定义
│   └── UserDataManager.swift    # 数据管理
├── Resources/                    # 资源文件
│   └── Assets.xcassets/         # 图片资源
├── project.yml                   # XcodeGen 配置
└── DaNiangao.entitlements     # 应用权限
```

### 文件说明

| 文件 | 功能描述 |
|------|---------|
| `main.swift` | 应用启动入口，使用 NSApplication |
| `GameViewModel.swift` | 游戏核心逻辑、状态管理、定时器控制 |
| `MochiDoughView.swift` | 年糕渲染、图案绘制、动画效果 |
| `UserDataManager.swift` | 金币、皮肤、解锁状态的持久化 |

---

## 🎯 关卡设计

| 关卡 | 速度 (pts/s) | 目标分数 | 所需命中 |
|------|-------------|---------|---------|
| 1-5 | 80-120 | 200-600 | 2-6 |
| 6-10 | 135-200 | 750-1400 | 8-14 |
| 11-15 | 220-330 | 1600-2500 | 16-25 |
| 16-20 | 365-530 | 2800-4500 | 28-45 |

---

## 🤝 贡献指南

欢迎为 DaNiangao 项目贡献代码！

### 提交 Issue
- 🐛 发现 Bug？请提交 Issue
- 💡 有新功能建议？请提交 Issue
- ❓ 有问题需要帮助？请提交 Issue

### 提交 Pull Request
1. **Fork** 本仓库
2. **Clone** 你的 Fork
3. **创建新分支** `git checkout -b feature/your-feature`
4. **提交更改** `git commit -m 'Add some feature'`
5. **推送分支** `git push origin feature/your-feature`
6. **创建 Pull Request**

### 代码规范
- 遵循 Swift 代码规范
- 使用 SwiftFormat 格式化代码
- 确保代码通过编译且无警告

---

## 📄 许可证

本项目基于 **MIT 许可证** 开源。

```
MIT License

Copyright (c) 2024 DaNiangao

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📧 联系方式

- **项目主页**: https://github.com/daniangao/DaNiangao
- **问题反馈**: https://github.com/daniangao/DaNiangao/issues
- **电子邮件**: support@daniangao.com

---

## 🙏 致谢

感谢以下开源项目和技术支持：

- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - Apple 的现代 UI 框架
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) - Xcode 项目生成工具
- [Pillow](https://python-pillow.org/) - Python 图像处理库（用于生成图标）

---

<div align="center">

**🎍 祝你游戏愉快！🎍**

*Made with ❤️ by DaNiangao Team*

</div>