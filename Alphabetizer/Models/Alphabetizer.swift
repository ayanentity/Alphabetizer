//
//  Alphabetizer.swift
//  Alphabetizer
//
//  Created by 仲里絢音 on 2026/05/03.
//
// ゲームロジックを処理し、UIの状態を制御するクラス

import Foundation

@Observable //特定のビューに依存しないデータモデルクラス
class Alphabetizer {
    private var tileCount = 3
    private var vocab: Vocabulary
    
    var tiles = [Tile]()
    var score = 0
    var message: Message = .instructions //メッセージステータスの指定
    
    init(vocab: Vocabulary = .landAnimals){
        self.vocab = vocab
        startNewGame()
    }
    
   // private var isAlphabetized = false //正誤判定
    
    
    
    func submit() {
        
        let userSortedTiles = tiles.sorted { //ユーザーが並べた順（画面上のx座標で判断）
           $0.position.x < $1.position.x
       }
       let alphabeticallySortedTiles = tiles.sorted { //// 正しいアルファベット順
           $0.word.lexicographicallyPrecedes($1.word)
       }
        let isAlphabetized = userSortedTiles == alphabeticallySortedTiles //ここでさっきのexrtensionを使っている．userSortedTiles（lhs） == alphabeticallySortedTiles(rhs)これの比較結果boolを代入

        if isAlphabetized { //trueならポイントを追加
            score += 1
        }
        
        message = isAlphabetized ? .youWin : .tryAgain //状態に応じてメッセージを代入
        
        for (tile, correctTile) in zip(userSortedTiles, alphabeticallySortedTiles) {
            // TODO: Check if this tile is in the correct position
            let tileIsAlphabetized = tile == correctTile
            tile.flipped = tileIsAlphabetized
        }
        
        Task { @MainActor in
            // Delay 2 seconds
            try await Task.sleep(for: .seconds(2))
            
            
            // If alphabetized, generate new tiles
            if isAlphabetized {
                startNewGame()
            }
            
            // Flip tiles back to words
            for tile in tiles {
                tile.flipped = false
            }
            
            message = .instructions // Display instructions
        }
    }
    
    
    // MARK: private implementation
    
    
    /// Updates `tiles` with a new set of unalphabetized words
    private func startNewGame() {
        let newWords = vocab.selectRandomWords(count: tileCount)
        if tiles.isEmpty { // 最初：新しくカードを作る
            for word in newWords {
                tiles.append(Tile(word: word))
            }
        } else {
            for (tile, word) in zip(tiles, newWords) { //2回目以降はカードの単語を変えるだけ
                tile.word = word
            }
        }
    }
}
