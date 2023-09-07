//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Nestor Jimenez on 8/12/23.
//
/*
 - Each turn of the game the app will randomly pick either rock, paper, scissors : shuffle in an array, Int.random(in)
 - Each turn the app will alternate between prompting the player to win or lose: alert
 - the game ends after 10 questions, at which point their score is shown: message when the number of questions have been completed
 
 
 - If they get it right += 1, if they lose: -= 1
 - the player must tap (Button) the correct move to win or lose the game
 
 
 we want a variable to have the cpu rock, paper, scissor and compare it to the users answer
 
 Rules: rock >scissors | paper > rock | scissors > paper
 
 
 - the player must pick what beats rock or loses to rock
 */
import SwiftUI


struct showCircle : View {

    @State var selection :String
  //  @State var winLose : String

    var body: some View{
        ZStack{
          //  Circle()
            
            Button(selection) {}
                   // .foregroundColor(.green)
                   // .font(.system(size:200))
            
//            VStack(spacing: 40) {
//                Spacer()
//                Text(winLose)
//                    .foregroundColor(winLose == "Win" ? .green : .red)
//            }
            
        }
    }
}


struct ContentView: View {
    
    @State var playerScore = 0
    @State var questions = 10
    @State  var showAlert = false
    @State var resetAlert = false
    @State var shouldWin = Bool.random()
    @State var rps = ["🪨", "📄", "✂️"]
    @State var cpuChoice =  "🪨"
    @State var correctness = "incorrect"
    
    var body: some View {
        ZStack{
           
            RadialGradient(gradient: Gradient(colors: [ .purple, .cyan]), center: .bottom, startRadius: 2, endRadius: 850)
                .ignoresSafeArea()
            
            VStack(spacing: 50){
             //   Text("Score: \(playerScore)")
                Text("CPU CHOICE: \(cpuChoice)")
                    .padding()
                
                HStack(spacing: 50){

                    ForEach(0..<3){ num in
 
                        Button(rps[num]) {
 
                            updateQuestion()
                            evaluateAnswer(num)
                            showAlert = true

                        } .alert("", isPresented: $showAlert){
                           
                            if questions <= 0 {
                                
                                Button("restart") {
                                    
                                    newGame()
                                    resetAlert = true
                                }
                                
                            }
                            
                            else{
                                Button("Continue!") {
                                    refresh()
                                }
                            }
                            
                        } message: {
                            if questions <= 0 {
                                Text("Final Score: \(playerScore)")
                            }
                             
                            if correctness == "Correct" {
                                Text("Good Job!")
                            } else {
                                Text("Wrong!")
                            }
     
                        }
                    }
                    
                   
                }
                
                Text("OUTCOME:  \(shouldWin ? "win" : "lose")")
                               //    Text("\(playerScore)")
                                       .padding()
               

               // Spacer()
                
            }
        } .font(.system(size: 40))
    }
    
    
    
    
    func refresh(){
        cpuChoice = rps.randomElement() ?? "🪨"
        shouldWin.toggle()
    }
    
    
    func evaluateAnswer(_ userAnswer:Int){
        
        if cpuChoice == "🪨" && (rps[userAnswer] == "📄" || rps[userAnswer] == "✂️"){
            if !shouldWin  && rps[userAnswer] == "📄"{
                correctAnswer()
            } else if shouldWin && rps[userAnswer] == "✂️"{
                correctAnswer()
            } else {
                incorrectAnswer()
            }
        }
        
     else   if cpuChoice == "📄" && (rps[userAnswer] == "🪨" || rps[userAnswer] == "✂️") {
            if !shouldWin && rps[userAnswer] == "✂️" {
                correctAnswer()
            }
            else if shouldWin && rps[userAnswer] == "🪨" {
                correctAnswer()
            }
            else {
                incorrectAnswer()
            }
        }
        
      else  if cpuChoice == "✂️" && (rps[userAnswer] == "📄" || rps[userAnswer] == "🪨" ){
            if !shouldWin && rps[userAnswer] == "🪨" {
                correctAnswer()
            }
            else if shouldWin && rps[userAnswer] == "📄" {
                correctAnswer()
            }
            else {
                incorrectAnswer()
            }
        }
        
        else {
            incorrectAnswer()
        }
        
        

    }
    
    func updateQuestion(){
          questions -= 1
    }
    
    func newGame() {
        refresh()
        playerScore = 0
        questions = 10
    }
    
    func correctAnswer() {
        correctness = "Correct"
        playerScore += 1
    }
    func incorrectAnswer() {
        correctness = "Incorrect"
        playerScore -= 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
