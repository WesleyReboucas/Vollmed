//
//  WebService.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 15/11/23.
//

import UIKit

struct WebService {
    
    private let baseURL = "http://localhost:3000"
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var authManager = AuthenticationManager.shared
    
    // MARK: - Logout Patient
    func logoutPatient() async throws -> Bool {
        let endpoint = baseURL + "/auth/logout/"
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: logoutPatient")
            return false
        }
        
        guard let token = authManager.token else {
            print("[X] URL Error Service: logoutPatient: Without Token")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            return true
        }
        return false
    }
    
    // MARK: - Login Patient
    func loginPatient(email: String, password: String) async throws -> LoginResponse? {
        let endpoint = baseURL + "/auth/login"
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: loginPatient")
            return nil
        }

        let loginRequest = LoginRequest(email: email, password: password)

        let jsonData = try JSONEncoder().encode(loginRequest)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, _) = try await URLSession.shared.data(for: request)

        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

        return loginResponse
    }
    
    // MARK: - Resgister Patient
    func registerPatient(patient: Patient) async throws -> Patient? {
        let endpoint = baseURL + "/paciente"
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: resgiterPatient")
            return nil
        }
        
        let jsonData = try JSONEncoder().encode(patient)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let patient = try JSONDecoder().decode(Patient.self, from: data)
        
        return patient
    }
    
    // MARK: - Cancel Appointment
    func cancelAppointment(appointmentID: String, reasonToCancel: String) async throws -> Bool {
        let endpoint = baseURL + "/consulta/" + appointmentID
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: cancelAppointment")
            return false
        }
        
        guard let token = authManager.token else {
            print("[X] URL Error Service: cancelAppointment: Without Token")
            return false
        }
        
        let requestData: [String: String] = ["motivoCancelamento": reasonToCancel]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            return true
        }
        return false
    }
    
    // MARK: - Reschedule Appointment
    func rescheduleAppointment(appointmentID: String, date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta/" + appointmentID
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: rescheduleAppointment")
            return nil
        }
        
        guard let token = authManager.token else {
            print("[X] URL Error Service: rescheduleAppointment: Without Token")
            return nil
        }
        
        let requestData: [String: String] = ["data": date]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        
        return appointmentResponse
    }
    
    // MARK: - Get All Appointments From Patient
    func getAllAppointmentsFromPatient(patientID: String) async throws -> [Appointment]? {
        let endpoint = baseURL + "/paciente/" + patientID + "/consultas"
        
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: getAllAppointmentsFromPatient")
            return nil
        }
        
        guard let token = authManager.token else {
            print("[X] URL Error Service: getAllAppointmentsFromPatient: Without Token")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let appointments = try JSONDecoder().decode([Appointment].self, from: data)
          
        return appointments
    }
    
    // MARK: - Schedule Appointment
    func scheduleAppointment(specialistID: String,
                             patientID: String,
                             date: String) async throws -> ScheduleAppointmentResponse? {
        let endpoint = baseURL + "/consulta"
               
        guard let url = URL(string: endpoint) else {
            print("[X] URL Error Service: scheduleAppointment")
            return nil
        }
               
        guard let token = authManager.token else {
            print("[X] URL Error Service: scheduleAppointment: Without Token")
            return nil
        }
        
        let appointment = ScheduleAppointmentRequest(specialist: specialistID, patient: patientID, date: date)
        
        let jsonData = try JSONEncoder().encode(appointment)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
        
        return appointmentResponse
        
    }
    
    // MARK: - Download Image
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
    
    // MARK: - Get All Specialists
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
