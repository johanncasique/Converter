//
//  UnitsCalculatorView.swift
//  Converter (iOS)
//
//  Created by johann casique on 24/10/22.
//

import SwiftUI

struct UnitsCalculatorView: View {
    
    @State var amount1: String
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 35) {
                    leftUnitView
                    middleHeaderView
                    rightUnitView
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.gray)
                
                boxOne(with: "Gramo")
                Spacer()
                    .frame(height: 50)
                boxOne(with: "Libra")
                Spacer()
            }
        }
        .navigationTitle("Peso")
    }
    
    func boxOne(with title: String) -> some View {
        HStack {
            VStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .font(.headline)
                TextField("", text: $amount1)
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled(true)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .background { Color.gray }
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing], 20)
            
        }
    }
    
    
    @ViewBuilder
    var leftUnitView: some View {
        HStack(spacing: 45) {
            Text("Gr")
                .font(.init(.title))
                .fontWeight(.bold)
            Image(systemName: "arrowtriangle.down.fill")
        }
        
    }
    
    @ViewBuilder
    var middleHeaderView: some View {
        HStack(alignment: .center, spacing: 30) {
            Divider()
                .frame(width: 2, height: 45)
                .overlay(Color.black)
                .padding(.leading, 2)
                .padding(.bottom, 4)
                
            Image(systemName: "arrow.left.arrow.right")
                .font(.title)
                .fontWeight(.bold)
                
        }
    }
    
    @ViewBuilder
    var rightUnitView: some View {
        HStack(spacing: 45) {
            Text("Lb")
                .font(.init(.title))
                .fontWeight(.bold)
            Image(systemName: "arrowtriangle.down.fill")
        }
        
    }
}

struct UnitsCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        UnitsCalculatorView(amount1: "123424")
    }
}
