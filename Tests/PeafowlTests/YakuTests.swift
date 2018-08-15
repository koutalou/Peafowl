import Foundation
import XCTest
@testable import Peafowl

final class OrdinaryFormedYakuTests: XCTestCase {
    private let tokenizer = Tokenizer()
    
    private func searchWinningYaku<Yaku: YakuProtocol>(_ yaku: Yaku.Type, hand: Hand, context: GameContext) -> [Yaku] {
        let tokenizedResults = tokenizer.tokenize(from: hand.allTiles)
        let yakuList = tokenizedResults.map { tokenizedResult in
            return Yaku.make(with: hand.allTiles,
                             form: .ordinary(Tokenizer.convertToWinningForm(from: tokenizedResult)!),
                             picked: hand.picked,
                             context: context)
            }.compactMap { $0 }
        return yakuList
    }
    
    private func assert<Yaku: YakuProtocol>(_ hand: Hand, shouldBe yaku: Yaku.Type, context: GameContext? = nil) {
        let yakuList = searchWinningYaku(yaku, hand: hand, context: context ?? makeContext())
        XCTAssertFalse(yakuList.isEmpty)
    }
    
    private func assert<Yaku: YakuProtocol>(_ hand: Hand, shouldNotBe yaku: Yaku.Type, context: GameContext? = nil) {
        let yakuList = searchWinningYaku(yaku, hand: hand, context: context ?? makeContext())
        XCTAssertTrue(yakuList.isEmpty)
    }
    
    private func assert<Yaku: YakuProtocol>(_ eye: (Tile, Tile),
                                            _ meld0: (Tile, Tile, Tile),
                                            _ meld1: (Tile, Tile, Tile),
                                            _ meld2: (Tile, Tile, Tile),
                                            _ meld3: (Tile, Tile, Tile),
                                            shouldBe yaku: Yaku.Type,
                                            context: GameContext? = nil) {
        let hand = makeHand(eye, meld0, meld1, meld2, meld3)
        assert(hand, shouldBe: yaku)
    }
    
    private func assert<Yaku: YakuProtocol>(_ eye: (Tile, Tile),
                                            _ meld0: (Tile, Tile, Tile),
                                            _ meld1: (Tile, Tile, Tile),
                                            _ meld2: (Tile, Tile, Tile),
                                            _ meld3: (Tile, Tile, Tile),
                                            shouldNotBe yaku: Yaku.Type,
                                            context: GameContext? = nil) {
        let hand = makeHand(eye, meld0, meld1, meld2, meld3)
        assert(hand, shouldNotBe: yaku)
    }
    
    func test断ヤオ() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldBe: 断ヤオ九.self)
        assert((一筒, 一筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 断ヤオ九.self)
    }
    
    func test一盃口() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (三萬, 四萬, 五萬), shouldNotBe: 一盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldBe: 一盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四索, 五索, 六索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 一盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三索, 四索, 五索), (六索, 七索, 八索), shouldNotBe: 一盃口.self)
    }
    
    func test二盃口() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (三萬, 四萬, 五萬), shouldBe: 二盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 二盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四索, 五索, 六索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 二盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三索, 四索, 五索), (六索, 七索, 八索), shouldNotBe: 二盃口.self)
    }
    
    func test三色同順() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldBe: 三色同順.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四筒, 五筒, 六筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldNotBe: 三色同順.self)
    }
    
    func test三色同刻() {
        assert((二筒, 二筒), (三索, 三索, 三索), (三筒, 三筒, 三筒), (三萬, 三萬, 三萬), (東, 東, 東), shouldBe: 三色同刻.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldNotBe: 三色同刻.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四筒, 五筒, 六筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldNotBe: 三色同刻.self)
        assert((二筒, 二筒), (東, 東, 東), (南, 南, 南), (西, 西, 西), (北, 北, 北), shouldNotBe: 三色同刻.self)
    }
}

final class SevenPairsFormedYakuTests: XCTestCase {
    func test七対子() {
        let context = makeContext()
        let hand0: Hand = [東, 東, 南, 南, 西, 西, 北, 北, 白, 白, 撥, 撥, 中, 中]
        XCTAssertNotNil(七対子.make(with: hand0.allTiles, form: .sevenPairs, picked: hand0.picked, context: context))
        
        let hand1: Hand = [東, 東, 東, 東, 西, 西, 北, 北, 白, 白, 撥, 撥, 中, 中]
        XCTAssertNotNil(七対子.make(with: hand1.allTiles, form: .sevenPairs, picked: hand1.picked, context: context))
    }
}