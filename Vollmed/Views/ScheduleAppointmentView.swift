//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 15/11/23.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    
    let service = WebService()
    
    var specialistID: String
    var isRescheduleView: Bool
    var appointmentID: String?
    
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var isAppointmentScheduled = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(specialistID: String, isRescheduleView: Bool = false, appointmentID: String? = nil) {
        self.specialistID = specialistID
        self.isRescheduleView  = isRescheduleView
        self.appointmentID = appointmentID
    }
    
    func rescheduleAppointment() async {
        guard let appointmentID else {
            print("[X] Error get appointment id.")
            return
        }
        do {
            if let _ = try await service.rescheduleAppointment(appointmentID: appointmentID, date: selectedDate.convertToString()){
                isAppointmentScheduled = true
            } else {
                isAppointmentScheduled  =  false
            }
        } catch {
            isAppointmentScheduled = false
            print("[X] Error rescheduleAppointment: \(error)")
        }
        showAlert = true
    }
    
    func scheduleAppointment() async {
        do  {
            if let _ = try await service.scheduleAppointment(specialistID: specialistID, patientID: patientID, date: selectedDate.convertToString()) {
                isAppointmentScheduled =  true
            }  else {
                isAppointmentScheduled = false
            }
        } catch  {
            isAppointmentScheduled = false
            print("[X] Error scheduleAppointment: \(error)")
        }
        showAlert = true
    }
    
    var body: some View {
        VStack {
            Text("Selecione a data e horário da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            DatePicker("Escolha a data da consulta", selection: $selectedDate, in: Date()...)
                .datePickerStyle(.graphical)
            
            Button {
                Task {
                    if isRescheduleView {
                        await rescheduleAppointment()
                    } else {
                        await scheduleAppointment()
                    }
                }
            } label: {
                ButtonView(text: isRescheduleView ? "Reagendar consulta" : "Confirmar consulta")
            }
        }
        .padding()
        .navigationTitle(isRescheduleView ? "Reagendar consulta" : "Agendar consulta")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 15
        }
        .alert(isAppointmentScheduled ? "Sucesso!" : "Oxe, algo deu errado!", isPresented: $showAlert, presenting: isAppointmentScheduled) { _ in
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Ok")
            })
        } message: { isScheduled in
            if isScheduled {
                Text("Sua consulta foi \(isRescheduleView ? "reagendada" : "agendada")!")
            } else {
                Text("Ocorreu um erro ao \(isRescheduleView ? "reagendar" : "agendar") a sua consulta. Por favor tente novamente ou entre em contato conosco.")
            }
        }
    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "123")
}
