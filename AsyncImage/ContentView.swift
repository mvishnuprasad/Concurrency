//
//  ContentView.swift
//  AsyncImage
//
//  Created by vishnuprasad on 02/07/25.
//
import SwiftUI

class NW  {
    let url = URL(string: "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?_gl=1*1jyir0v*_ga*MjY3NzI2ODE2LjE3NTEyOTY2MzY.*_ga_8JE65Q40S6*czE3NTE0NDY3NjQkbzMkZzEkdDE3NTE0NDY3NjUkajU5JGwwJGgw")!//
    
    func fetchImg() async throws -> UIImage?{
        do {
            let received =  try await URLSession.shared.data(from: url, delegate: nil)
            return UIImage(data: received.0)
        }catch{
            return UIImage(systemName: "flame")
        }
    }
}
class VM : ObservableObject {
    @Published var image : UIImage?
    func fetch () async {
        let img = try? await NW().fetchImg()
        await MainActor.run  {
            self.image = img
        }
    }
}
struct ContentView: View {
    @StateObject var vm = VM()
    var body: some View {
        Text("Title")
            .onAppear{
                Task{
                    await vm.fetch()
                }
            }
        if vm.image != nil {
            Image(uiImage: vm.image!)
        }
    }
}

#Preview {
    ContentView()
}
struct ExtractedView: View {
    var body: some View {
        VStack{
            Color.red
        }
    }
}
