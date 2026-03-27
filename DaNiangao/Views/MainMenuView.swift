import SwiftUI

struct MainMenuView: View {
    let onStartGame: () -> Void
    let onOpenShop: () -> Void
    let onOpenSettings: () -> Void
    let totalCoins: Int

    @State private var titleAnimation = false
    @State private var buttonAnimation = false

    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Button(action: onOpenSettings) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(GameColors.text.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        )
                }
                .buttonStyle(.plain)
                .padding(.leading, 30)
                .padding(.top, 30)

                Spacer()

                Button(action: onOpenShop) {
                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(GameColors.coinGold)
                        Text("\(totalCoins)")
                            .font(GameFonts.body)
                            .foregroundStyle(GameColors.coinGold)
                        Image(systemName: "bag.fill")
                            .foregroundStyle(GameColors.primary)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 5)
                    )
                }
                .buttonStyle(.plain)
                .padding(.trailing, 30)
                .padding(.top, 30)
            }

            Spacer()

            VStack(spacing: 20) {
                Text("🎍")
                    .font(.system(size: 80))
                    .scaleEffect(titleAnimation ? 1.0 : 0.5)
                    .opacity(titleAnimation ? 1.0 : 0.0)

                Text("打年糕")
                    .font(GameFonts.title)
                    .foregroundStyle(GameColors.primary)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)

                Text("DaNiangao")
                    .font(GameFonts.subtitle)
                    .foregroundStyle(GameColors.text.opacity(0.7))
            }
            .scaleEffect(titleAnimation ? 1.0 : 0.8)
            .opacity(titleAnimation ? 1.0 : 0.0)

            Spacer()

            VStack(spacing: 20) {
                Button(action: onStartGame) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("开始游戏")
                    }
                    .font(GameFonts.body)
                    .foregroundStyle(.white)
                    .frame(width: 220, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(GameColors.primary)
                            .shadow(color: GameColors.primary.opacity(0.5), radius: 10, x: 0, y: 5)
                    )
                }
                .buttonStyle(.plain)
                .scaleEffect(buttonAnimation ? 1.0 : 0.9)
                .opacity(buttonAnimation ? 1.0 : 0.0)

                Button(action: onOpenShop) {
                    HStack {
                        Image(systemName: "bag.fill")
                        Text("皮肤商店")
                    }
                    .font(GameFonts.body)
                    .foregroundStyle(.white)
                    .frame(width: 220, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(GameColors.accent)
                            .shadow(color: GameColors.accent.opacity(0.5), radius: 10, x: 0, y: 5)
                    )
                }
                .buttonStyle(.plain)
                .scaleEffect(buttonAnimation ? 1.0 : 0.9)
                .opacity(buttonAnimation ? 1.0 : 0.0)

                Text("点击按钮开始你的年糕之旅!")
                    .font(GameFonts.caption)
                    .foregroundStyle(GameColors.text.opacity(0.6))
                    .opacity(buttonAnimation ? 1.0 : 0.0)
            }

            Spacer()

            Text("操作说明: 当年糕移动到目标区域时点击空格键或点击屏幕!")
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.text.opacity(0.5))
                .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                titleAnimation = true
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
                buttonAnimation = true
            }
        }
    }
}