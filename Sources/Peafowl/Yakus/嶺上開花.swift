import Foundation

public struct 嶺上開花: YakuProtocol {
    public let openedHan: Int? = 1
    public let closedHan: Int = 1
    
    public let name = "嶺上開花"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 嶺上開花? {
        if context.winningType == .selfPick && context.pickedSource == .deadWall {
            return 嶺上開花()
        }
        return nil
    }
}
