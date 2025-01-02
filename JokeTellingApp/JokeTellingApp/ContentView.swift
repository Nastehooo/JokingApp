import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack { // Move NavigationStack to wrap the entire body
            VStack {
                Image("Image")
                    .resizable()
                    .frame(width: 450.0, height: 450.0)
                    .foregroundStyle(.tint)
                
                NavigationLink(destination: HomePage()) {
                    Text("TELL ME A JOKE")
                        .font(.custom(
                            "AppleColorEmoji",
                            fixedSize: 25))
                        .padding()
                        .cornerRadius(10)
                        .background(Color("Color 1"))
                        .overlay(
                                RoundedRectangle(cornerRadius: 10) // The border shape
                                .stroke(Color.black, lineWidth: 2) // Black border with line width 2
                                )
                    
                }
                .buttonStyle(PlainButtonStyle())
    
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Color"))
        }
    }
}


#Preview {
    ContentView()
}
