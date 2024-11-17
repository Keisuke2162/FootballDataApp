import Foundation

public enum ClubTheme: Int {
  case other = 0
  
  // MARK: Premier
  case arsenal = 42
  case aston_villa = 66
  case bournemouth = 35
  case brentford = 55
  case brighton = 51
  case burnley = 44
  case chelsea = 49
  case crystal_palace = 52
  case everton = 45
  case fulham = 36
  case liverpool = 40
  case luton_town = 1359
  case manchester_city = 50
  case manchester_united = 33
  case newcastle_united = 34
  case nottingham_forest = 65
  case sheffield_united = 62
  case tottenham_hotspur = 47
  case west_ham_united = 48
  case wolverhampton_wanderers = 39
  
  // MARK: Serie A
  case inter = 505
  case juventus = 496
  case ac_milan = 489
  case atalanta = 499
  case bologna = 500
  case as_roma = 497
  case lazio = 487
  case fiorentina = 502
  case napoli = 492
  case torino = 503
  case monza = 1579
  case genoa = 495
  case lecce = 867
  case frosinone = 512
  case udinese = 494
  case empoli = 511
  case sassuolo = 488
  case verona = 504
  case cagliari = 490
  case salernitana = 514
  
  // MARK: La Liga
  case real_madrid = 541
  case girona = 547
  case barcelona = 529
  case atletico_madrid = 530
  case athletic_club = 531
  case real_betis = 543
  case real_sociedad = 548
  case valencia = 532
  case las_palmas = 534
  case getafe = 546
  case osasuna = 727
  case alaves = 542
  case villarreal = 533
  case sevilla = 536
  case rayo_vallecano = 728
  case mallorca = 798
  case celta_vigo = 538
  case cadiz = 724
  case granada_cf = 715
  case almeria = 723
  
  // MARK: J League
  case albirex_niigata = 311
  case avispa_fukuoka = 316
  case cerezo_osaka = 291
  case consadole_sapporo = 279
  case gamba_osaka = 293
  case jubilo_iwata = 280
  case kashima = 290
  case kashiwa_reysol = 281
  case kawasaki_frontale = 294
  case kyoto_sanga = 302
  case machida_zelvia = 303
  case nagoya_grampus = 288
  case sagan_tosu = 295
  case sanfrecce_hiroshima = 282
  case shonan_bellmare = 284
  case fc_tokyo = 292
  case tokyo_verdy = 306
  case urawa = 287
  case vissel_kobe = 289
  case yokohama_f_marinos = 296
  
  public var mainColorCode: String {
    switch self {
    case .other:
      ""
      // MARK: Premier
    case .arsenal:
      "EF0107"
    case .aston_villa:
      "95BFE5"
    case .bournemouth:
      "DA291C"
    case .brentford:
      "E30613"
    case .brighton:
      "0057B8"
    case .burnley:
      "6C1D45"
    case .chelsea:
      "034694"
    case .crystal_palace:
      "1B458F"
    case .everton:
      "003399"
    case .fulham:
      "000000"
    case .liverpool:
      "C8102E"
    case .luton_town:
      "FF4C00"
    case .manchester_city:
      "6CABDD"
    case .manchester_united:
      "DA291C"
    case .newcastle_united:
      "000000"
    case .nottingham_forest:
      "E53233"
    case .sheffield_united:
      "EE2737"
    case .tottenham_hotspur:
      "FFFFFF"
    case .west_ham_united:
      "7A263A"
    case .wolverhampton_wanderers:
      "FDB913"
      
      // MARK: Serie A
    case .inter:
      "0055A4"
    case .juventus:
      "000000"
    case .ac_milan:
      "D10000"
    case .atalanta:
      "003B5C"
    case .bologna:
      "D50032"
    case .as_roma:
      "9E1B32"
    case .lazio:
      "75B1E1"
    case .fiorentina:
      "5D2E8C"
    case .napoli:
      "2A7FFF"
    case .torino:
      "9E1B32"
    case .monza:
      "E30000"
    case .genoa:
      "9E1B32"
    case .lecce:
      "F7A800"
    case .frosinone:
      "FFCD00"
    case .udinese:
      "000000"
    case .empoli:
      "006AB6"
    case .sassuolo:
      "1E9C49"
    case .verona:
      "1E3A8A"
    case .cagliari:
      "9E1B32"
    case .salernitana:
      "9E1B32"
      
      // MARK: La Liga
    case .real_madrid:
      "FFFFFF"
    case .girona:
      "9E1B32"
    case .barcelona:
      "A50044"
    case .atletico_madrid:
      "E1001B"
    case .athletic_club:
      "E60012"
    case .real_betis:
      "3A6E47"
    case .real_sociedad:
      "0061B0"
    case .valencia:
      "F15A29"
    case .las_palmas:
      "FFD700"
    case .getafe:
      "0061B0"
    case .osasuna:
      "D90000"
    case .alaves:
      "005B9F"
    case .villarreal:
      "F1C400"
    case .sevilla:
      "E1001B"
    case .rayo_vallecano:
      "D10000"
    case .mallorca:
      "9E1B32"
    case .celta_vigo:
      "9FD9E8"
    case .cadiz:
      "F9E600"
    case .granada_cf:
      "D50000"
    case .almeria:
      "9E1B32"
      
      // MARK: J League
    case .albirex_niigata:
      "ff6600"
    case .avispa_fukuoka:
      "04407f"
    case .cerezo_osaka:
      "d40069"
    case .consadole_sapporo:
      "d7000f"
    case .gamba_osaka:
      "093fa6"
    case .jubilo_iwata:
      "6e9dd3"
    case .kashima:
      "b71840"
    case .kashiwa_reysol:
      "fff100"
    case .kawasaki_frontale:
      "35a0d9"
    case .kyoto_sanga:
      "74006b"
    case .machida_zelvia:
      "00236a"
    case .nagoya_grampus:
      "da361b"
    case .sagan_tosu:
      "0096d2"
    case .sanfrecce_hiroshima:
      "50318f"
    case .shonan_bellmare:
      "67b464"
    case .fc_tokyo:
      "214198"
    case .tokyo_verdy:
      "03764b"
    case .urawa:
      "e7002b"
    case .vissel_kobe:
      "8f0a1f"
    case .yokohama_f_marinos:
      "003989"
    }
  }
}
