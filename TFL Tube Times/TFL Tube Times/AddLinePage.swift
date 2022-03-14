//
//  AddLinePage.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 07/03/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class AddLinePage: UIViewController {
    
    var offwhiteBackgroundcolour = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    var greybluecolour = UIColor(red: 0.36, green: 0.44, blue: 0.52, alpha: 1.00)
    var lightgreybordercolour = UIColor(red: 0.84, green: 0.86, blue: 0.88, alpha: 1.00)
    var purpleThemeColour = UIColor(red: 0.38, green: 0.11, blue: 0.81, alpha: 1.00)
    
    var delegate: refreshData?
    
    
    var lines = [Lines(name: "MET", colour: TubeLineColours.metropolitan.lineColour),
                 Lines(name: "CIR", colour: TubeLineColours.circle.lineColour),
                 Lines(name: "DIS", colour: TubeLineColours.district.lineColour),
                 Lines(name: "OVR", colour: TubeLineColours.overground.lineColour),
                 Lines(name: "HMC", colour: TubeLineColours.hammersmithCity.lineColour),
                 Lines(name: "BAK", colour: TubeLineColours.bakerloo.lineColour),
                 Lines(name: "CEN", colour: TubeLineColours.central.lineColour),
                 Lines(name: "WAT", colour: TubeLineColours.waterlooCity.lineColour),
                 Lines(name: "VIC", colour: TubeLineColours.victoria.lineColour),
                 Lines(name: "PIC", colour: TubeLineColours.picadilly.lineColour),
                 Lines(name: "NOR", colour: TubeLineColours.northern.lineColour),
                 Lines(name: "JUB", colour: TubeLineColours.jubilee.lineColour),
    ]
    
    
    var stations = ["Pick a Line"]
    
    var line:String?
    var naptan:String?
    var direction:String?
    
    lazy var WelcomeBackText: UILabel = {
        let text = UILabel()
        text.layout(colour: greybluecolour, size: 15, text: "Welcome Back")
        return text
    }()
    
    lazy var TubeTapText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 28, text: "MindTheGap")
        return text
    }()
    
    lazy var TubeImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "underground")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var ChooseALine: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "Choose a Line")
        return text
    }()
    
    lazy var PickerContainerView: greyOutlineView = {
      let view = greyOutlineView()
        view.cornerRadius(radius: 20)
        return view
    }()
    
    lazy var GridCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(gridCell.self, forCellWithReuseIdentifier: "cell3")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .white
        collectionview.layer.cornerRadius = 20
        collectionview.layer.masksToBounds = true
        collectionview.layer.borderColor = lightgreybordercolour.cgColor
        collectionview.layer.borderWidth = 1
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        //collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    lazy var ChooseAStation: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "Choose a Station")
        return text
    }()
    
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    lazy var cameraModePicker: UIPickerView = {
        let cameraModePicker = UIPickerView()
        cameraModePicker.dataSource = self
        cameraModePicker.delegate = self
        cameraModePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        cameraModePicker.frame = CGRect(x: 0, y: 0, width: 50, height: 10)
        cameraModePicker.layer.masksToBounds = true
        cameraModePicker.translatesAutoresizingMaskIntoConstraints = false
        return cameraModePicker
    }()
    
    lazy var dot: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 50, text: ".")
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = .red
        return label
    }()
    
    lazy var Direction: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "Direction")
        return text
    }()
    
    lazy var DirectionContainerView: greyOutlineView = {
      let view = greyOutlineView()
        view.cornerRadius(radius: 20)
        return view
    }()
    
    lazy var TubeLogoImage: UIImageView = {
      let imageview = UIImageView()
        imageview.image = UIImage(named: "underground")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var Direction1: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: nil, size: 16, text: "Choose a Direction", image: nil, cornerRadius: 10)
        button.layer.borderWidth = 1
        button.layer.borderColor = purpleThemeColour.cgColor
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    lazy var Direction2: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: nil, size: 16, text: "Choose a Direction", image: nil, cornerRadius: 10)
        button.layer.borderWidth = 1
        button.layer.borderColor = purpleThemeColour.cgColor
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.backgroundColor = .red
        return stackView
    }()
    
    lazy var AddStationButton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: purpleThemeColour, size: 24, text: "Add Station", image: nil, cornerRadius: 10)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = offwhiteBackgroundcolour
        let middleOfPicker = stations.count / 2
        cameraModePicker.selectRow(middleOfPicker, inComponent: 0, animated: true)

        DispatchQueue.main.async {
            self.GridCollectionView.reloadData()
        }
        
        Direction1.addTarget(self, action: #selector(direction1), for: .touchUpInside)
        Direction2.addTarget(self, action: #selector(direction2), for: .touchUpInside)
        AddStationButton.addTarget(self, action: #selector(addStop), for: .touchUpInside)
        
    }
    
    var is1Selected = false
    var is2Selected = false
    
    @objc func direction1() {
        
        if is1Selected == false {
        is1Selected = true
        is2Selected = false
        UIView.animate(withDuration: 0.3) { // for animation effect
            self.Direction1.setNormal()
            self.Direction2.setHighlighted()
        }
    }
        else if is1Selected == true {
            is1Selected = false
            self.Direction1.setHighlighted()
        }
        
    }
        
    @objc func direction2() {
        
        //self.finalStopData.insert(Direction1.titleLabel!.text!, at: 2)
        if is2Selected == false {
        is2Selected = true
        is1Selected = false
        UIView.animate(withDuration: 0.3) { // for animation effect
            self.Direction1.setHighlighted()
            self.Direction2.setNormal()
        }
    }
        else if is2Selected == true {
            is2Selected = false
            self.Direction2.setHighlighted()
        }
    }
    
    
    @objc func addStop() {
        showSpinner(onView: view)
        print(is1Selected)
        print(is2Selected)
        
        if line == nil {
            self.AlertofError("Error", "A line is needed")
            self.removeSpinner()
            return
        }
        else if naptan == nil {
            self.AlertofError("Error", "A station is needed")
            self.removeSpinner()
            return
        }
        else if is1Selected == false && is2Selected == false {
            print("both false")
            self.AlertofError("Error", "Pick a direction")
            self.removeSpinner()
            return
        }
        if is1Selected {
            self.direction = self.Direction1.titleLabel!.text!
        }
        
        else if is2Selected {
            self.direction = self.Direction2.titleLabel!.text!
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UIDevice.vibrate()
        guard let Line = line else {return}
        guard let nap = naptan else {return}
        guard let dir = direction else {return}
        
        let ref = Firestore.firestore().collection("saved-stops").document(uid).collection("saved-stops").document()
        getLineData(naptan: nap, line: Line) { (data) in
            //print(data)
            let first = data.first
            let data = ["line":first?.lineName,"lowercaseline":first?.lineId,"naptanID":first?.naptanId,"direction":dir,"documentID":ref.documentID,"stationName":first?.stationName]
            ref.setData(data,merge: true)
            if let Delegate = self.delegate {
                Delegate.refreshData()
            }
            self.removeSpinner()
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    func getLineData(naptan: String, line: String, completion: @escaping(_ array: [tubeTimes]) -> ()) {
        var times = [tubeTimes]()
        print(line)
        print(naptan)
        guard let url = URL(string: "https://api.tfl.gov.uk/Line/\(line)/Arrivals/\(naptan)") else {
            print("Invalid URL")
            return
        }
                let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data {
                    do {
                        times = try JSONDecoder().decode([tubeTimes].self, from: data)
                    } catch {
                        print("Error", error)
                    }
                        DispatchQueue.main.async {
                            times.sort { (time1, time2) -> Bool in
                                return time1.timeToStation! < time2.timeToStation!
                            }
                            completion(times)
                        }
                }
            }.resume()
        }
    
    func getDirections(naptan: String, line: String, completion: @escaping(_ array: [tubeDirection]) -> ()) {
        var directions = [tubeDirection]()
        print(naptan)
        print(line)
        guard let url = URL(string: "https://api.tfl.gov.uk/Line/\(line)/Arrivals/\(naptan)") else {
            print("Invalid URL")
            return
        }
                let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data {
                    do {
                        directions = try JSONDecoder().decode([tubeDirection].self, from: data)
                    } catch {
                        print("Error", error)
                    }
                        DispatchQueue.main.async {
                                completion(directions)
                            }
                        }
                
            }.resume()
        }
    
    func setupView() {
        view.addSubview(WelcomeBackText)
        view.addSubview(TubeTapText)
        view.addSubview(TubeImage)
        view.addSubview(ChooseALine)
        view.addSubview(GridCollectionView)
        view.addSubview(ChooseAStation)
        view.addSubview(PickerContainerView)
        PickerContainerView.addSubview(cameraModePicker)
        PickerContainerView.addSubview(dot)
        view.addSubview(Direction)
        view.addSubview(DirectionContainerView)
        DirectionContainerView.addSubview(TubeLogoImage)
        DirectionContainerView.addSubview(stackView)
        stackView.addArrangedSubview(Direction1)
        stackView.addArrangedSubview(Direction2)
        view.addSubview(AddStationButton)


        WelcomeBackText.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        TubeTapText.anchor(top: WelcomeBackText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        TubeImage.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: TubeTapText.rightAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 35, height: 35)
        TubeImage.centerYAnchor.constraint(equalTo: TubeTapText.centerYAnchor,constant: 2).isActive = true
        
        ChooseALine.anchor(top: TubeTapText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        GridCollectionView.anchor(top: ChooseALine.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 200)
        
        ChooseAStation.anchor(top: GridCollectionView.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        PickerContainerView.anchor(top: ChooseAStation.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 50)
        
            //cameraModePicker.anchor(top: PickerContainerView.topAnchor, paddingTop: -100, bottom: nil, paddingBottom: 0, left: PickerContainerView.leftAnchor, paddingLeft: 0, right: PickerContainerView.rightAnchor, paddingRight: 0, width: 0, height: 450)
        
        cameraModePicker.centerYAnchor.constraint(equalTo: PickerContainerView.centerYAnchor).isActive = true
        cameraModePicker.centerXAnchor.constraint(equalTo: PickerContainerView.centerXAnchor).isActive = true
        cameraModePicker.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        dot.anchor(top: nil, paddingTop: 0, bottom: PickerContainerView.bottomAnchor, paddingBottom: 4, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 40, height: 40)
        dot.centerXAnchor.constraint(equalTo: PickerContainerView.centerXAnchor,constant: 12).isActive = true
        
        Direction.anchor(top: PickerContainerView.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        DirectionContainerView.anchor(top: Direction.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 100)
        
        TubeLogoImage.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: DirectionContainerView.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 60, height: 60)
        TubeLogoImage.centerYAnchor.constraint(equalTo: DirectionContainerView.centerYAnchor).isActive = true
   
        stackView.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: TubeLogoImage.rightAnchor, paddingLeft: 10, right: DirectionContainerView.rightAnchor, paddingRight: 20, width: 0, height: 0)
        stackView.centerYAnchor.constraint(equalTo: DirectionContainerView.centerYAnchor).isActive = true
        
        Direction1.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.48).isActive = true
        Direction2.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.48).isActive = true
        
        Direction1.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2).isActive = true
        Direction2.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2).isActive = true
   
        AddStationButton.anchor(top: DirectionContainerView.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 50)
    
    }
    
    
    func getNaptanIDFromName(name:String, completion: @escaping(_ id:String) -> ()) {
        
        let napRef = Firestore.firestore().collection("naptanID").document(name)
        napRef.getDocument { (document, error) in
            if document?.exists == false || error != nil{
                completion("unavailable")
            }
            else {
                let data = document?.data()
                let naptanID = data?["naptanID"] as! String
                completion(naptanID)
            }
        }
    }
    
    
    
    var bakerloo = ["Baker Street", "Charing Cross", "Edgware Road (Bakerloo)", "Elephant & Castle", "Embankment", "Harlesden", "Harrow & Wealdstone", "Kensal Green", "Kenton", "Kilburn Park", "Lambeth North", "Maida Vale", "Marylebone", "North Wembley", "Oxford Circus", "Piccadilly Circus", "Queens Park", "Regent’s Park", "South Kenton", "Stonebridge Park", "Warwick Avenue", "Waterloo", "Wembley Central", "Willesden Junction"]
    
    var central = ["Bank", "Barkingside", "Bethnal Green", "Bond Street", "Buckhurst Hill", "Chancery Lane", "Chigwell", "Debden", "Ealing Broadway", "East Acton", "Epping", "Fairlop", "Gants Hill", "Grange Hill", "Greenford", "Hainault", "Hanger Lane", "Holborn", "Holland Park", "Lancaster Gate", "Leyton", "Leytonstone", "Liverpool Street", "Loughton", "Marble Arch", "Mile End", "Newbury Park", "North Acton", "Northolt", "Notting Hill Gate", "Oxford Circus", "Perivale", "Queensway", "Redbridge", "Roding Valley", "Ruislip Gardens", "Shepherd’s Bush (Central)", "Snaresbrook", "South Ruislip", "South Woodford", "St. Paul’s", "Stratford", "Theydon Bois", "Tottenham Court Road", "Wanstead", "West Acton", "West Ruislip", "White City", "Woodford"]
    
    var circle = ["Aldgate", "Baker Street", "Barbican", "Bayswater", "Blackfriars", "Cannon Street", "Edgware Road (Circle Line)", "Embankment", "Euston Square", "Farringdon", "Gloucester Road", "Goldhawk Road", "Great Portland Street", "Hammersmith", "High Street Kensington", "King’s Cross St. Pancras", "Ladbroke Grove", "Latimer Road", "Liverpool Street", "Mansion House", "Monument", "Moorgate", "Notting Hill Gate", "Paddington (Circle)", "Royal Oak", "Shepherd’s Bush Market", "Sloane Square", "South Kensington", "St. James’s Park", "Temple", "Tower Hill", "Victoria", "Westbourne Park", "Westminster", "Wood Lane"]
    
    var district = ["Acton Town", "Aldgate East", "Barking", "Barons Court", "Bayswater", "Becontree", "Blackfriars", "Bow Church", "Bow Road", "Bromley-by-Bow", "Cannon Street", "Chiswick Park", "Dagenham East", "Dagenham Heathway", "Ealing Broadway", "Ealing Common", "Earl’s Court", "East Ham", "East Putney", "Edgware Road", "Elm Park", "Embankment", "Fulham Broadway", "Gloucester Road", "Gunnersbury", "Hammersmith", "High Street Kensington", "Hornchurch", "Kensington", "Kew Gardens", "Mansion House", "Monument", "Notting Hill Gate", "Paddington", "Parsons Green", "Plaistow", "Putney Bridge", "Ravenscourt Park", "Richmond", "Sloane Square", "South Kensington", "Southfields", "St. James’s Park", "Stamford Brook", "Stepney Green", "Temple", "Tower Hill", "Turnham Green", "Upminster", "Upminster Bridge", "Upney", "Upton Park", "Victoria", "West Brompton", "West Ham", "West Kensington", "Westminster", "Whitechapel", "Wimbledon", "Wimbledon Park"]
    
    var hammersmithcity = ["Aldgate East", "Baker Street", "Barbican", "Barking", "Bow Road", "Bromley-by-Bow", "East Ham", "Euston Square", "Farringdon", "Goldhawk Road", "Great Portland Street", "Hammersmith (H&C Line)", "Kings Cross St. Pancras", "Ladbroke Grove", "Latimer Road", "Liverpool Street", "Mile End", "Moorgate", "Paddington (H&C Line)", "Plaistow", "Royal Oak", "Shepherds Bush Market", "Stepney Green", "Upton Park", "West Ham", "Westbourne Park", "Whitechapel", "Wood Lane"]

    
    var metropolitan = ["Aldgate", "Amersham", "Baker Street", "Barbican", "Chalfont & Latimer", "Chesham", "Chorleywood", "Croxley", "Eastcote", "Euston Square", "Farringdon", "Finchley Road", "Great Portland Street", "Harrow-on-the-Hill", "Hillingdon", "Ickenham", "King’s Cross St. Pancras", "Liverpool Street", "Moor Park", "Moorgate", "North Harrow", "Northwick Park", "Northwood", "Northwood Hills", "Pinner", "Preston Road", "Rickmansworth", "Ruislip", "Ruislip Manor", "Uxbridge", "Watford", "Wembley Park", "West Harrow"]
    
    var northern = ["Angel", "Archway", "Balham", "Bank", "Belsize Park", "Borough", "Brent Cross", "Burnt Oak", "Camden Town", "Chalk Farm", "Charing Cross", "Clapham Common", "Clapham North", "Clapham South", "Colindale", "Colliers Wood", "East Finchley", "Edgware", "Elephant & Castle", "Embankment", "Euston", "Finchley Central", "Golders Green", "Goodge Street", "Hampstead", "Hendon Central", "High Barnet", "Highgate", "Kennington", "Kentish Town", "King’s Cross St. Pancras", "Leicester Square", "London Bridge", "Mill Hill East", "Moorgate", "Morden", "Mornington Crescent", "Old Street", "Oval", "South Wimbledon", "Stockwell", "Tooting Bec", "Tooting Broadway", "Tottenham Court Road", "Totteridge & Whetstone", "Tufnell Park", "Warren Street", "Waterloo", "West Finchley", "Woodside Park"]
    
    var overground = ["Acton Central", "Anerley", "Barking", "Bethnal Green", "Blackhorse Road", "Brockley", "Brondesbury", "Brondesbury Park", "Bruce Grove", "Bush Hill Park", "Bushey", "Caledonian Road & Barnsbury", "Cambridge Heath", "Camden Road", "Canada Water", "Canonbury", "Carpenders Park", "Cheshunt", "Chingford", "Clapham High Street", "Clapham Junction", "Clapton", "Crouch Hill", "Crystal Palace", "Dalston Junction", "Dalston Kingsland", "Denmark Hill", "Edmonton Green", "Emerson Park", "Enfield Town", "Euston", "Finchley Road & Frognal", "Forest Hill", "Gospel Oak", "Gunnersbury", "Hackney Central", "Hackney Downs", "Hackney Wick", "Haggerston", "Hampstead Heath", "Harlesden", "Harringay Green Lanes", "Harrow & Wealdstone", "Hatch End", "Headstone Lane", "Highams Park", "Highbury & Islington", "Homerton", "Honor Oak Park", "Hoxton", "Imperial Wharf", "Kensal Green", "Kensal Rise", "Kensington", "Kentish Town West", "Kenton", "Kew Gardens", "Kilburn High Road", "Leyton Midland Road", "Leytonstone High Road", "Liverpool Street", "London Fields", "New Cross", "New Cross Gate", "North Wembley", "Norwood Junction", "Peckham Rye", "Penge West", "Queens Park", "Queens Road Peckham", "Rectory Road", "Richmond", "Romford", "Rotherhithe", "Seven Sisters", "Shadwell", "Shepherds Bush", "Shoreditch High Street", "Silver Street", "South Acton", "South Hampstead", "South Kenton", "South Tottenham", "Southbury", "St James Street", "Stamford Hill", "Stoke Newington", "Stonebridge Park", "Stratford", "Surrey Quays", "Sydenham", "Theobalds Grove", "Turkey Street", "Upminster", "Upper Holloway", "Walthamstow Central", "Walthamstow Queens Road", "Wandsworth Road", "Wanstead Park", "Wapping", "Watford High Street", "Watford Junction", "Wembley Central", "West Brompton", "West Croydon", "West Hampstead", "White Hart Lane", "Whitechapel", "Willesden Junction", "Wood Street", "Woodgrange Park"]
    
    var piccadilly = ["Acton Town", "Alperton", "Arnos Grove", "Arsenal", "Barons Court", "Boston Manor", "Bounds Green", "Caledonian Road", "Cockfosters", "Covent Garden", "Ealing Common", "Earl’s Court", "Eastcote", "Finsbury Park", "Gloucester Road", "Green Park", "Hammersmith", "Hatton Cross", "Heathrow Terminal 4", "Heathrow Terminal 5", "Heathrow Terminals 2 & 3", "Hillingdon", "Holborn", "Holloway Road", "Hounslow Central", "Hounslow East", "Hounslow West", "Hyde Park Corner", "Ickenham", "King’s Cross St. Pancras", "Knightsbridge", "Leicester Square", "Manor House", "North Ealing", "Northfields", "Oakwood", "Osterley", "Park Royal", "Piccadilly Circus", "Rayners Lane", "Ruislip", "Ruislip Manor", "Russell Square", "South Ealing", "South Harrow", "South Kensington", "Southgate", "Sudbury Hill", "Sudbury Town", "Turnham Green", "Turnpike Lane", "Uxbridge", "Wood Green"]
    
    var victoria = ["Blackhorse Road", "Brixton", "Euston", "Finsbury Park", "Green Park", "Highbury & Islington", "King’s Cross St. Pancras", "Oxford Circus", "Pimlico", "Seven Sisters", "Stockwell", "Tottenham Hale", "Vauxhall", "Victoria", "Walthamstow Central", "Warren Street"]
    
    var waterloocity = ["Bank", "Waterloo"]
    
    var jubilee = ["Baker Street", "Bermondsey", "Bond Street", "Canada Water", "Canary Wharf", "Canning Town", "Canons Park", "Dollis Hill", "Finchley Road", "Green Park", "Kilburn", "Kingsbury", "London Bridge", "Neasden", "North Greenwich", "Queensbury", "Southwark", "St. John’s Wood", "Stanmore", "Stratford", "Swiss Cottage", "Waterloo", "Wembley Park", "West Ham", "West Hampstead", "Westminster", "Willesden Green"]
    
}

extension AddLinePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return lines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! gridCell
            let data = lines[indexPath.row]
            cell.lineName.text = data.name
            cell.backgroundColor = data.colour
            cell.layer.cornerRadius = 13
            cell.layer.masksToBounds = true
            return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 4

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size-5, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 15, left: 3, bottom: 0, right: 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 35
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if let cell = GridCollectionView.cellForItem(at: indexPath) as? gridCell {
            let array = returnArray(station: cell.lineName.text!)
            stations.removeAll()
            stations = array
            cameraModePicker.reloadAllComponents()
            self.line = returnlineName(station: cell.lineName.text!)
            
        }
    }

    
    }

extension AddLinePage: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        getNaptanIDFromName(name: stations[row]) { (id) in
            guard let Line = self.line else {return}

            self.getDirections(naptan: id, line: Line) { (platforms) in
                print(platforms)
                let removedDupes = platforms.removeDuplicates()
                print(removedDupes)
                self.Direction1.setTitle(removedDupes[optional:0]?.platformName, for: .normal)
                self.Direction2.setTitle(removedDupes[optional:1]?.platformName, for: .normal)
            }
            
            if id == "unavailable" {
                DispatchQueue.main.async {
                self.AlertofError("Sorry", "This station isn't supported yet")
                }
            }
            else {
                self.naptan = id
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stations.count
    }
    
    //Here we need to display a label , you can add any custom UI here.
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews[1].backgroundColor = UIColor.clear
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 300, height: 150)
        let modeLabel = UILabel()
        modeLabel.textColor = .black
        modeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        modeLabel.text = stations[row]
        modeLabel.adjustsFontSizeToFitWidth = true
        modeLabel.numberOfLines = 0
        modeLabel.minimumScaleFactor = 0.5
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
        modeLabel.anchor(top: modeView.topAnchor, paddingTop: 0, bottom: modeView.bottomAnchor, paddingBottom: 0, left: modeView.leftAnchor, paddingLeft: 0, right: modeView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return modeView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func returnArray(station: String) -> [String]{
        switch station {
        case "MET":
        return metropolitan
        case "CIR":
        return circle
        case "DIS":
        return district
        case "OVR":
        return overground
        case "HMC":
        return hammersmithcity
        case "BAK":
        return bakerloo
        case "CEN":
        return central
        case "WAT":
        return waterloocity
        case "VIC":
        return victoria
        case "PIC":
        return piccadilly
        case "NOR":
        return northern
        case "JUB":
        return jubilee
        default:
            return bakerloo
        }
    }
    
    func returnlineName(station: String) -> String{
        switch station {
        case "MET":
        return "metropolitan"
        case "CIR":
        return "circle"
        case "DIS":
        return "district"
        case "OVR":
        return "london-overground"
        case "HMC":
        return "hammersmith-city"
        case "BAK":
        return "bakerloo"
        case "CEN":
        return "central"
        case "WAT":
        return "waterloo-city"
        case "VIC":
        return "victoria"
        case "PIC":
        return "piccadilly"
        case "NOR":
        return "northern"
        case "JUB":
        return "jubilee"
        default:
            return "bakerloo"
        }
    }
    
}

