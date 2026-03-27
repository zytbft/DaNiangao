import SwiftUI

struct SkinShopView: View {
    @ObservedObject var viewModel: GameViewModel
    let onBack: () -> Void

    @State private var showPurchaseAlert = false
    @State private var purchaseMessage = ""
    @State private var purchaseSuccess = false

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

                Text("年糕皮肤商店")
                    .font(GameFonts.subtitle)
                    .foregroundStyle(GameColors.text)

                Spacer()

                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(GameColors.coinGold)
                    Text("\(viewModel.totalCoins)")
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.coinGold)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(MochiSkinColor.allCases) { skin in
                        SkinCard(
                            skin: skin,
                            isOwned: viewModel.isSkinOwned(skin),
                            isSelected: viewModel.selectedSkin == skin,
                            canAfford: viewModel.totalCoins >= skin.price,
                            onSelect: {
                                if viewModel.isSkinOwned(skin) {
                                    viewModel.selectSkin(skin)
                                }
                            },
                            onPurchase: {
                                if viewModel.totalCoins >= skin.price {
                                    if viewModel.purchaseSkin(skin) {
                                        purchaseSuccess = true
                                        purchaseMessage = "成功购买 \(skin.displayName) 皮肤!"
                                    }
                                } else {
                                    purchaseSuccess = false
                                    purchaseMessage = "金币不足，需要 \(skin.price) 金币"
                                }
                                showPurchaseAlert = true
                            }
                        )
                    }
                }
                .padding(30)
            }

            HStack(spacing: 20) {
                Text("当前选中:")
                    .font(GameFonts.body)
                    .foregroundStyle(GameColors.text.opacity(0.7))

                Circle()
                    .fill(
                        RadialGradient(
                            colors: viewModel.selectedSkin.gradientColors,
                            center: .center,
                            startRadius: 0,
                            endRadius: 20
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(viewModel.selectedSkin.gradientColors[1], lineWidth: 2)
                    )

                Text(viewModel.selectedSkin.displayName)
                    .font(GameFonts.body)
                    .foregroundStyle(GameColors.text)
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GameColors.background.ignoresSafeArea())
        .alert(purchaseMessage, isPresented: $showPurchaseAlert) {
            Button("确定", role: purchaseSuccess ? .none : .cancel) { }
        }
    }
}

struct SkinCard: View {
    let skin: MochiSkinColor
    let isOwned: Bool
    let isSelected: Bool
    let canAfford: Bool
    let onSelect: () -> Void
    let onPurchase: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: skin.gradientColors,
                        center: .center,
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(skin.gradientColors[1], lineWidth: isSelected ? 3 : 2)
                )
                .shadow(color: .black.opacity(0.2), radius: 5)

            VStack(alignment: .leading, spacing: 5) {
                Text(skin.displayName)
                    .font(GameFonts.body)
                    .foregroundStyle(GameColors.text)

                if isOwned {
                    Text("已拥有")
                        .font(GameFonts.caption)
                        .foregroundStyle(GameColors.success)
                } else {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(GameColors.coinGold)
                        Text("\(skin.price)")
                            .font(GameFonts.caption)
                            .foregroundStyle(GameColors.coinGold)
                    }
                }
            }

            Spacer()

            if isOwned {
                if isSelected {
                    Button(action: {}) {
                        Text("使用中")
                            .font(GameFonts.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(GameColors.success)
                            )
                    }
                    .buttonStyle(.plain)
                } else {
                    Button("选择") {
                        onSelect()
                    }
                    .font(GameFonts.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(GameColors.primary)
                    )
                    .buttonStyle(.plain)
                }
            } else {
                Button(action: onPurchase) {
                    HStack(spacing: 5) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 12))
                        Text("购买")
                            .font(GameFonts.caption)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(canAfford ? GameColors.accent : Color.gray)
                    )
                }
                .buttonStyle(.plain)
                .disabled(!canAfford)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }
}