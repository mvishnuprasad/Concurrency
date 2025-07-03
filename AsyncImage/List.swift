//
//  List.swift
//  AsyncImage
//
//  Created by vishnuprasad on 02/07/25.
//

import SwiftUI
class ListVm : ObservableObject{
    @Published var items : [String] = ["One \(Thread.current)"]
    func append() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        var item = "Two \(currentThreadInfo())"
        items.append(item)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            items.append("Three \(currentThreadInfo())")
        }
        
        await append2()
      
    }
    func append2() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        var item = "Four \(currentThreadInfo())"
        items.append(item)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            items.append("Five \(currentThreadInfo())")
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    func currentThreadInfo() -> String {
        Thread.isMainThread ? "MainThread" : "BackgroundThread"
    }
}
struct ListUI: View {
    @StateObject var listVM = ListVm()
   
    var body: some View {
        List{
            ForEach(listVM.items , id: \.self) { item in
                Text("\(item)")
                
            }
         
        }
        .onAppear{
            Task{
                await listVM.append()
                var item = "Six \(listVM.currentThreadInfo())"
                listVM.items.append(item)
            }
        }
    }
}

#Preview {
    ListUI()
}
