//
//  RootView.swift
//  App
//
//  Created by Kei on 2024/10/28.
//

import ComposableArchitecture
import HomeFeature
import SwiftUI

public struct RootView: View {
  public init() {
  }

  public var body: some View {
    HomeView(store: Store(initialState: HomeReducer.State(), reducer: {
        HomeReducer()
    }))
  }
}

