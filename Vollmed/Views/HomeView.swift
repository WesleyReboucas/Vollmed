//
//  HomeView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 15/11/23.
//

import SwiftUI

struct HomeView: View {
    
    let service = WebService()
    @State private var specialists: [Specialist] = []
    @State private var isButtonLogoutClicked: Bool = false
    
    var authManager = AuthenticationManager.shared
    
    // MARK: - Get Specialists
    func getSpecialists() async {
        do {
            if let specialists = try await service.getAllSpecialists() {
                self.specialists = specialists
            }
        } catch {
            print("[X] Error getSpecialists: \(error)")
        }
    }
    
    // MARK: - Logout
    func logout() async {
        do {
            let logoutSuccessful = try await service.logoutPatient()
            if logoutSuccessful {
                authManager.removeToken()
                authManager.removePatientID()
            }
            
        } catch {
            print("[X] Error logout: \(error)")
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding(.vertical, 32)
                Text("Boas-vindas!")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color(.lightBlue))
                Text("Veja abaixo os especialistas da Vollmed disponíveis e marque já a sua consulta!")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.accent)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                ForEach(specialists) { specialist in
                    SpecialistCardView(specialist: specialist)
                        .padding(.bottom, 8)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .onAppear {
            Task {
                await getSpecialists()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        await logout()
                        isButtonLogoutClicked =  true
                    }
                }, label: {
                    HStack(spacing: 2) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        
                        Text("Logout")
                    }
                })
            }
        }
    }
}

#Preview {
    HomeView()
}
