//
//  InputTextView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import SwiftUI

enum InputTextType {
    case primary
    case cancel
}

struct InputTextView: View {
    
    var title: String
    var placeholder: String
    var password: Bool?
    var value: Binding<String>
    
    var body: some View {
        
        Text(title)
            .font(.title3)
            .bold()
            .foregroundStyle(.accent)
        
        if password == nil {
            TextField(placeholder, text: value)
                .padding(14)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(14)
                .autocorrectionDisabled()
        } else {
            SecureField(placeholder, text: value)
                .padding(14)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(14)
                .autocorrectionDisabled()
        }
        
        
        
    }
}



#Preview {
    @State var valueTest: String = "teste"
    return InputTextView(title: "Testando", placeholder: "Testando placeholder", value: $valueTest)
}
