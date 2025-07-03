//
//  TaskView.swift
//  AsyncImage
//
//  Created by vishnuprasad on 02/07/25.
//

import SwiftUI
class TaskVm: ObservableObject {
    let url = URL(string: "https://picsum.photos/200")
    @Published var image : UIImage? = nil
    @Published var image2 : UIImage? = nil
    func fetch() async {
        guard let url = url else {return}
        do{
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Imag")
            }
        }catch {
            
        }
       
    }
    func fetch2() async {
        guard let url = url else {return}
        do{
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
                print("Imag")
            }
        }catch {
            
        }
    }
}
struct Another : View {
    var body: some View {
        NavigationView {
            NavigationLink("Text") {
                TaskView()
            }
        }
    }
}
struct TaskView: View {
    @StateObject var vm = TaskVm()
    @State private var tasks : Task<(),Never>? = nil
    @State private var task2 : Task<(),Never>? = nil

    var body: some View {
       
        VStack{
            if let img = vm.image{
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 200,height: 200)
            }
            if let img = vm.image2{
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 200,height: 200)
            }
        }
        .task{
          
                await vm.fetch()
           
                await vm.fetch2()
            
        }
//        .onAppear{
//            tasks = Task{
//                await vm.fetch()
//               
//            }
//            task2 = Task{
//                await vm.fetch2()
//            }
//        }
//        .onDisappear {
//            task2?.cancel()
//            tasks?.cancel()
//        }
    }
}

#Preview {
    TaskView()
}
