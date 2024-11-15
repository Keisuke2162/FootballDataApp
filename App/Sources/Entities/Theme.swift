import Foundation

public enum ClubTheme: Int {
  case other = 0
  case albirex = 311
  case avispa = 316
  case cerezo = 291
  case consadole = 279
  case gamba = 293
  case jubilo = 280
  case kashima = 290
  case kashiwa = 281
  case kawasaki = 294
  case kyoto = 302
  case machida = 303
  case nagoya = 288
  case sagan = 295
  case sanfrecce = 282
  case shonan = 284
  case fcTokyo = 292
  case verdy = 306
  case urawa = 287
  case vissel = 289
  case marinos = 296

  public var mainColorCode: String {
    switch self {
    case .other:
      ""
    case .albirex:
      "ff6600"
    case .avispa:
      "04407f"
    case .cerezo:
      "d40069"
    case .consadole:
      "d7000f"
    case .gamba:
      "093fa6"
    case .jubilo:
      "6e9dd3"
    case .kashima:
      "b71840"
    case .kashiwa:
      "fff100"
    case .kawasaki:
      "35a0d9"
    case .kyoto:
      "74006b"
    case .machida:
      "00236a"
    case .nagoya:
      "da361b"
    case .sagan:
      "0096d2"
    case .sanfrecce:
      "50318f"
    case .shonan:
      "67b464"
    case .fcTokyo:
      "214198"
    case .verdy:
      "03764b"
    case .urawa:
      "e7002b"
    case .vissel:
      "8f0a1f"
    case .marinos:
      "003989"
    }
  }
}
