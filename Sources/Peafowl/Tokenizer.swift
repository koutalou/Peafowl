import Foundation

private func move<T: Token>(_ token: T, from tiles: inout [Tile], to tokens: inout [T]) {
    tiles.removeToken(token)
    tokens.append(token)
}

internal func findMelds(from tiles: [Tile]) -> Set<SetToken> {
    return Set(tiles.compactMap { tile in
        if tiles.count(tile) >= 3 {
            return SetToken(tiles: (tile, tile, tile))
        }
        return nil
    })
}

internal func findChows(from tiles: [Tile]) -> Set<SetToken> {
    return Set(tiles.compactMap { tile in
        guard let previousTile = tile.previous, tiles.contains(previousTile) else {
            return nil
        }
        guard let nextTile = tile.next, tiles.contains(nextTile) else {
            return nil
        }
        guard let newChow = SetToken(tiles: (previousTile, tile, nextTile)) else {
            return nil
        }
        return newChow
    })
}

internal final class Tokenizer {
    private let hand: Hand
    
    init(hand: Hand) {
        self.hand = hand
    }
    
    func tokenize() {
        let eyes = Set(findEyes(hand.allTiles))
        for eye in eyes {
            var mutableTiles = self.hand.allTiles
            mutableTiles.removeToken(eye)
        }
    }
    
    func findSets(_ tiles: [Tile]) -> Set<SetToken> {
        return findChows(from: tiles).union(findMelds(from: tiles))
    }
    
    func findEyes() -> [PairToken] {
        return findEyes(hand.allTiles)
    }
    
    func findEyes(_ tiles: [Tile]) -> [PairToken] {
        var mutableTiles = tiles
        var results: [PairToken] = []
        for tile in tiles {
            if mutableTiles.count(tile) >= 2 {
                guard let newPair = PairToken(tiles: (tile, tile)) else { continue }
                move(newPair, from: &mutableTiles, to: &results)
            }
        }
        return results
    }
}
