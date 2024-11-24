//
//  ApiComs.swift
//  MingaConnect
//
//  Created by Matthias Meierlohr on 23.11.24.
//

import Foundation


class APIService {
    static let shared = APIService()
    private let baseURL = "http://131.159.203.157:5000" // Replace with your Flask server URL

    private func request<T: Codable>(endpoint: String, method: String, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Create Event
    func createEvent(event: Event, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/create_event"
        let body = try? JSONEncoder().encode(event)
        request(endpoint: endpoint, method: "POST", body: body) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["event_id"] ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Update Event
    func updateEvent(event: Event, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/update_event"
        let body = try? JSONEncoder().encode(event)
        request(endpoint: endpoint, method: "PUT", body: body) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["event_id"] ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Delete Event
    func deleteEvent(eventID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/delete_event"
        let body = try? JSONEncoder().encode(["event_id": eventID])
        request(endpoint: endpoint, method: "DELETE", body: body) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["event_id"] ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Fetch All Events
    func getEvents(completion: @escaping (Result<[String: Event], Error>) -> Void) {
        let endpoint = "/get_event_list"
        var bodyDict: [String: Any] = [:]
        let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])

        request(endpoint: endpoint, method: "POST", body: body, completion: completion)
    }
    
    func getFilteredEvents(filterInterests: [String]? = nil, filterDates: [String]? = nil, filterLocation: [Double]? = nil, filterRadius: Int? = nil, completion: @escaping (Result<[String: Event], Error>) -> Void) {
            let endpoint = "/get_event_list"
            
            var bodyDict: [String: Any] = [:]
            if let filterInterests = filterInterests {
                bodyDict["filter_interests"] = filterInterests
            }
            if let filterDates = filterDates {
                bodyDict["filter_dates"] = filterDates
            }
            if let filterLocation = filterLocation {
                bodyDict["filter_location"] = filterLocation
            }
            if let filterRadius = filterRadius {
                bodyDict["filter_location_radius"] = filterRadius
            }
            
            let body = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
            
            request(endpoint: endpoint, method: "POST", body: body, completion: completion)
        }

    // Create User
    func createUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/create_user"
        let body = try? JSONEncoder().encode(user)
        request(endpoint: endpoint, method: "POST", body: body) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["user_id"] ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Fetch All Users
    func getUsers(completion: @escaping (Result<[String: User], Error>) -> Void) {
        let endpoint = "/get_user_list"
        request(endpoint: endpoint, method: "GET", completion: completion)
    }

    // Join Event
    func joinEvent(userID: String, eventID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/join_event"
        let body = try? JSONEncoder().encode(["user_id": userID, "event_id": eventID])
        print(eventID)
        request(endpoint: endpoint, method: "POST", body: body) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["message"] ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Leave Event
    func leaveEvent(userID: String, eventID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/leave_event"
        let body = try? JSONEncoder().encode(["user_id": userID, "event_id": eventID])
        request(endpoint: endpoint, method: "DELETE", body: body) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                completion(.success(response["message"] ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
