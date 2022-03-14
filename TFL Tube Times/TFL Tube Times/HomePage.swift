//
//  HomePage.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 06/03/2021.
//


//fix opposite directions
//fix times updating
//fix spacing of pickerview cells
//fix where im putting destination name

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol refreshData {
    func refreshData()
}

class HomePage: UIViewController, refreshData {

    var offwhiteBackgroundcolour = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    var greybluecolour = UIColor(red: 0.36, green: 0.44, blue: 0.52, alpha: 1.00)
    var lightgreybordercolour = UIColor(red: 0.84, green: 0.86, blue: 0.88, alpha: 1.00)
    var timer: Timer?
    
    var traintimes = [tubeTimes]()
    var naptanIDS = [NaptanLine]()
    var finalTableArray = [tableArray]()
    var timeArray = [TimeDestination]()
    
    lazy var WelcomeBackText: UILabel = {
        let text = UILabel()
        if let name = Auth.auth().currentUser?.displayName {
            text.layout(colour: greybluecolour, size: 15, text: "Welcome Back \(name)")
        }
        return text
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
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
    
    lazy var AddStopButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = lightgreybordercolour.cgColor
        button.SFSymbolFont(button: button, symbol: "plus", size: 20, colour: .black)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var MySavedStopsText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "My Saved Stops")
        return text
    }()
    
    lazy var stopcollectionview: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(StopCell.self, forCellWithReuseIdentifier: "cell")
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
    
    lazy var ServiceDisruptionsText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "Service Disruptions")
        return text
    }()
    
    lazy var disruptionscollectionview: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(DisruptionsCell.self, forCellWithReuseIdentifier: "cell1")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .white
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    func refreshData() {
        self.finalTableArray.removeAll()
        self.timeArray.removeAll()
        getSavedStops()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = offwhiteBackgroundcolour
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        setupView()
        getTubeStatus()
        isLoggedIn()
        AddStopButton.addTarget(self, action: #selector(goToAddLine), for: .touchUpInside)
        getSavedStops()
//        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (timer) in
//            self.getSavedStops()
//        })
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        stopcollectionview.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = stopcollectionview.indexPathForItem(at: gesture.location(in: stopcollectionview)) else {
                break
            }
            stopcollectionview.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            stopcollectionview.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            stopcollectionview.endInteractiveMovement()
        default:
            stopcollectionview.cancelInteractiveMovement()
        }
    }
    
    func getSavedStops() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("saved-stops").document(uid).collection("saved-stops")
        ref.addSnapshotListener({ (snapshot, err) in
            self.finalTableArray.removeAll()
            self.timeArray.removeAll()
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                print(snapshot!.documents.count, "saved stops")
                for document in snapshot!.documents {
                    let data = document.data()
                    let documentname = document.documentID
                    self.getTimes(documentName: documentname)
                    guard let line = data["line"] as? String else {return}
                    guard let lineLowerCase = data["lowercaseline"] as? String else {return}
                    guard let direction = data["direction"] as? String else {return}
                    guard let naptan = data["naptanID"] as? String else {return}
                    guard let stationName = data["stationName"] as? String else {return}
                    self.updateTubeTimes(naptanID: naptan, line: lineLowerCase, documentID: documentname, direction: direction)
                        let stop = tableArray(lineName: line, lineid: lineLowerCase, directionName: direction, naptanID: naptan,stationName: stationName, documentID: documentname)
                        self.finalTableArray.append(stop)
                    }
                DispatchQueue.main.async {
                    self.stopcollectionview.reloadData()
                    }
                }
            })
        }
    
    
    func getTimes(documentName:String) {
        print("getting times for",documentName)

        guard let uid = Auth.auth().currentUser?.uid else {return}
        let timeRef = Firestore.firestore().collection("saved-stops").document(uid).collection("saved-stops").document(documentName).collection("times").document("arrival-times")
        
        timeRef.addSnapshotListener({ (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                let data = snapshot?.data()
                let time1 = data?["0"] as? Int
                let time2 = data?["1"] as? Int
                let time3 = data?["2"] as? Int
                let destination1 = data?["0 destination"] as? String
                let destination2 = data?["1 destination"] as? String
                let destination3 = data?["2 destination"] as? String
                let times = TimeDestination(time1: time1, time2: time2, time3: time3, destination1: destination1, destination2: destination2, destination3: destination3)
                DispatchQueue.main.async {
                    print("updating times for",documentName)
                    self.timeArray.append(times)
                    self.stopcollectionview.reloadData()
                }
            }
        })
    }

    
    func updateTubeTimes(naptanID: String?, line:String?, documentID: String?,direction:String) {
        print(documentID!)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let DocumentID = documentID else {return}
        guard let nap = naptanID else {return}
        guard let Line = line else {return}
        let ref = Firestore.firestore().collection("saved-stops").document(uid).collection("saved-stops").document(DocumentID).collection("times").document("arrival-times")
        
        getTrainTimes(naptan: nap, line: Line) { (times) in
            var count = 0
            for time in times {
                if time.platformName == direction {
                    print(time.timeToStation!, time.platformName!)
                    let data:[String : Any] = ["\(count)":time.timeToStation ?? "error", "\(count) destination":time.destinationName ?? "error","\(count) direction":time.platformName ?? "error"]
                    ref.setData(data,merge: true)
                    count += 1
                }
            }
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            self.getTrainTimes(naptan: nap, line: Line) { (times) in
                var count = 0
                for time in times {
                    if time.platformName == direction {
                        //print(time.timeToStation, time.platformName)
                        let data:[String : Any] = ["\(count)":time.timeToStation ?? "error", "\(count) destination":time.destinationName ?? "error"]
                        ref.setData(data,merge: true)
                        count += 1
                    }
                }
            }
        })

        
    }
    
    
    func getTrainTimes(naptan: String, line: String, completion: @escaping(_ array: [tubeTimes]) -> ()) {
        var times = [tubeTimes]()
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

    func isLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
           //load the pictures
        }
    }

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print("logout error", logoutError)
        }
        
        let landingpage = Login()
        let nav = UINavigationController(rootViewController: landingpage)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }

    @objc func LogOut() {
        do { try Auth.auth().signOut() }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)}
            let landingpage = Login()
            let nav = UINavigationController(rootViewController: landingpage)
            tabBarController?.selectedIndex = 0
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
    }
    
    func getLineName(name: String) -> String{
        switch name {
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
        return "picadilly"
        case "NOR":
        return "northern"
        case "JUB":
        return "jubilee"
        default:
            return "jubilee"
        }
    }
    
    @objc func goToAddLine() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let addstop = AddLinePage()
        addstop.delegate = self
        navigationController?.pushViewController(addstop, animated: true)
    }
    
    var tubeStatus = [TubeStatus]()
    
    func getTubeStatus() {
        guard let url = URL(string: "https://api.tfl.gov.uk/line/mode/tube/status") else {
            print("Invalid URL")
            return
        }
                let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data {
                    do {
                        self.tubeStatus = try JSONDecoder().decode([TubeStatus].self, from: data)
                    } catch {
                        print("Error")
                    }
                        DispatchQueue.main.async {
                            //decodedResponse is now [User] rather than Response.User
                            //print(self.tubeStatus.count)
                            self.disruptionscollectionview.reloadData()
                        }
                }
            }.resume()
        }

    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(WelcomeBackText)
        scrollView.addSubview(TubeTapText)
        scrollView.addSubview(TubeImage)
        scrollView.addSubview(AddStopButton)
        scrollView.addSubview(MySavedStopsText)
        scrollView.addSubview(stopcollectionview)
        scrollView.addSubview(ServiceDisruptionsText)
        scrollView.addSubview(disruptionscollectionview)
        
        scrollView.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        WelcomeBackText.anchor(top: scrollView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        TubeTapText.anchor(top: WelcomeBackText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        TubeImage.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: TubeTapText.rightAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 35, height: 35)
        TubeImage.centerYAnchor.constraint(equalTo: TubeTapText.centerYAnchor,constant: 2).isActive = true
        
        AddStopButton.anchor(top: WelcomeBackText.topAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 44, height: 44)
        
        MySavedStopsText.anchor(top: TubeTapText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        stopcollectionview.anchor(top: MySavedStopsText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: AddStopButton.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        ServiceDisruptionsText.anchor(top: stopcollectionview.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        disruptionscollectionview.anchor(top: ServiceDisruptionsText.bottomAnchor, paddingTop: 20, bottom: scrollView.bottomAnchor, paddingBottom: 0, left: TubeTapText.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 150)
    }
    
    func changeTime(time: Int) -> String? {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .short

        let formattedString = formatter.string(from: TimeInterval(time))
        return formattedString
    }
    
    func returnColorValue(lineName: String) -> UIColor{
         switch lineName {
        case "Jubilee":
            return TubeLineColours.jubilee.lineColour
         case "Central":
             return TubeLineColours.central.lineColour
         case "Circle":
             return TubeLineColours.circle.lineColour
         case "District":
             return TubeLineColours.district.lineColour
         case "Metropolitan":
             return TubeLineColours.metropolitan.lineColour
         case "Piccadilly":
             return TubeLineColours.picadilly.lineColour
         case "Victoria":
             return TubeLineColours.victoria.lineColour
         case "Hammmersmith & City":
             return TubeLineColours.hammersmithCity.lineColour
         case "Waterloo & City":
             return TubeLineColours.waterlooCity.lineColour
         case "Northern":
             return TubeLineColours.northern.lineColour
         case "Bakerloo":
             return TubeLineColours.bakerloo.lineColour
         case "London Overground":
                return TubeLineColours.overground.lineColour
        default:
            return .red
        }
    }
}



extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
       return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = finalTableArray.remove(at: sourceIndexPath.item)
        let temp1 = timeArray.remove(at: sourceIndexPath.item)
        finalTableArray.insert(temp, at: destinationIndexPath.item)
        timeArray.insert(temp1, at: destinationIndexPath.item)
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.stopcollectionview {
            return finalTableArray.count
        }

        return tubeStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.stopcollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StopCell
            let data = finalTableArray[indexPath.row]
            var times = timeArray[optional:indexPath.row]
            cell.delegate = self
            if var name = data.stationName {
                let wordsToRemove = ["Rail Station", "Underground Station"]
                for word in wordsToRemove {
                    if let range = name.range(of: word) {
                        name.removeSubrange(range)
                        cell.LineText.text = "\(name)"
                    }
                }
            }
            
            if let time1 = times?.time1 {
                //print(time1)
                UIView.transition(with: cell.TimeText1, duration: 1, options: [.transitionFlipFromTop], animations: {
                    let time = self.changeTime(time:time1)
                    if time == "0 min" {
                        cell.TimeText1.text = "Now"
                    }
                    else {
                        cell.TimeText1.text = self.changeTime(time:time1)
                    }
                    
                }, completion: nil)
            }

            if let time2 = times?.time2 {
                //print(time2)
                UIView.transition(with: cell.TimeText2, duration: 1, options: [.transitionFlipFromTop], animations: {
                    cell.TimeText2.text = self.changeTime(time:time2)
                }, completion: nil)
               
            }

            if let time3 = times?.time3{
                //print(time3)
                UIView.transition(with: cell.TimeText3, duration: 1, options: [.transitionFlipFromTop], animations: {
                    cell.TimeText3.text = self.changeTime(time:time3)
                }, completion: nil)
            }

            if var destination = times?.destination1 {
                let wordsToRemove = ["Rail Station", "Underground Station"]
                for word in wordsToRemove {
                    if let range = destination.range(of: word) {
                        destination.removeSubrange(range)
                    cell.StationDirectionText.text = "\(destination) | \(data.directionName!)"
                    }
                }

            }
           
            if let line = data.lineName {
                cell.colourLine.backgroundColor = returnColorValue(lineName: line)
            }


            // Set up cell
            return cell
        }

        else {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! DisruptionsCell
            let data = tubeStatus[indexPath.row]
            cell1.layer.cornerRadius = 15
            cell1.layer.masksToBounds = true
            cell1.layer.borderWidth = 1
            cell1.layer.borderColor = lightgreybordercolour.cgColor
            cell1.LineName.text = data.name
            if let name = data.name {
                cell1.TubeLogoImage.image = returnImageForLine(line: name)
            }
            
            cell1.LineStatus.text = data.lineStatuses[0].statusSeverityDescription
            
            if data.lineStatuses[0].statusSeverityDescription == "Good Service" {
                cell1.LineStatus.textColor = UIColor(red: 0.19, green: 0.72, blue: 0.24, alpha: 1.00)
            }
            
            else if data.lineStatuses[0].statusSeverityDescription == "Severe Delays"  {
                cell1.LineStatus.textColor = .orange
            }
            
            else if data.lineStatuses[0].statusSeverityDescription == "Minor Delays" {
                cell1.LineStatus.textColor = .orange
            }
            
            else if data.lineStatuses[0].statusSeverityDescription == "Planned Closure" {
                cell1.LineStatus.textColor = .red
            }

            //cell1.Reason.text = data.lineStatuses[0].reason

            return cell1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.stopcollectionview {
            let itemWidth = collectionView.bounds.width
            let itemSize = CGSize(width: itemWidth, height: 80)
            return itemSize // Replace with count of your data for collectionViewA
        }
        else {
           let itemSize = CGSize(width: 140, height: 150)
           return itemSize
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.stopcollectionview {
            return 1.5
        }
        else {
            return 20
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.stopcollectionview {
            return 1.5
        }
        else {
            return 20
        }
    }
    
    func returnImageForLine(line:String) -> UIImage {
        let defaultImage = UIImage(named: "underground")!
        switch line {
        case "Bakerloo":
            let image = UIImage(named: "BAK")
            return image!
        case "Circle":
            let image = UIImage(named: "CIR")
            return image!
        case "District":
            let image = UIImage(named: "DIS")
            return image!
        case "Jubilee":
            let image = UIImage(named: "JUB")
            return image!
        case "Overground":
            let image = UIImage(named: "OVR")
            return image!
        case "Central":
            let image = UIImage(named: "CEN")
            return image!
        case "Hammersmith & City":
            let image = UIImage(named: "HMC")
            return image!
        case "Northern":
            let image = UIImage(named: "NOR")
            return image!
        case "Piccadilly":
            let image = UIImage(named: "PIC")
            return image!
        case "Victoria":
            let image = UIImage(named: "VIC")
            return image!
        case "Waterloo & City":
            let image = UIImage(named: "WAT")
            return image!
        case "Metropolitan":
            let image = UIImage(named: "MET")
            return image!
        default:
            return defaultImage
        }
    }
    
}

extension HomePage: SwipeableCollectionViewCellDelegate {
    
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let indexPath = stopcollectionview.indexPath(for: cell) else { return }
        guard let docID = finalTableArray[indexPath.item].documentID else {return}
        finalTableArray.remove(at: indexPath.item)
        let ref = Firestore.firestore().collection("saved-stops").document(uid).collection("saved-stops").document(docID)
        let timeref = Firestore.firestore().collection("saved-stops").document(uid).collection("saved-stops").document(docID).collection("times").document("arrival-times")
        ref.delete()
        timeref.delete()
        stopcollectionview.performBatchUpdates({
            self.stopcollectionview.deleteItems(at: [indexPath])
        })
        
        DispatchQueue.main.async {
            self.stopcollectionview.reloadData()
            self.stopcollectionview.layoutIfNeeded()
        }
    }
    
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = stopcollectionview.indexPath(for: cell) else { return }
        print("Tapped item at index path: \(indexPath)")
    }
}
