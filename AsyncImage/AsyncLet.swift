//
//  AsyncLet.swift
//  AsyncImage
//
//  Created by vishnuprasad on 03/07/25.
//

import SwiftUI

struct AsyncLet: View {
    @State var images = [UIImage]()
    var body: some View {
        ScrollView{
            VStack {
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                    ForEach(images , id: \.self) { image in
                        Image(uiImage: image)
                    }
                }
            }
            .onAppear{
                Task{
                    do{
                        let img = try await fetchImg()
                        images.append(img)
                        let img1 = try await fetchImg()
                        images.append(img1)
                        let img2 = try await fetchImg()
                        images.append(img2)
                        async let imga = try await fetchImg()
                        async let imgb = try await fetchImg()
                        async let imgc = try await fetchImg()
                        images.append(contentsOf: [imga,imgb,imgc])
                    } catch{
                        
                    }
                }
            }
        }
    }
    func fetchImg() async throws -> UIImage {
        let urlString = URL(string: "https://picsum.photos/200")!
        do {
            let (data , _) = try await URLSession.shared.data(from: urlString, delegate: nil)
            if let image = UIImage(data: data){
                return image
            }else{
                return UIImage.checkmark
            }
        }catch {
            return UIImage.checkmark
        }
        
        
    }
}

#Preview {
    AsyncLet()
}
