//
//  ContentView.swift
//  rock-paper-scissors
//
//  Created by Denis Evdokimov on 5/24/24.
//

import SwiftUI

enum Moves: String, CaseIterable {
    case paper = "paper"
    case rock = "rock"
    case scissors = "scissors"
}

struct ContentView: View {
    private let moves =  Moves.allCases
    @State private var loseWin: Bool = Bool.random() // какой исход нужно получить
    @State private var randomChoice = Int.random(in: 0...2)// для чего выбираем исход
    @State private var moveCount = 0
    @State private var score: Int = 0
    @State private var showfinalAlert = false
    
    var body: some View {
        VStack {
            Text("Раунд \(moveCount + 1)")
                .font(.headline)
            Spacer()
            HStack {
                Spacer(minLength: 50)
                moveImage(name: moves[randomChoice].rawValue)
                Spacer(minLength: 50)
            }
            Text("Нужно \(loseWin == true ?  "выиграть!" : "проиграть!")")
                .font(.largeTitle)
            HStack {
                ForEach(moves, id: \ .self) { move in
                    Button(action: {tapped(move.rawValue)}, label: {
                        moveImage(name: move.rawValue)
                    })
                }
            }
            Spacer()
           
            Text("Очки: \(score)")
            
        }
        .padding()
        .alert("Итоговые очки: \(score)", isPresented: $showfinalAlert) {
            Button("Restart") {
                reset()
            }
        }
    }
    
    private func tapped(_ name: String) {
        // randomChoice = 0 - paper, 1 - rock, 2 - scissors
        moveCount += 1
        switch loseWin {
        case true: //  нужно победить
            switch Moves(rawValue: name) {
            case .paper: // мы выбрали бумагу
                if randomChoice == 1 {score += 1} else {score -= 1} // камень
            case .rock: // мы выбрали камень
                if randomChoice == 2 {score += 1} else {score -= 1} // ножницы
            case .scissors: // мы выбрали ножницы
                if randomChoice == 0 {score += 1} else {score -= 1} // бумага
            case .none:
                fatalError()
            }
        case false: // нужно проиграть
            switch Moves(rawValue: name) {
            case .paper:
                if randomChoice == 2 {score += 1} else {score -= 1} // ножницы
            case .rock:
                if randomChoice == 0 {score += 1} else {score -= 1} // бумага
            case .scissors:
                if randomChoice == 1 {score += 1} else {score -= 1} // ножницы
            case .none:
                fatalError()
            }
        }
        
        loseWin = Bool.random()
        randomChoice =  Int.random(in: 0...2)
        if moveCount == 10 {
            showfinalAlert.toggle()
        }
    }
    private  func reset() {
        moveCount = 0
        score = 0
        showfinalAlert.toggle()
        
    }
 }

#Preview {
    ContentView()
}

struct moveImage: View {
    let name: String
    var body: some View {
        Image(name, bundle: nil)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
