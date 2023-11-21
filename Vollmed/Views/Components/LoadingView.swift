//
//  LoadingView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import SwiftUI

struct LoadingView: View {
    
    var text: String?
    
    var body: some View {
        ProgressView(text ?? "Verificando...")
            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor)) // Cor do ProgressView
            .padding()
            .frame(height: 100)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
    }
}

#Preview {
    LoadingView()
}
