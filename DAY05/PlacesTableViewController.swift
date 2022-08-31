//
//  PlacesTableViewController.swift
//  DAY05
//
//  Created by Zuleykha Pavlichenkova on 17.08.2022.
//

import Foundation
import UIKit

protocol IPlacesTableViewControllerDelegate: AnyObject {
    func didSelectLocation(with place: Place)
    func didLoadMapWithPlaces(with plases: [Place])
}

class PlacesTableViewController: UITableViewController {
    
    weak var delegate: IPlacesTableViewControllerDelegate?
    
    let places: [Place] = [
        Place(name: "Ecole 42", subtitle: "Free programming school in Paris", longitude: 2.3184473537270263, latitude: 48.8967762594015, pinColor: .random),
        Place(name: "Школа 21, Казань", subtitle: "Бесплатная школа программирования в Казани", longitude: 49.12517720093447, latitude: 55.7820829841939, pinColor: .random),
        Place(name: "Basket Hall", subtitle: "🏀 ⛹🏻", longitude: 49.1267418, latitude: 55.78286658819331, pinColor: .random),
        Place(name: "Peel castle", subtitle: "Random castle 🏰 somewhere in England", longitude: -4.698690760913292, latitude: 54.22720526283829, pinColor: .random),
        Place(name: "Sydney opera house", subtitle: "🎭 🎶 🎵🎶 🎶 🎭🎵", longitude: 151.21570, latitude: -33.85662, pinColor: .random),
        Place(name: "Machu Picchu", subtitle: "🏞", longitude: -72.54494146699699, latitude: -13.162869540435237, pinColor: .random),
        Place(name: "Unalashka", subtitle: "A place from a book 📖", longitude: -166.53011619254616, latitude: 53.87248446394492, pinColor: .random),
        Place(name: "Skuratov", subtitle: "Coffee ☕️", longitude: 49.12929366080798, latitude: 55.78364547249509, pinColor: .random),
        Place(name: "New Kitchen", subtitle: "Fancy and tasty", longitude: 49.12999599580595, latitude: 55.782861575202176, pinColor: .random)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "placeCell")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.item].name  
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.item]
        delegate?.didLoadMapWithPlaces(with: places)
        delegate?.didSelectLocation(with: place)
        tabBarController?.selectedIndex = 0
    }
}

