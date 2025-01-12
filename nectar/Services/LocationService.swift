import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var geocoder = CLGeocoder()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined // Default value
    
    @Published var selectedLocation: CLLocationCoordinate2D? {
        didSet {
            if let location = selectedLocation {
                fetchCityName(for: location)
            } else {
                locationString = "Select Location"
            }
        }
    }
    
    @Published var locationString: String = "Select Location"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request authorization
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization() // Request permission
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status // Update the published property
    }
    
    private func fetchCityName(for location: CLLocationCoordinate2D) {
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeLocation(clLocation) { [weak self] (placemarks: [CLPlacemark]?, error: Error?) in
            guard let self = self, error == nil else {
                self?.locationString = "Unable to determine location"
                return
            }
            if let placemark = placemarks?.first, let city = placemark.locality {
                DispatchQueue.main.async {
                    self.locationString = city // Update the location string to the city name
                }
            } else {
                DispatchQueue.main.async {
                    self.locationString = "Unknown Location"
                }
            }
        }
    }
} 