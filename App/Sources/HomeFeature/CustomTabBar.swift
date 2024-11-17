//
//  CustomTabBar.swift
//  App
//
//  Created by Kei on 2024/11/16.
//

import Entities
import SwiftUI

struct CustomTabBar: View {
  @Binding var currentTab: DisplayTab
  let colorStr: String

  var body: some View {
    HStack(spacing: 24) {
      ForEach(DisplayTab.allCases, id: \.hashValue) { tab in
        Button {
          withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)) {
            currentTab = tab
          }
        } label: {
          Image(systemName: tab.systemIconName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundColor(currentTab == tab ? .black : .gray)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background {
              if currentTab == tab {
                Color(hexValue: "eeeeee")
                  .clipShape(.rect(cornerRadius: 24))
                  .overlay {
                    RoundedRectangle(cornerRadius: 24)
                      .stroke(Color.white, lineWidth: 2)
                  }
              } else {
                Color.clear
              }
            }
        }
      }
    }
    .background {
      Color(hexValue: colorStr)
        .clipShape(.rect(cornerRadius: 24))
        .overlay {
          RoundedRectangle(cornerRadius: 24)
            .stroke(Color.white, lineWidth: 2)
        }
    }
  }
}
