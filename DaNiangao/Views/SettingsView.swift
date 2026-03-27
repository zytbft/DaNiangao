import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel
    let onBack: () -> Void
    let onOpenShop: () -> Void

    @State private var showResetAlert = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("返回")
                    }
                    .font(GameFonts.caption)
                    .foregroundStyle(GameColors.text)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("设置")
                    .font(GameFonts.subtitle)
                    .foregroundStyle(GameColors.text)

                Spacer()

                Color.clear.frame(width: 60)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)

            VStack(spacing: 15) {
                settingsRow(
                    icon: "bag.fill",
                    iconColor: GameColors.accent,
                    title: "皮肤商店",
                    subtitle: "购买和选择年糕皮肤"
                ) {
                    onOpenShop()
                }

                Divider()

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(GameColors.coinGold)
                        .frame(width: 30)
                    Text("当前金币")
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.text)
                    Spacer()
                    Text("\(viewModel.totalCoins)")
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.coinGold)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 3)
                )

                Divider()

                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundStyle(GameColors.primary)
                        .frame(width: 30)
                    Text("音效")
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.text)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { UserDataManager.shared.soundEnabled },
                        set: { UserDataManager.shared.soundEnabled = $0 }
                    ))
                    .labelsHidden()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 3)
                )

                Divider()

                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundStyle(GameColors.success)
                        .frame(width: 30)
                    VStack(alignment: .leading) {
                        Text("已通关关卡")
                            .font(GameFonts.body)
                            .foregroundStyle(GameColors.text)
                        Text("\(UserDataManager.shared.unlockedLevels - 1)/20")
                            .font(GameFonts.caption)
                            .foregroundStyle(GameColors.text.opacity(0.6))
                    }
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 3)
                )

                Divider()

                Button(action: { showResetAlert = true }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(GameColors.fail)
                            .frame(width: 30)
                        Text("重置游戏进度")
                            .font(GameFonts.body)
                            .foregroundStyle(GameColors.fail)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 3)
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 30)

            Spacer()

            Text("DaNiangao v1.0")
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.text.opacity(0.4))
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GameColors.background.ignoresSafeArea())
        .alert("确定要重置游戏进度吗？", isPresented: $showResetAlert) {
            Button("取消", role: .cancel) { }
            Button("确定", role: .destructive) {
                UserDataManager.shared.resetProgress()
                viewModel.objectWillChange.send()
            }
        } message: {
            Text("这将清除所有关卡进度、金币和已购买的皮肤，此操作不可撤销。")
        }
    }

    private func settingsRow(icon: String, iconColor: Color, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .frame(width: 30)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.text)
                    Text(subtitle)
                        .font(GameFonts.caption)
                        .foregroundStyle(GameColors.text.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(GameColors.text.opacity(0.3))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 3)
            )
        }
        .buttonStyle(.plain)
    }
}