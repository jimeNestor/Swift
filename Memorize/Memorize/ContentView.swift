//
//  ContentView.swift
//  Memorize
//
//  Created by Nestor Jimenez on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    var carTheme = ["🚗", "🚙", "🏎️", "🚖", "🚓", "🚙", "🚗", "🏎️", "🚖", "🚓"]
    var fruitTheme = ["🍒", "🍓", "🍇", "🍎", "🍎","🍒", "🍓", "🍇", "🍎", "🍎"]
    var sportTheme = ["⚽️", "🏈", "⚾️", "🥎", "🏐", "⚽️", "🏈", "⚾️", "🥎", "🏐"]

    @State var selectedTheme : Array<String>  = []
    var cardCount =  10

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
            .padding()
    }
    
    
    //Creates all cards by using CardView
    var Card: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92))]) {
            if !selectedTheme.isEmpty {
                ForEach(0..<cardCount, id: \.self){ index in
                    CardView(theme: selectedTheme[index])
                        .aspectRatio(2/3, contentMode: .fit)
                }
            }
        }
    }
    
    var carThemeButton: some View {
        Button(action: {
            selectedTheme = themeSetter(selected: "car")
        }, label: {
            themeButtonCreator(buttonTheme: "car", themeName: "car")
        })
    }
    
    var fruitThemeButton: some View {
        Button(action: {
            selectedTheme =  themeSetter(selected: "fruit")
        }, label: {
                themeButtonCreator(buttonTheme: "takeoutbag.and.cup.and.straw.fill", themeName: "fruits")
        })
    }
    
    var sportThemeButton: some View {
        Button(action: {
            selectedTheme = themeSetter(selected: "sport").shuffled()
        }, label: {
            themeButtonCreator(buttonTheme: "figure.jumprope", themeName: "sport")
        })
    }
    
    var themeLayout: some View {
        HStack {
            carThemeButton
                .onTapGesture {
                   selectedTheme = themeSetter(selected: "car")
                }
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


    // MARK: TODO - set overall theme
    func themeSetter(selected: String) -> [String] {
        switch selected {
        case "car":
            return carTheme.shuffled()
        case "sport":
            return sportTheme
        case "fruit":
            return fruitTheme
        default:
            return []
        }
       
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
struct themeButtonCreator: View{
    var buttonTheme: String
    var themeName: String
    
    var body: some View {
            Label("\(themeName)", systemImage: buttonTheme)
    }
}



#Preview {
    ContentView()
}
