# 打年糕游戏 - 技术规格说明书

## 1. 项目概述

**项目名称**: DaNiangao (打年糕)
**Bundle Identifier**: com.daniangao.gamemac
**Core Functionality**: 一款以中国新年捣年糕为灵感的节奏类休闲游戏，玩家需要在精确时机按下按钮将移动的面团打成完美年糕
**Target Users**: 休闲游戏玩家，所有年龄段
**macOS Version Support**: macOS 14.0+ (Sonoma 及以上)
**UI Framework**: SwiftUI

***

## 2. 游戏设计规格

### 2.1 核心玩法

#### 游戏路径 (Game Path)

- 水平直线年糕移动路径，位于屏幕中央偏下
- 路径长度: 屏幕宽度的 80%
- 路径左端: 面团生成点 (标记为面团准备区)
- 路径右端: 年糕成功打击区 (标记为年糕目标区)
- 路径中点: 完美时机判定区 (宽度约占路径的15%)

#### 面团移动机制

- 面团从路径左端匀速向右移动
- 移动过程中显示预测轨迹线(虚线)
- 面团尺寸: 60x60 points

#### 判定机制

| 时机 | 判定区域         | 描述                  |
| -- | ------------ | ------------------- |
| 完美 | 路径末端正负5%范围   | 面团被完美击中，飞向成功区，得100分 |
| 良好 | 路径末端5%-15%范围 | 面团被击中但力度不足，得50分     |
| 失败 | 面团未到达目标区域    | 面团未被击中，送回失败区，扣1次机会  |

#### 打击工具

- 日式木槌(杵)图形
- 点击/按压时木槌执行向下敲击动画
- 敲击有效范围: 整个路径区域

### 2.2 难度设计 - 20个关卡

| 关卡 | 基础速度      | 目标分数 | 所需成功次数 |
| -- | --------- | ---- | ------ |
| 1  | 80 pts/s  | 200  | 2      |
| 2  | 90 pts/s  | 300  | 3      |
| 3  | 100 pts/s | 400  | 4      |
| 4  | 110 pts/s | 500  | 5      |
| 5  | 120 pts/s | 600  | 6      |
| 6  | 135 pts/s | 750  | 8      |
| 7  | 150 pts/s | 900  | 9      |
| 8  | 165 pts/s | 1050 | 11     |
| 9  | 180 pts/s | 1200 | 12     |
| 10 | 200 pts/s | 1400 | 14     |
| 11 | 220 pts/s | 1600 | 16     |
| 12 | 245 pts/s | 1800 | 18     |
| 13 | 270 pts/s | 2000 | 20     |
| 14 | 300 pts/s | 2200 | 22     |
| 15 | 330 pts/s | 2500 | 25     |
| 16 | 365 pts/s | 2800 | 28     |
| 17 | 400 pts/s | 3100 | 31     |
| 18 | 440 pts/s | 3500 | 35     |
| 19 | 485 pts/s | 3900 | 39     |
| 20 | 530 pts/s | 4500 | 45     |

**速度递增公式**: `新速度 = 当前速度 + (关卡号 * 5) + 75`

### 2.3 游戏资源

#### 图像资源 (使用 SF Symbols + 自定义绘制)

- `mochi_dough` - 面团: 圆形渐变，米白色
- `mochi_mallet` - 木槌: 使用 Shape 绘制日式木槌
- `mochi_success` - 成功区: 年糕图标，渐变粉红色
- `mochi_fail` - 失败区: 扁平面团图标
- `path_line` - 路径线: 渐变木纹色

#### 颜色规格

```
Primary:     #F5A623 (温暖橙色 - 年糕主题)
Secondary:   #E8D5B7 (米色背景)
Accent:      #FF6B6B (成功/打击反馈)
Success:     #4ECDC4 (完成反馈)
Fail:        #FF8585 (失败反馈)
Background:  #FFF8E7 (暖白色)
Text:        #4A4A4A (深灰)
```

#### 音效资源 (系统音效替代)

- 打击声: NSSound.beep() 或自定义 AudioPlayer
- 成功音效: 上升音阶
- 失败音效: 下降音阶

***

## 3. 技术架构

### 3.1 项目结构

```
DaNiangao/
├── App/
│   ├── main.swift
│   ├── DaNiangaoApp.swift
│   └── ContentView.swift
├── Views/
│   ├── LevelSelectView.swift
│   ├── GamePlayView.swift
│   ├── ResultView.swift
│   └── Components/
│       ├── MochiDoughView.swift
│       ├── MalletView.swift
│       ├── GamePathView.swift
│       └── ScoreDisplayView.swift
├── Models/
│   ├── GameState.swift
│   ├── Level.swift
│   └── GameResult.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Utilities/
│   ├── Constants.swift
│   └── UserDataManager.swift
├── Resources/
│   └── Assets.xcassets/
└── project.yml
```

### 3.2 数据模型

#### Level (关卡数据)

```swift
struct Level: Identifiable, Codable {
    let id: Int
    let speed: Double
    let targetScore: Int
    let requiredHits: Int
    var isUnlocked: Bool
}
```

#### GameState (游戏状态)

```swift
enum GamePhase {
    case ready
    case playing
    case hitting
    case result
}

struct GameState {
    var phase: GamePhase = .ready
    var currentLevel: Level
    var score: Int = 0
    var hits: Int = 0
    var misses: Int = 0
    var doughPosition: Double = 0.0
    var attemptsLeft: Int = 3
}
```

#### GameResult (游戏结果)

```swift
enum Rating: String {
    case perfect = "完美!"
    case great = "很棒!"
    case good = "不错"
    case fail = "失败"
}

struct GameResult {
    let level: Int
    let score: Int
    let hits: Int
    let misses: Int
    let rating: Rating
    let nextLevelUnlocked: Bool
}
```

### 3.3 游戏循环

```
1. Ready Phase:
   - 显示 "准备" 提示
   - 3秒倒计时

2. Playing Phase:
   - 面团从左向右移动
   - 显示预测轨迹
   - 等待玩家输入

3. Hitting Phase (玩家点击):
   - 播放打击动画
   - 计算判定结果
   - 更新分数/命中次数
   - 播放反馈动画

4. Result Phase:
   - 显示关卡结算
   - 判断是否通关
   - 解锁下一关或重试
```

***

## 4. 用户界面规格

### 4.1 关卡选择界面

- 标题: "打年糕" 大字居中
- 5x4 网格显示20个关卡按钮
- 已解锁关卡: 橙色圆形背景 + 关卡数字
- 未解锁关卡: 灰色半透明圆形 + 锁图标
- 底部显示: 已通关最高关卡数
- 右上角: 设置按钮 (音效开关)

### 4.2 游戏界面布局

```
┌─────────────────────────────────────┐
│  关卡 3          得分: 250          │ ← 顶部信息栏
├─────────────────────────────────────┤
│                                     │
│         [成功区 年糕图标]            │ ← 成功区
│                                     │
│  ●━━━━━━━━━━━━━━━━━━━○              │ ← 游戏路径
│  ↑                        ↑         │
│  面团起点              目标区       │
│                                     │
│         [装饰性木槌]                │ ← 木槌位置
│                                     │
├─────────────────────────────────────┤
│     剩余次数: ● ● ○                 │ ← 底部状态
└─────────────────────────────────────┘
```

### 4.3 结果界面

- 居中卡片设计
- 显示: 得分、命中数、评价
- 三个按钮: 重玩、下一关、返回菜单
- 成功时: 绿色主题 + 庆祝动画
- 失败时: 红色主题 + 安慰文案

***

## 5. 动画规格

### 5.1 面团动画

- 移动: Linear timing, 持续跟随速度参数
- 被击中: scale 1.0→1.3→1.0, 0.2s ease-out
- 飞向成功区: 贝塞尔曲线动画, 0.5s
- 失败回退: 滑回起点, 0.3s ease-in-out

### 5.2 木槌动画

- 待机: 轻微上下浮动, 2s循环
- 敲击: rotate -30deg → +30deg, 0.15s
- 复位: 回到待机位置, 0.2s

### 5.3 反馈动画

- 完美击中: 粒子爆发效果 + 屏幕轻微震动
- 良好击中: 星星闪烁
- 失败: 面团变灰 + 摇晃

***

## 6. 数据持久化

使用 `@AppStorage` 存储:

```swift
@AppStorage("unlockedLevels") private var unlockedLevels: Int = 1
@AppStorage("highScores") private var highScoresData: Data = Data()
```

***

## 7. 验收标准

### 功能验收

- [ ] 20个关卡全部可玩
- [ ] 难度递增平滑可感
- [ ] 判定机制准确
- [ ] 关卡解锁逻辑正确
- [ ] 分数/进度正确保存

### 视觉验收

- [ ] 年糕主题风格统一
- [ ] 动画流畅无卡顿
- [ ] 反馈及时明确
- [ ] 适配不同窗口尺寸

### 性能验收

- [ ] 60fps 流畅运行
- [ ] 内存占用 < 100MB
- [ ] 启动时间 < 2s