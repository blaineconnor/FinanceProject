//
//  HttpConn.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import Alamofire

struct HttpConn{
    static func getToken(/*private*/completion: @escaping (Token) -> Void) {
        let parameters: [String: Any] = [:
            //this part is private
        ]
        
        let url = "https://myapi.private.com/api/Token/oauth/get_token"
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let json = response.data {                    do {
                    let cevap = try JSONDecoder().decode(Token.self, from: json)
                    completion(cevap)
                } catch {
                    debugPrint(error.localizedDescription)
                }
                } else {
                    debugPrint("hata")
                }
                
            }
    }
    static func getKurListe(token: String, completion: @escaping (Result<[Kurlar], Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Auth": "Bearer \(token)"
        ]
        
        let url = "https://myapi.private.com.tr/api/getcurrency"
        AF.request(url, method: .post,encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: KurlarResponse.self) { response in
                switch response.result {
                case .success(let value):
                    
                    if value.hataKodu == 0 {
                        completion(.success(value.kurlar))
                    } else {
                        completion(.failure(value.hataMesaji as! Error))
                    }                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}


