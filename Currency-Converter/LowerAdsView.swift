//
//  LowerAdsView.swift
//  Currency-Converter
//
//  Created by 細川聖矢 on 2021/03/03.
//

import SwiftUI
import GoogleMobileAds

struct SecondAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
        banner.adUnitID = "ca-app-pub-4439113960692957/8368376153"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

struct LowerAdsView: View {
    var body: some View {
        SecondAdView().frame(width: 320, height: 50)
    }
}

struct LowerAdsView_Previews: PreviewProvider {
    static var previews: some View {
        LowerAdsView()
    }
}
