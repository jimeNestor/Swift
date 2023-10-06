//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nestor Jimenez on 8/8/23.
//

import SwiftUI


/*
 Example of View Composition:
 
 - We create our own view here
 
 - we have the body return a view of an image with the modifiers we want to return
 - this cleans up the body of our ContentView
 - we provide the property imageName to the view so it can take in the name of the image that we will pass into the View and will populate the image
 */
struct FlagImage: View {
    
    var imageName : String
    
    var body : some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}





struct ContentView: View {
    @State private var showSpin = false
    @State private var showingAlert = false
    @State private var finalAlert = false
    @State private var incorrectAnswer = 0
    @State private var correctAnswer = Int.random(in: 0...2) //Randomly picks number so we decide which country flag should be tapped
    @State private var scoreTitle: Bool = false
    @State private var overAllScore = 0
    let maxNumberOfAttempts = 8
    @State private var numberOfTries = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    
    var body: some View {
        
        
        ZStack {
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),],
                           center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    VStack {
                        
                        Text("Tap the flag of:")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .foregroundColor(.primary)
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                    
                    
                    ForEach(0..<3) { number in
                        
                        Button {
                            isFlagCorrect(number)
                            //explicit animation, this is just worried about the state change, it will make a smooth animation that takes 2 seconds to complete
                            withAnimation(.smooth(duration: 2)) {
                                showSpin.toggle()
                            }
                            
                         

                        }  label: {
                            FlagImage(imageName: countries[number])
                            //this animation will show to rotate the correct flag selected 360 degrees
                            //here we check for the correct answer is select and if showSpin is true. 
                                .rotationEffect(correctAnswer == number && scoreTitle && showSpin ? /*@START_MENU_TOKEN@*/.zero/*@END_MENU_TOKEN@*/ : Angle(degrees: 360.0), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        } .alert("", isPresented: $showingAlert) {
                            
                            if numberOfTries == maxNumberOfAttempts {
                                Button("Reset") {
                                    showingAlert = true
                                    askQuestion()
                                    reset()
                                }
                            }
                            // if they answer correctly
                            else if scoreTitle {
                                Button("Correct!"){
                                    askQuestion()
                                }
                            }
                            
                            else if !scoreTitle  {
                                Button("Try Again") {}
                            }
                        } message: {
                            if numberOfTries == maxNumberOfAttempts {
                                Text("Score: \(overAllScore) out of \(maxNumberOfAttempts)")
                            }
                            if !scoreTitle {
                                Text("Wrong! that's the flag of \(countries[incorrectAnswer]) ")
                            } else{
                                Text("Good job!")
                            }
                            
                        }

                        
                        
                    }
                    
                    
                
                    
                   
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20) //provides space from the top so the view isn't right above the text
                .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Text("Score: \(overAllScore)")
                    .font(.title.bold())
                    .foregroundColor(.white)
              //  Text("\(numberOfTries)")
                Spacer()
                
            }
            
            .padding()
            
            
        } 

    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    
    func isFlagCorrect(_ number: Int){
    
        if number == correctAnswer {
            scoreTitle = true
            if numberOfTries < maxNumberOfAttempts {
                attemptMade()
            }
            correctAnswerGiven()
        }
        else {
            scoreTitle = false
            incorrectAnswer = number
        }
        
        showingAlert = true
    }
    
    func correctAnswerGiven(){
        overAllScore += 1
    }
    
    func attemptMade(){
        numberOfTries += 1
    }
    
    func reset() {
        overAllScore = 0
        numberOfTries = 0
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
