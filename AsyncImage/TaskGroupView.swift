//
//  TaskGroupView.swift
//  AsyncImage
//
//  Created by vishnuprasad on 03/07/25.
//

import SwiftUI
class TaskGroupNW {
    func returnImages() async throws-> [UIImage]{
        var img = [UIImage]()
        async let image = fetchWithTaskGroup()
        
        try await img.append(contentsOf: image)
        return img
        
    }
    private func fetch() async throws -> UIImage {
        let url = "https://picsum.photos/200"
        guard let url = URL(string: url) else {throw URLError(.badURL)}
        do{
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            if let img = UIImage(data: data){
                return img
            }else{
                throw URLError(.badURL)
            }
        }catch {
            throw error
        }
        
    }
    func fetchWithTaskGroup() async throws -> [UIImage]{
        var images : [UIImage] = []
        return try await withThrowingTaskGroup(of: UIImage.self, body: { group in
            
            group.addTask {
                try await self.fetch()
                
            }
            group.addTask {
                try await self.fetch()
                
            }
            group.addTask {
                try await self.fetch()
                
            }
            group.addTask {
                try await self.fetch()
                
            }
            for try await taskResult in group {
                images.append(taskResult)
            }
            return images
        })
    }
}
class TaskGroupVM : ObservableObject{
    @Published  var images : [UIImage] = []
    func getImages() async {
        if let img = try? await TaskGroupNW().returnImages(){
            self.images.append(contentsOf: img)
        }
    }
    
    
}
struct TaskGroupView: View {
    @StateObject private var vm = TaskGroupVM()
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                ForEach(vm.images , id: \.self) { image in
                    Image(uiImage: image)
                }
            }
        }.task {
            await vm.getImages()
        }
    }
}

#Preview {
    TaskGroupView()
}
