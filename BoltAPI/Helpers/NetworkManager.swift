//
//  NetworkManager.swift
//  BoltAPI
//
//  Created by Maxim Spiridonov on 19/06/2019.
//  Copyright © 2019 Maxim Spiridonov. All rights reserved.
//

import UIKit

class NetworkManager {
    
    func uploadImage(hostName: String, imageProperties: ImageProperties, completion: @escaping (_ image: UIImage?, _ error: Bool)->()) {
        
        guard let url = URL(string: hostName) else { completion(nil, true); return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageProperties.data
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(imageProperties.key)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imageProperties.data)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            if let error = error {
                completion(nil, true)
                return
            }
            if let response = response {
                print(response)
            }
            if let data = data, let image = UIImage(data: data) {
                completion(image, false)
            }
        }.resume()
    }
}

