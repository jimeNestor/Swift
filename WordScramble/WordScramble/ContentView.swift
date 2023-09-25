//
//  ContentView.swift
//  WordScramble
//
//  Created by Nestor Jimenez on 9/18/23.
//

import SwiftUI

struct ContentView: View {
    @State var rootWord = "" //the word that we want the user to spell from
    @State var usedWords = [String]() //array to keep all words already used
    @State var newWord = "" //the new word that the user inputs
    @State var words = [String]() //words that we gather from the file
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var currentScore = 0
    
    
    var body: some View {
      
        NavigationStack {
            viewForScore
            List {
               
                
                Section(content: {
                    TextField("Enter your word:", text: $newWord)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                }, header: {
                    Text("Insert your word below:")
                        .bold()
                })
                
                
                Section(content: {
                    ForEach(usedWords, id: \.self) { word in
                        
                        HStack {
                            Text(word)
                            Image(systemName: "\(word.count).circle") //we have to put our integer in the parenthesis because its still a variable, the system now is a string
                        }
                    }
                    .onDelete(perform:delete) //allows user to remove the used word.
                }, header: {
                    Text("Words Already Used:")
                })
                
                
                
                
                .listStyle(InsetListStyle())
            }
            
            
            .navigationTitle($rootWord)
            .onSubmit(addNewWord) //triggered when any text is submitted
            //the action will perform before the view is present.
            .onAppear(perform: {
                startGame()
            })
            
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            
            .toolbar(content: {
                HStack(alignment: .bottom, spacing: 30){
                    // viewForScore
                    newWordButton
                    newGameButton
                    
                }
               
                
            })
        }
        
    }
    
    /*
     Custom button to press new word
     */
    
    var newWordButton: some View {
        Button("New Word", action: startGame)
    }

    //custom view to show the score of the user
    var viewForScore: some View {
      
        ZStack {
            Circle()
                .frame(width: 15, height: 15)
                .opacity(-0.75)
            HStack{
            Text("Score: \(currentScore)")
                .fontDesign(.serif)
                .bold()
            }
        }
            
    }
    
    //view for new game button
    var newGameButton:some View {
        Button("New Game") {
            newGame()
        }
    }
    
    func newGame() {
        usedWords.removeAll()
        currentScore = 0
        startGame()
        
    }
    
    func delete(indexSet:IndexSet){
        usedWords.remove(atOffsets: indexSet)
    }
    
    func addNewWord(){
        
        guard newWord.count >= 1 else { return }
        
        let answer = newWord.lowercased().trimmingCharacters(in:.whitespacesAndNewlines)
        
        //we do all the checking of the answer provided by the user and get an error and return
        guard wordIsGreaterThanThree(word: answer) else {wordError(title: "Input Word is Too Short", message: "Think of a longer word")
            return
        }
        
        guard isNewWordTheRootWord(word: answer) else {
            wordError(title: "DONT USE THE ROOT WORD", message: "You got this, use another word")
            return
        }
        
        guard isOriginal(word: answer) else { wordError(title: "Word Already Used", message: "Be more Original")
            return
        }
        
        guard isWordPossible(word: answer) else { wordError(title: "This word is not possible", message: "You can't spell that word with the root word provided")
            return
        }
        guard isReal(word: answer) else { wordError(title: "This isn't a real word", message: "You have to put an actual word")
            return
        }
        
            withAnimation { //anything we want to have an animation, we use this, we can do other things with it
                usedWords.insert(answer, at: 0)
                currentScore += answer.count
            }
        
       
        newWord = ""
    }
    
    //uses url for local files in the app
       /*
         - we want to find a file in our app bundle
        budle.main.url if it exists in the bundle, if not we get back Nil so it's an optional
        
        - if stored in a user device, it'll have a massive path to avoid malicious intent of users data.
        
        - Apple says it's sandboxing, we can't read files from places out of our given box.
        
        */
    /*
     Method that searches for the file with words
     - we get rid of all new lines and place the strings in an array,
     we then set the rootword to one of the many words we got.
     */
    func startGame(){
        //always find the file first
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            //we are loading up all the strings in start.txt into an a string
            if let word = try? String(contentsOf: startWordsURL) {
                //we are loading all the strings into an array, when there's a new line, it's a new element
                let allWords = word.components(separatedBy: "\n")
                //we set a random word to the root word, if it's empty then we have silkworm
                rootWord =  allWords.randomElement() ?? "silkworm"
                
                return
            }
            //when we run into this fatal error, it will completely stop the app!
            fatalError("Unable to open")
        }
       
    }
    
    
    /*
     Four methods:
     1. is the word original (has it been used)
     2. is the word posible, they cant try to spell car from silkworm
     3. is the word real!
     4. showing error messages easier
     */
    func isOriginal(word:String)-> Bool {
        !usedWords.contains(word)
    }
    
    func isWordPossible(word:String) -> Bool{
        var copyOfRoot = rootWord
        
        for letter in word{
            if let pos = copyOfRoot.firstIndex(of: letter){
                copyOfRoot.remove(at: pos)
            } else{
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
   
    /*
     this makes it easier because it sets the title, message, and flips to show the alert, rather than having to do it in the alert itself.
     */
    
    func wordError(title:String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func wordIsGreaterThanThree(word:String) -> Bool{
        word.count >= 3
    }
    
    func isNewWordTheRootWord(word:String)->Bool{
        word != rootWord
    }
  
}

#Preview {
    ContentView()
}
