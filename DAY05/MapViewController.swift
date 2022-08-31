//
//  MapViewController.swift
//  DAY05
//
//  Created by Zuleykha Pavlichenkova on 17.08.2022.
//  For Simulator: lat 55.817514975547525, lon 49.11674245400417

import Foundation
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentPlace: Place = Place(name: "", subtitle: "", longitude: 0, latitude: 0, pinColor: .random)
    var locationManager:CLLocationManager!

    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    let horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        return stackView
    }()
    
    
    //MARK: UISegmentedControl
    let segmentedControl = UISegmentedControl(items: ["Standard", "Satelite", "Hybrid"])
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(didLocationButtonTapped), for: .touchUpInside)
        return button
    }()
        
    @objc func didLocationButtonTapped() { showLocation(with: currentPlace) }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpUI()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
        
    //MARK: - location delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.currentPlace.latitude = userLocation.coordinate.latitude
        self.currentPlace.longitude = userLocation.coordinate.longitude
        self.currentPlace.name = "My current location"
        self.currentPlace.subtitle = "🤷🏼‍♀️"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
        }

        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func setUpUI() {
        setMapConstraints()
        view.addSubview(horizontalStack)
        NSLayoutConstraint.activate([
            horizontalStack.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            horizontalStack.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        horizontalStack.addArrangedSubview(locationButton)
        setSegmentedControlConstraints()
        
    }

    func setMapConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setSegmentedControlConstraints() {
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControl), for: .valueChanged)
        
        horizontalStack.addArrangedSubview(segmentedControl)
        horizontalStack.addArrangedSubview(locationButton)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: horizontalStack.topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: horizontalStack.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -16)
        ])
    }
    
    @objc private func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    // MARK: showLocation
    
    func showLocation(with place: Place) {
        
        let annotation = makeMapAnnotation(with: place)
        mapView.addAnnotation(annotation)
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func makeMapAnnotation(with place: Place) -> MKPointAnnotation {
        
        let coords = CLLocationCoordinate2D(
            latitude: place.latitude,
            longitude: place.longitude
        )
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        annotation.title = place.name
        annotation.subtitle = place.subtitle
        
        return annotation
    }
    
    // MARK: showAllPlaces
    
    func showAllPlaces(with places: [Place]) {
        for place in places {
            showLocation(with: place)
//            print(place)
        }
    }
    
}

extension MapViewController: IPlacesTableViewControllerDelegate {

    func didSelectLocation(with place: Place) {
        showLocation(with: place)
    }

    func didLoadMapWithPlaces(with plases: [Place]) {
        showAllPlaces(with: plases)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
///// Deprecated - https://developer.apple.com/documentation/mapkit/mkpointannotation/
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        annotationView.canShowCallout = true
        annotationView.markerTintColor = .random

        return annotationView
    }
}
