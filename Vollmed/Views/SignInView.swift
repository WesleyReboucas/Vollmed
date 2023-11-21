//
//  SignInView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import SwiftUI

struct SignInView: View {
    
    let service = WebService()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    
    var authManager = AuthenticationManager.shared
    
    // MARK: - Loggin
    func login() async  {
        isLoading = true
        do {
            if let response = try await service.loginPatient(email: email, password: password) {
                authManager.saveToken(token: response.token)
                authManager.savePatientID(id: response.id)
                isLoading = false
            } else  {
                showAlert = true
                isLoading = false
            }
        } catch {
            showAlert = true
            isLoading = false
            print("[X] Error login: \(error)")
        }
    }
    
    var body: some View {
        if isLoading {
            VStack {
                LoadingView(text: "Verificando os dados...")
            }
            .background(Color.gray.opacity(0.15))
        } else {
            VStack (alignment: .leading, spacing: 16) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 36, alignment: .center)
                
                Text("Olá")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.accent)
                
                Text("Preencha para acessar sua conta")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                InputTextView(title: "E-mail:", placeholder: "Insira seu melhor e-mail", value: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                InputTextView(title: "Senha:", placeholder: "Insira seu Senha",  password: true, value: $password)
                
                Button(action: {
                    Task {
                        await login()
                    }
                }, label: {
                    ButtonView(text: "Entrar")
                })
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Não possui conta? Cadrastre-se!")
                        .bold()
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
            .navigationBarBackButtonHidden()
            .alert("Oxe, algo deu errado", isPresented: $showAlert) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Ok")
                })
            } message: {
                Text("Houve um erro ao entrar na sua conta. Tente novamente ou entre em contato conosco.")
            }
            
        }
        
    }
}

#Preview {
    SignInView()
}
