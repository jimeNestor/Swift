//
//  ContentView.swift
//  Memorize
//
//  Created by Nestor Jimenez on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    var carTheme = ["🚗", "🚙", "🏎️", "🚖", "🚓", "🚙", "🚗", "🏎️", "🚖", "🚓"]
    var cardCount =  10
    var fruitTheme = ["🍒", "🍓", "🍇", "🍎", "🍎"]
    var sportTheme = ["⚽️", "🏈", "⚾️", "🥎", "🏐"]
@State var selectedTheme = [String]()

    var body: some View {
        
        VStack {
            appTitle
            VStack {
                ScrollView {
                    Card
                }
                Spacer()
            }
        }
        themeLayout
    }
    
    
    //Creates all cards by using CardView
    var Card: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
            ForEach(0..<cardCount, id: \.self){ index in
               CardView(theme: carTheme[index])
                    .aspectRatio(2/4, contentMode: .fit)
            }
        } .foregroundStyle(.teal)
    }
    var carThemeButton: some View {
        themeButtonCreator(selectedTheme: carTheme, buttonTheme: "car", themeName: "car")
    }
    
    var fruitThemeButton: some View {
       themeButtonCreator(selectedTheme: fruitTheme, buttonTheme: "takeoutbag.and.cup.and.straw.fill", themeName: "fruits")
    }
    
    var sportThemeButton: some View {
        themeButtonCreator(selectedTheme: sportTheme, buttonTheme: "figure.jumprope", themeName: "sport")
    }
    
    var themeLayout: some View {
        HStack {
            carThemeButton
            Spacer()
            fruitThemeButton
            Spacer()
            sportThemeButton
        }
        .padding()
        .font(.title)
    }
    
    var appTitle: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .bold()
    }

    
}


//View that creates the cards frame
struct CardView: View {
    let theme: String
    @State var isFaceup: Bool = false
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12.0)
            Group{
                base
                    .foregroundStyle(.green)
                base
                    .strokeBorder(lineWidth: 2)
                Text(theme).font(.largeTitle)
            }
            .opacity(isFaceup ? 1 : 0)
            base.fill().opacity(isFaceup ? 0 : 1)
        }
        .onTapGesture(count: 2) {
            isFaceup.toggle()
        }
        .padding()
    }
}

//View to create buttons for themes
struct themeButtonCreator: View {
    var selectedTheme: [String]
    var buttonTheme: String
    var themeName: String
    
    var body: some View {
        VStack {
            Button(action: {

            }, label: {
                Image(systemName: buttonTheme)
            })
            Text(themeName)
                .foregroundStyle(.blue)
                .font(.footnote)
        }
    }
}



#Preview {
    ContentView()
}
