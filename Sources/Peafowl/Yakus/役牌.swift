import Foundation

public struct 役牌: YakuProtocol {
    private let count: Int
    public var openedHan: Int? {
        return count
    }
    public var concealedHan: Int {
        return count
    }
    
    internal init(_ count: Int) {
        self.count = count
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
    public let name = "役牌"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 役牌? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let tripletsMelds = TileUtility.melds(from: tokens).filter { $0.isTriplets }
        let valueHonors: Set<Tile> = Set(tripletsMelds.compactMap { (meld) -> Tile? in
            if TileUtility.isValueHonor(meld.first, by: context) {
                return meld.first
            }
            return nil
        })
        if valueHonors.isEmpty {
            return nil
        }
        let hanCount: Int
        if valueHonors.contains(context.prevalentWind) && context.prevalentWind == context.seatWind {
            hanCount = valueHonors.count + 1
        } else {
            hanCount = valueHonors.count
        }
        return 役牌(hanCount)
    }
}
