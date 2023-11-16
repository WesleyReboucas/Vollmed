//
//  WebService.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 15/11/23.
//

import UIKit

let patientID = "dffb9bce-8801-42e8-ad43-c057ede63bc2"

struct WebService {
    
    private let baseURL = "http://localhost:3000"
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func cancelAppointment(appointmentID: String, reasonToCancel: String) async throws -> Bool {
        let endpoint = baseURL + "/consulta/" + appointmentID
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: cancelAppointment")
            return false
        }
        
        let requestData: [String: String] = ["motivoCancelamento": reasonToCancel]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, 
            httpResponse.statusCode == 200 {
            return true
        }
        return false
    }
    
    func rescheduleAppointment(appointmentID: String, date: String) async throws -> ScheduleAppointmentResponse? {
         let endpoint = baseURL + "/consulta/" + appointmentID
         
         guard let url = URL(string: endpoint) else {
             print("[X] URL Error Service: rescheduleAppointment")
             return nil
         }
         
         let requestData: [String: String] = ["data": date]
         
         let jsonData = try JSONSerialization.data(withJSONObject: requestData)
         
         var request = URLRequest(url: url)
         request.httpMethod = "PATCH"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = jsonData
         
         let (data, _) = try await URLSession.shared.data(for: request)
         
         let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
         
         return appointmentResponse
     }
    
    func getAllAppointmentsFromPatient(patientID: String) async throws -> [Appointment]? {
            let endpoint = baseURL + "/paciente/" + patientID + "/consultas"
            
            guard let url = URL(string: endpoint) else {
                print("[X] URL Error Service: getAllAppointmentsFromPatient")
                return nil
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let appointments = try JSONDecoder().decode([Appointment].self, from: data)
            
            return appointments
        }
    
    func scheduleAppointment(specialistID: String,
                             patientID: String,
                             date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta"
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: scheduleAppointment")
            return nil
        }
        
        let appointment = ScheduleAppointmentRequest(specialist: specialistID, patient: patientID, date: date)
        
        let jsonData = try JSONEncoder().encode(appointment)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        
        return appointmentResponse
        
    }
        
    func downloadImage(from imageURL: String) async throws -> UIImage? {
        guard let url = URL(string: imageURL) else {
            print("[X] URL Error Service: downloadImage")
            return nil
        }
        
        // Verifica se há cache
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
            return cachedImage
        }
        
        // Baixa a imagem
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        // Salva a imagem no cache
        imageCache.setObject(image, forKey: imageURL as NSString)
        
        return image
    }
    
    func getAllSpecialists() async throws -> [Specialist]? {
        let endpoint = baseURL + "/especialista"
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: getAllSpecialists")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let specialists = try JSONDecoder().decode([Specialist].self, from: data)
        
        return specialists
    }
}
