//
//  LocationService.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import Foundation
import CoreLocation
import MapKit

final class LocationService: NSObject, ObservableObject {
    
    enum Region: String {
        case ru = "Russia"
        case us = "United States"
        case eu = "Europe"
        
        var currency: String {
            switch self {
            case .ru:
                "RUB"
            case .us:
                "USD"
            case .eu:
                "EUR"
            }
        }
        
        var exchangeRate: Double {
            switch self {
            case .us:
                1
            case .eu:
                0.9
            case .ru:
                90
            }
        }
    }
    
    static let shared = LocationService()
    
    @Published var country: String = Region.us.rawValue
    var currencyCode: String {
        region.currency
    }
    private var region: Region = .us
    
    private let locationManager = CLLocationManager()
    private var manualCountry: String? {
        get {
            UserDefaults.standard.string(forKey: "manualCountry")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "manualCountry")
        }
    }
    
    override init() {
        super.init()
        
        if let manualCountry {
            setCountry(manualCountry)
        }
        locationManager.delegate = self
    }
    
    func requestAuthorize() {
        guard manualCountry == nil else {
            return
        }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            break
        default:
            locationManager.startUpdatingLocation()
        }
    }
    
    func exchange(_ value: Double) -> Double {
        value * region.exchangeRate
    }
    
    func revertExchange(_ value: Double) -> Double {
        (value / region.exchangeRate).rounded()
    }
    
    func setCountryManual(_ value: String) {
        locationManager.stopUpdatingLocation()
        setCountry(value)
        manualCountry = country
    }
    
    func setAutoLocation() {
        manualCountry = nil
        requestAuthorize()
    }
    
    private func setCountry(_ value: String) {
        if ContriesConstants.euCountries.contains(value) {
            region = .eu
        } else {
            region = Region(rawValue: value) ?? .us
        }
        country = value
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            location.fetchCityAndCountry { 
                country, error in
                
                guard error == nil, let country else {
                    self.region = .us
                    self.country = self.region.rawValue
                    return
                }
                self.setCountry(country)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        locationManager.stopUpdatingLocation()
    }
}

private extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.country, $1) }
    }
}

enum ContriesConstants {
    static let euCountries = """
Albania
Andorra
Armenia
Austria
Azerbaijan
Belarus
Belgium
Bosnia
Bulgaria
Croatia
Cyprus
Czech Republic
Denmark
Estonia
Finland
France
Georgia
Germany
Greece
Hungary
Iceland
Ireland
Italy
Kosovo
Latvia
Lithuania
Luxemburg
Macedonia
Malta
Moldava
Netherlands
Norway
Poland
Portugal
Romania
Serbia
Slovakia
Slovenia
Spain
Sweden
Switzerland
Turkey
Ukraine
United Kingdom
""".components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    static let countries = """
Afghanistan
Albania
Algeria
Andorra
Angola
Antigua & Deps
Argentina
Armenia
Australia
Austria
Azerbaijan
Bahamas
Bahrain
Bangladesh
Barbados
Belarus
Belgium
Belize
Benin
Bhutan
Bolivia
Bosnia Herzegovina
Botswana
Brazil
Brunei
Bulgaria
Burkina
Burundi
Cambodia
Cameroon
Canada
Cape Verde
Central African Rep
Chad
Chile
China
Colombia
Comoros
Congo
Costa Rica
Croatia
Cuba
Cyprus
Czech Republic
Denmark
Djibouti
Dominica
Dominican Republic
East Timor
Ecuador
Egypt
El Salvador
Equatorial Guinea
Eritrea
Estonia
Ethiopia
Fiji
Finland
France
Gabon
Gambia
Georgia
Germany
Ghana
Greece
Grenada
Guatemala
Guinea
Guinea-Bissau
Guyana
Haiti
Honduras
Hungary
Iceland
India
Indonesia
Iran
Iraq
Ireland
Israel
Italy
Ivory Coast
Jamaica
Japan
Jordan
Kazakhstan
Kenya
Kiribati
Korea North
Korea South
Kosovo
Kuwait
Kyrgyzstan
Laos
Latvia
Lebanon
Lesotho
Liberia
Libya
Liechtenstein
Lithuania
Luxembourg
Macedonia
Madagascar
Malawi
Malaysia
Maldives
Mali
Malta
Marshall Islands
Mauritania
Mauritius
Mexico
Micronesia
Moldova
Monaco
Mongolia
Montenegro
Morocco
Mozambique
Myanmar
Namibia
Nauru
Nepal
Netherlands
New Zealand
Nicaragua
Niger
Nigeria
Norway
Oman
Pakistan
Palau
Panama
Papua New Guinea
Paraguay
Peru
Philippines
Poland
Portugal
Qatar
Romania
Russia
Rwanda
St Kitts & Nevis
St Lucia
Saint Vincent & the Grenadines
Samoa
San Marino
Sao Tome & Principe
Saudi Arabia
Senegal
Serbia
Seychelles
Sierra Leone
Singapore
Slovakia
Slovenia
Solomon Islands
Somalia
South Africa
South Sudan
Spain
Sri Lanka
Sudan
Suriname
Swaziland
Sweden
Switzerland
Syria
Taiwan
Tajikistan
Tanzania
Thailand
Togo
Tonga
Trinidad & Tobago
Tunisia
Turkey
Turkmenistan
Tuvalu
Uganda
Ukraine
United Arab Emirates
United Kingdom
United States
Uruguay
Uzbekistan
Vanuatu
Vatican City
Venezuela
Vietnam
Yemen
Zambia
Zimbabwe
""".components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
}
