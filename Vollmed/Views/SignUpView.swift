//
//  SignUpView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import SwiftUI

struct SignUpView: View {
    
    let service = WebService()
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var cpf: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var healthPlan: String
    @State private var showAlert: Bool = false
    @State private var isPatientRegistered: Bool = false
    @State private var navigateToSignInView: Bool = false
    
    // MARK: - Health Plans
    let healthPlans: [String] = [
        "Amil", "Unimed", "Bradesco Saúde", "SulAmérica", "Hapvida", "Notredame Intermédica", "São Francisco Saúde", "Golden Cross", "Medial Saúde", "América Saúde", "Outro"
    ]
    
    init(){
        self.healthPlan = healthPlans[0]
    }
    
    // MARK: - Register
    func register() async {
        let patient = Patient(id: nil, name: name, email: email, cpf: cpf, phoneNumber: phoneNumber, password: password, healthPlan: healthPlan)
        do {
            if let _ = try await service.registerPatient(patient: patient) {
                isPatientRegistered = true
            } else {
                isPatientRegistered = false
            }
            
        } catch {
            isPatientRegistered = false
            print("[X] Error in register: \(error) ")
        }
        showAlert = true
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView (showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
            VStack (alignment: .leading, spacing: 16.0)  {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 36.0, alignment: .center)
                    .padding(.vertical)
                
                Text("Olá, boas vindas!")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.accent)
                
                Text("Insira seus dados para criar uma conta.")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                InputTextView(title: "Nome", placeholder: "Insira seu nome completo", value: $name)
                
                InputTextView(title: "E-mail:", placeholder: "Insira seu melhor e-mail", value: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                InputTextView(title: "CPF:", placeholder: "Insira seu CPF", value: $cpf)
                    .keyboardType(.numberPad)
                
                InputTextView(title: "Telefone:", placeholder: "Insira seu Telefone", value: $phoneNumber)
                    .keyboardType(.numberPad)
                
                InputTextView(title: "Senha:", placeholder: "Insira seu Senha", password: true, value: $password)
                
                
                Text("Selecione o seu plano de saúde:")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.accent)
                
                Picker("Plano de saúde", selection: $healthPlan) {
                    ForEach ( healthPlans, id: \.self ) { healthPlan in
                        Text(healthPlan)
                    }
                }
                
                Button(action: {
                    Task {
                        await register()
                    }
                }, label: {
                    ButtonView(text: "Cadastrar")
                })
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Já possui conta? Faça o login!")
                        .bold()
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                
            }
        }
        .navigationBarBackButtonHidden()
        .padding()
        .alert(isPatientRegistered ? "Sucesso!" : "Oxe, algo deu errado!", isPresented: $showAlert, presenting: $isPatientRegistered) { _ in
            Button(action: {
                navigateToSignInView =  true
            }, label: {
                Text("Ok")
            })
        } message: { _ in
            if isPatientRegistered {
                Text("O paciente foi criado com sucesso! Entre para acessar!")
            } else {
                Text("Houve um erro ao cadastrar o paciente. Por favor tente novamente ou entre em contato conosco.")
            }
        }
        .navigationDestination(isPresented: $navigateToSignInView) {
            SignInView()
        }
    }
}

#Preview {
    SignUpView()
}
