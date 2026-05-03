import SwiftUI

@main
struct AlphabetizerApp: App {
    @State private var alphabetizer = Alphabetizer() //インスタンスを作成して、環境に保存
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(alphabetizer)
        }
    }
}
