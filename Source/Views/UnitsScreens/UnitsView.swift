//
//  UnitsView.swift
//  Converter (iOS)
//
//  Created by johann casique on 18/10/22.
//

import SwiftUI

struct UnitsView: View {
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    unitsView(imageIdentifier: "thermometer",
                              title: "Temperatura")
                    
                    unitsView(imageIdentifier: "scalemass",
                              title: "Peso")
                }
                .padding()
                
                HStack {
                    unitsView(imageIdentifier: "ruler",
                              title: "Longitud")
                    
                    unitsView(imageIdentifier: "speedometer",
                              title: "Velocidad")
                }
                .padding()
                HStack {
                    unitsView(imageIdentifier: "cylinder.split.1x2",
                              title: "Moneda")
                    
                    unitsView(imageIdentifier: "clock.fill",
                              title: "Hora")
                }
                .padding()
                
                HStack {
                    unitsView(imageIdentifier: "bolt.fill",
                              title: "Electricidad")
                    
                    unitsView(imageIdentifier: "arrow.down.to.line",
                              title: "Fuerza")
                }
                .padding()
            }
        }
        .navigationTitle("Converter")
    }
    
    
    func unitsView(imageIdentifier: String, title: String) -> some View {
        VStack(alignment: .center) {
            
            Image(systemName: imageIdentifier)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 120)
                .padding()
            Text(title)
                .font(Font(.init(.system, size: 20)))
                .bold()
                .padding([.leading, .trailing], 20)
                .padding(.bottom)
        }
        .background(Color.green)
        .cornerRadius(15)
    }
}

struct UnitsView_Previews: PreviewProvider {
    static var previews: some View {
        UnitsView()
    }
}
