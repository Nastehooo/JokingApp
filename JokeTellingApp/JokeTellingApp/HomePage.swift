import SwiftUI
import AVFoundation

struct Joke: Identifiable, Codable {
    let id: Int
    let setup: String
    let punchline: String
}

struct HomePage: View {
    @State private var joke: Joke? = nil
    @State private var isLoading = false
    @State private var selectedLanguage = "en-GB"
    private let synthesizer = AVSpeechSynthesizer()
    
    let languages = ["en-GB": "English (UK)"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    // Custom Title
                    Text("Joke Teller")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    // Robot Image
                    Image("Image") // Replace with your robot image
                        .resizable()
                        .scaledToFit()
                        .frame(width: min(geometry.size.width * 0.8, 450), height: 300)
                        .padding()
                    
                    // Display Loading or Joke Text
                    if isLoading {
                        ProgressView("Loading Joke...")
                            .font(.headline)
                    } else if let joke = joke {
                        ScrollView {
                            VStack(alignment: .center) {
                                Text(joke.setup)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: geometry.size.width * 0.9)
                                    .padding()
                                Text(joke.punchline)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: geometry.size.width * 0.9)
                                    .padding()
                            }
                        }
                    } else {
                        Text("Press the button to hear a joke!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: geometry.size.width * 0.9)
                            .padding()
                    }
                    
                    // Fetch Joke Button
                    Button(action: fetchJoke) {
                        Text("TELL ME A JOKE")
                            .font(.headline)
                            .font(.system(size: 30))
                            .padding()
                            .background(Color("Color 1"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
    
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Color"))
            }
        }
    }
    
    // Fetch Joke from API
    func fetchJoke() {
        isLoading = true
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_joke") else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data, let fetchedJoke = try? JSONDecoder().decode(Joke.self, from: data) {
                    self.joke = fetchedJoke
                    self.speak(joke: fetchedJoke)
                } else {
                    self.joke = nil
                }
            }
        }.resume()
    }
    
    // Text-to-Speech
    func speak(joke: Joke) {
        let utterance = AVSpeechUtterance(string: "\(joke.setup). \(joke.punchline)")
        utterance.voice = AVSpeechSynthesisVoice(language: selectedLanguage)
        utterance.rate = 0.5 // Adjust the rate if needed
        synthesizer.speak(utterance)
    }
}

// SwiftUI Preview
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
