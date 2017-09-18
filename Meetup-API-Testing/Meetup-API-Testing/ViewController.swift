//
//  ViewController.swift
//  Meetup-API-Testing
//
//  Created by Matthew Harrilal on 9/17/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let network1 = Networking()
        print(network1.network())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

struct meetupListings {
    let country: String?
    let address1: String?
    let name: String?
    let lon: Float?
    let lat: Float?
    init(country:String?,address1: String?, name: String?, lon: Float?, lat: Float?) {
        self.country = country
        self.address1 = address1
        self.name = name
        self.lon = lon
        self.lat = lat
    }
}

extension meetupListings: Decodable {
//    enum firstLayer: String, CodingKey {
//        case results
//    }
    enum additionalKeys: String, CodingKey {
        case country
        case address1 = "address_1"
        case name
        case lon
        case lat
    }
    init(from decoder: Decoder) throws {
      let nestedContainer = try decoder.container(keyedBy: additionalKeys.self)
        let country = try nestedContainer.decodeIfPresent(String.self, forKey: .country) ?? "The country for this listing is not present"
        let address1 = try nestedContainer.decodeIfPresent(String.self, forKey: .address1) ?? "The address of this listing is not present"
        let name = try nestedContainer.decodeIfPresent(String.self, forKey: .name) ?? "The name of this listing is not present"
        let lon = try nestedContainer.decodeIfPresent(Float.self, forKey: .lon) ?? 0.00
        let lat = try nestedContainer.decodeIfPresent(Float.self, forKey: .lat) ?? 0.00
        self.init(country: country, address1: address1, name: name, lon:lon, lat: lat)
    }
    
}
struct Listing: Decodable {
    let results: [meetupListings]
}
class Networking {
    func network() {
        let session = URLSession.shared
        var getRequest = URLRequest(url: URL(string: "https://api.meetup.com/2/events?key=6d68436679717c306328646d777e611d&group_urlname=ny-tech&sign=true")!)
        getRequest.httpMethod = "GET"
        session.dataTask(with: getRequest) { (data, response, error) in
            if let data = data {
                let meetup = try? JSONDecoder().decode(Listing.self, from: data)
                print(meetup)
            }
        }.resume()
    }
}
