//
//  FirstAppear+ViewModifier.swift
//  ASBAssessment
//
//  Created by Banerjee, Supratik on 04/07/22.
//

import SwiftUI

private struct FirstAppear: ViewModifier {

    // MARK: - Variables

    /// Action onf first appear
    let firstAppearAction: () -> Void

    /// Property to handle if screen has appeared for first time
    @State private var appearedFirstTime: Bool = true

    // MARK: - Method
    func body(content: Content) -> some View {
        content.onAppear {
            if appearedFirstTime {
                appearedFirstTime = false
                firstAppearAction()
            }
        }
    }
}

extension View {
    func onFirstAppear(firstAppearAction: @escaping() -> Void) -> some View {
        return self.modifier(FirstAppear(firstAppearAction: firstAppearAction))
    }
}
