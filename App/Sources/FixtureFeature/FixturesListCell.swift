import ComposableArchitecture
import Kingfisher
import SwiftUI
import Entities
import Extensions

public struct FixturesListCell: View {
  public let fixture: Fixture
  
  public init(fixture: Fixture) {
    self.fixture = fixture
  }
  
  public var body: some View {
    HStack(spacing: .zero) {
      HStack {
        KFImage(URL(string: fixture.teams.home.logo))
          .resizable()
          .frame(width: 56, height: 56)
          .aspectRatio(contentMode: .fill)
          .padding(.leading, 32)
          .padding(.vertical, 16)
        Spacer()
        Text(fixture.goals.home?.description ?? "")
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 32))
          .padding(.trailing, 16)
      }
      
      Text("-")
        .foregroundColor(Color.white)
        .font(.custom("SSportsD-Medium", size: 32))
        .padding(.horizontal, 8)
      
      HStack {
        Text(fixture.goals.away?.description ?? "")
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 32))
          .padding(.leading, 16)
        Spacer()
        KFImage(URL(string: fixture.teams.away.logo))
          .resizable()
          .frame(width: 56, height: 56)
          .aspectRatio(contentMode: .fill)
          .padding(.trailing, 32)
          .padding(.vertical, 16)
      }
    }
    .background {
      LinearGradient(
        gradient: Gradient(colors: [
          Color(hexValue: fixture.teams.home.theme.mainColorCode),
          Color(hexValue: fixture.teams.away.theme.mainColorCode)
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}
