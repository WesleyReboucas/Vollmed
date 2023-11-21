//
//  ContentView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 15/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var authManager = AuthenticationManager.shared
    
    @State private var isLoading = true
    
    var body: some View {
        
        if authManager.token == nil {
            NavigationStack {
                SignInView()
            }
        } else {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label(
                        title: { Text("Home") },
                        icon: { Image(systemName: "house") }
                    )
                }
                
                NavigationStack {
                    MyAppointmentsView()
                }
                .tabItem {
                    Label(
                        title: { Text("Consultas") },
                        icon: { Image(systemName: "calendar") }
                    )
                }
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
