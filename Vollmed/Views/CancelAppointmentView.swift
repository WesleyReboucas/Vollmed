//
//  CancelAppointmentView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 16/11/23.
//

import SwiftUI

struct CancelAppointmentView: View {
    
    var appointmentID: String
    let service = WebService()
    
    @State private var isAppointmentCancelled = false
    @State private var showAlert = false
    @State private var reasonToCancel = ""
    
    @Environment(\.presentationMode) var presentationMode
      
    func cancelAppointment() async {
           do {
               isAppointmentCancelled = try await service.cancelAppointment(appointmentID: appointmentID, reasonToCancel: reasonToCancel)
           } catch {
               print("Ocorreu um erro ao desmarcar a consulta: \(error)")
               isAppointmentCancelled = false
           }
           showAlert = true
       }
    
    var body: some View {
        VStack (spacing: 16.0) {
            Text("Conte-nos o motivo do cancelamento da sua consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            TextEditor(text: $reasonToCancel)
                .padding()
                .font(.title3)
                .foregroundColor(.accent)
                .scrollContentBackground(.hidden)
                .background(Color(.lightBlue).opacity(0.15))
                .cornerRadius(16.0)
                .frame(maxHeight: 300)
            
            Button(action: {
                Task {
                    await cancelAppointment()
//                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                ButtonView(text: "Cancelar consulta", buttonType: .cancel)
            })
            
        }
        .padding()
        .navigationTitle("Cancelar consulta")
        .navigationBarTitleDisplayMode(.large)
        .alert(isAppointmentCancelled ? "Sucesso!" : "Oxe, algo deu errado!", isPresented: $showAlert, presenting: isAppointmentCancelled) { _ in
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Ok")
            })
        } message: { isCanceled in
            if isCanceled {
                Text("Sua consulta foi cancelada!")
            } else {
                Text("Ocorreu um erro ao cancelar a sua consulta. Por favor tente novamente ou entre em contato conosco.")
            }
        }
    }
}

#Preview {
    CancelAppointmentView(appointmentID: "123")
}
