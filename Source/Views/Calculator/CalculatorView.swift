//
//  CalculatorView.swift
//  Converter (iOS)
//
//  Created by johann casique on 8/7/22.
//

import SwiftUI

struct CalculatorView: View {
    
    @Binding var isPresented: Bool
    @State private var numberLabel = "0"
    @State private var formatNumber = ""
    @Binding var customAmount: String
    
    enum CustomAmount: String {
        case thousand = "1K"
        case houndred = "100"
        case ten = "10"
        case one = "1"
    }
    
    let numberFont = Font
        .system(size: 65)
    
    
    let currencyCodeFont = Font
        .title2
    
    var formatter: NumberFormatter = {
        let format = NumberFormatter()
        format.maximumFractionDigits = 5
        format.minimumFractionDigits = 0
        format.numberStyle = .decimal
        return format
    }()
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image("CO")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40).clipped().cornerRadius(4)
                    .padding(.leading, 0)
                
                VStack(alignment: .leading) {
                    Text("COP")
                        .font(.title3)
                    Text("Colombian peso")
                        .font(.title3)
                }
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .frame(width: 60, height: 40)
            }
            .padding()
            HStack() {
                Spacer()
                
                Text(numberLabel)
                    .minimumScaleFactor(0.01)
                    .font(numberFont)
                    .lineLimit(0)
                
                Text("COP $")
                    .padding([.bottom], 30)
                    .font(currencyCodeFont)
                
            }
            HStack {
                numberPad()
            }
            .padding()
            
            VStack {
                convertButton()
            }
            .padding()
        }
        .padding()
        .onAppear(perform: {
            numberLabel = "0"
        })
    }
    
    func numberPad() -> some View {
        VStack {
            HStack {
                numberButton("7")
                Spacer()
                numberButton("8")
                Spacer()
                numberButton("9")
                Spacer()
                quantityButton(.thousand)
            }
            .padding([.bottom], 20)
            HStack {
                numberButton("4")
                Spacer()
                numberButton("5")
                Spacer()
                numberButton("6")
                Spacer()
                quantityButton(.houndred)
            }
            .padding([.bottom], 20)
            HStack {
                numberButton("1")
                Spacer()
                numberButton("2")
                Spacer()
                numberButton("3")
                Spacer()
                quantityButton(.ten)
            }
            .padding([.bottom], 20)
            HStack {
                numberButton("0")
                Spacer()
                numberButton(",")
                Spacer()
                backButton()
                Spacer()
                quantityButton(.one)
            }
        }
        
    }
    
    func numberButton(_ title: String) -> some View {
        return Button {
            if numberLabel.first == "0" { numberLabel = "" }
            if formatNumber.count <= 16 {
                formatNumber.append(title)
                numberLabel = formatAmount(formatNumber)
                print(numberLabel)
            }
        } label: {
            numberText(title)
        }
    }
    
    func numberText(_ number: String) -> some View {
        Text(number)
            .font(.largeTitle)
            .fixedSize()
            .frame(width: 70, height: 70)
            .foregroundColor(.white)
            .overlay(
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
            ).background(Circle().fill(.gray))
    }
    
    func backButton() -> some View {
        return Button {
            if !formatNumber.isEmpty {
                formatNumber.removeLast()
                numberLabel = formatAmount(formatNumber)
            }
            if formatNumber.isEmpty{
                numberLabel = "0"
            }
        } label: {
            Image(systemName: "delete.left")
                .font(.system(size: 35))
                .frame(width: 70, height: 70)
                .foregroundColor(.white)
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                ).background(Circle().fill(.gray))
        }
    }
    
    func quantityButton(_ amount: CustomAmount) -> some View {
        return Button {
            switch amount {
            case .thousand:
                numberLabel = "1,000"
            case .houndred:
                numberLabel = "100"
            case .ten:
                numberLabel = "10"
            case .one:
                numberLabel = "1"
            }
            customAmount = formatAmount(numberLabel)
            isPresented.toggle()
            print(numberLabel)
        } label: {
            numberText(amount.rawValue)
        }
    }
    
    func convertButton() -> some View {
        
        return Button {
            isPresented.toggle()
            customAmount = formatAmount(numberLabel)
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "arrow.left.arrow.right.circle")
                    .font(.system(size: 30))
                    .padding([.trailing], 3)
                Text("Convert")
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                    .padding([.trailing], 15)
            }
            .foregroundColor(.white)
            .padding([.top, .bottom], 5)
        }
        .padding([.top, .bottom], 5)
        .frame(maxWidth: .infinity)
        .background(.green)
        .cornerRadius(15)
    }
    
    func formatAmount(_ amount: String) -> String {
        let formattedAmount = formatter.string(for: Decimal(string: amount)) ?? "?"
        return formattedAmount
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(isPresented: .constant(false), customAmount: .constant("100"))
    }
}
