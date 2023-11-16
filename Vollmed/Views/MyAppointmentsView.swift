//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 16/11/23.
//

import SwiftUI

struct MyAppointmentsView: View {
    
    let service = WebService()
    
    @State private var appointments: [Appointment] = []
    
    func getAllAppointments() async {
        do {
            if let appointments = try await service.getAllAppointmentsFromPatient(patientID: patientID) {
                self.appointments = appointments
            }
        } catch {
            print("[X] Error getAllAppointments: \(error) ")
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if appointments.isEmpty {
                Text("Não há nenhuma consulta agendada no momento.")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.cancel)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ForEach(appointments) { appointment in
                    SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
                }
            }
            
        }
        .navigationTitle("Minhas consultas")
        .navigationBarTitleDisplayMode(.large)
        .padding()
        .onAppear {
            Task {
                await getAllAppointments()
            }
        }
    }
}

#Preview {
    MyAppointmentsView()
}
