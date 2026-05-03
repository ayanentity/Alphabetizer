import SwiftUI

struct MessageView: View {
    @Environment(Alphabetizer.self) private var alphabetizer
    
    @State private var message = "Place the tiles in alphabetical order"

    var body: some View {
        Text(alphabetizer.message.rawValue) //.rawValue で中身の文字列を取り出している.ステータスを取り出していない
            .font(.largeTitle)
    }
}

#Preview {
    MessageView()
        .environment(Alphabetizer())
}

#Preview("winner") {
    let alphabetizer = Alphabetizer()
    alphabetizer.message = .youWin
    return MessageView()
        .environment(alphabetizer)
}
