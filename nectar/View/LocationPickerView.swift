import SwiftUI
import MapKit
import CoreLocation
import Combine

struct LocationPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LocationPickerViewModel()
    @Binding var selectedLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    annotationItems: viewModel.searchResults) { place in
                    MapMarker(coordinate: place.coordinate)
                }
                .ignoresSafeArea(edges: .bottom)
                
                // Center Pin
                VStack {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundColor(.red)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 5, height: 5)
                }
                
                // Search and Results
                VStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search location", text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .autocapitalization(.none)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 5)
                    
                    // Search Results
                    if !viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(viewModel.searchResults) { place in
                                    Button(action: {
                                        viewModel.selectLocation(place)
                                    }) {
                                        VStack(alignment: .leading) {
                                            Text(place.name)
                                                .font(.custom("Gilroy-SemiBold", size: 16))
                                            Text(place.address)
                                                .font(.custom("Gilroy-Medium", size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                    }
                                    Divider()
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 300)
                    }
                    
                    Spacer()
                    
                    // Current Location Button
                    Button(action: viewModel.requestLocation) {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                    // Confirm Button
                    Button(action: {
                        selectedLocation = viewModel.region.center
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Confirm Location")
                            .font(.custom("Gilroy-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Pick Location")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            viewModel.checkLocationAuthorization()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                primaryButton: .default(Text("Settings")) {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

class LocationPickerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3361, longitude: -122.0380),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var searchText = ""
    @Published var searchResults: [Place] = []
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    private let locationManager = CLLocationManager()
    private var searchDebouncer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        // Setup search text observation
        $searchText
            .sink { [weak self] text in
                self?.searchDebouncer?.invalidate()
                guard !text.isEmpty else {
                    self?.searchResults = []
                    return
                }
                
                self?.searchDebouncer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self?.performSearch(text)
                }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        withAnimation {
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    private func showLocationDeniedAlert() {
        alertTitle = "Location Access Required"
        alertMessage = "Please enable location access in Settings to use this feature."
        showAlert = true
    }
    
    private func performSearch(_ query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self?.searchResults = response.mapItems.map { item in
                    Place(
                        id: UUID().uuidString,
                        name: item.name ?? "",
                        address: item.placemark.formattedAddress ?? "",
                        coordinate: item.placemark.coordinate
                    )
                }
            }
        }
    }
    
    func selectLocation(_ place: Place) {
        withAnimation {
            region = MKCoordinateRegion(
                center: place.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
        searchText = ""
    }
}

struct Place: Identifiable {
    let id: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

extension CLPlacemark {
    var formattedAddress: String? {
        let components = [
            thoroughfare,
            locality,
            administrativeArea,
            postalCode,
            country
        ].compactMap { $0 }
        return components.joined(separator: ", ")
    }
}

#Preview {
    LocationPickerView(selectedLocation: .constant(CLLocationCoordinate2D(
        latitude: 37.3361,
        longitude: -122.0380
    )))
    .environmentObject(AuthViewModel())
} 