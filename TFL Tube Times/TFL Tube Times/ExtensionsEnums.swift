    //
    //  ExtensionsEnums.swift
    //  TFL Tube Times
    //
    //  Created by Christian Grinling on 06/03/2021.
    //

    import Foundation
    import UIKit
    import AVFoundation
    enum TubeLineColours {
        
        case bakerloo
        case central
        case hammersmithCity
        case circle
        case district
        case jubilee
        case metropolitan
        case northern
        case overground
        case picadilly
        case victoria
        case waterlooCity

        var lineColour : UIColor{
            
          switch self{
          
              case .bakerloo:
                return UIColor(red: 0.70, green: 0.39, blue: 0.00, alpha: 1.00)
                
              case .central:
                return UIColor(red: 0.86, green: 0.14, blue: 0.12, alpha: 1.00)
                
              case .hammersmithCity:
                return UIColor(red: 0.96, green: 0.66, blue: 0.75, alpha: 1.00)
                
              case .circle:
                return UIColor(red: 1.00, green: 0.83, blue: 0.16, alpha: 1.00)
                
              case .district:
                return UIColor(red: 0.00, green: 0.49, blue: 0.20, alpha: 1.00)
                
              case .jubilee:
                return UIColor(red: 0.63, green: 0.65, blue: 0.65, alpha: 1.00)
                
              case .metropolitan:
                return UIColor(red: 0.61, green: 0.00, blue: 0.35, alpha: 1.00)
                
              case .northern:
                return .black
                
              case .overground:
                return UIColor(red: 0.94, green: 0.48, blue: 0.06, alpha: 1.00)
                
              case .picadilly:
                return UIColor(red: 0.00, green: 0.10, blue: 0.66, alpha: 1.00)
                
              case .victoria:
                return UIColor(red: 0.00, green: 0.60, blue: 0.85, alpha: 1.00)
                
              case .waterlooCity:
                return UIColor(red: 0.58, green: 0.81, blue: 0.73, alpha: 1.00)

                

            }
         }
    }

    extension UIView {
        
        func pinEdgesToSuperView() {
            guard let superView = superview else { return }
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
            rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        }
        
        func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
            
        if let top = top {
        topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
            }
            
        if let bottom = bottom {
        bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
            
        if let right = right {
        rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
            
        if let left = left {
        leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
            }
            
        if width != 0 {
        widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            
        if height != 0 {
        heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
        
        func SFSymbolFont(button: UIButton, symbol: String, size: CGFloat, colour: UIColor) {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .bold, scale: .large)
            let largeBoldDoc = UIImage(systemName: symbol, withConfiguration: largeConfig)?.withTintColor(colour).withRenderingMode(.alwaysOriginal)
            button.setImage(largeBoldDoc, for: .normal)
        }
    }

    extension UILabel {
        func layout(colour:UIColor, size: CGFloat, text: String) {
            self.text = text
            self.textColor = colour
            self.font = UIFont.boldSystemFont(ofSize: size)
        }
    }

    extension UIButton {
        
        
        func layout(textcolour:UIColor?, backgroundColour:UIColor?, size: CGFloat?, text: String?, image: UIImage?, cornerRadius: CGFloat?) {
            setTitle(text, for: .normal)
            setTitleColor(textcolour, for: .normal)
            if let Size = size {
                titleLabel?.font = UIFont.boldSystemFont(ofSize: Size)
            }

            setImage(image, for: .normal)
            if let radius = cornerRadius {
            layer.cornerRadius = radius
            }
            layer.masksToBounds = true
            backgroundColor = backgroundColour
        
        }
        
        func setHighlighted() {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            backgroundColor = .white
            layer.borderWidth = 1
            layer.borderColor = UIColor(red: 0.38, green: 0.11, blue: 0.81, alpha: 1.00).cgColor
            setTitleColor(.black, for: .normal)
        }
        
        func setNormal() {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            backgroundColor = UIColor(red: 0.38, green: 0.11, blue: 0.81, alpha: 1.00)
            layer.borderWidth = 0
            layer.borderColor = nil
            setTitleColor(.white, for: .normal)
        }
    }

    class SelfSizedCollectionView: UICollectionView {
        override func reloadData() {
            super.reloadData()
            self.invalidateIntrinsicContentSize()
        }

        override var intrinsicContentSize: CGSize {
            let s = self.collectionViewLayout.collectionViewContentSize
            return CGSize(width: max(s.width, 1), height: max(s.height,1))
        }

    }

//    struct tubeTimes: Codable, Identifiable {
//
//        public var id: Int
//        public var naptanId: String
//        public var lineId: String
//        public var stationName: String
//        public var platformName: String
//        public var timeToStation: Int
//
//        enum TubeTimeKeys: String, CodingKey {
//               case id = "id"
//               case naptanId = "naptanId"
//               case lineId = "lineId"
//               case stationName = "stationName"
//               case platformName = "platformName"
//               case timeToStation = "timeToStation"
//            }
//        }
    
    struct tubeTimes: Decodable {
        
        var naptanId: String?
        var lineId: String?
        var stationName: String?
        var platformName: String?
        var timeToStation: Int?
        var lineName: String?
        var destinationName: String?
        }
    
    struct tubeDirection: Decodable, Hashable {
        var platformName: String?
        }


    class greyOutlineView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.borderWidth = 1
            layer.borderColor =  UIColor(red: 0.84, green: 0.86, blue: 0.88, alpha: 1.00).cgColor
        }
        
        func cornerRadius(radius:CGFloat) {
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

    extension UIColor {
        
        static let lightgreybordercolour = UIColor(red: 0.84, green: 0.86, blue: 0.88, alpha: 1.00)
        static let offwhiteBackgroundcolour = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
        static let greybluecolour = UIColor(red: 0.36, green: 0.44, blue: 0.52, alpha: 1.00)
    }

    class TubeLineViews: UIButton {
        
        lazy var Stationtext: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.layout(colour: .white, size: 30, text: "")
            return text
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            //addSubview(Stationtext)
            //Stationtext.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            //Stationtext.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        func layout(colour: UIColor, text: String) {
            layer.cornerRadius = 20
            layer.masksToBounds = true
            backgroundColor = colour
            //setTitle(text, for: .normal)
            titleLabel?.layout(colour: .white, size: 30, text: text)
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class CustomStackView: UIStackView {
        
        func layout(radius: CGFloat, width:CGFloat, colour:CGColor) {
            axis = .horizontal
            alignment = .center
            distribution = .fillEqually
            spacing = spacing
            translatesAutoresizingMaskIntoConstraints = false
            layer.cornerRadius = radius
            layer.masksToBounds = true
            layer.borderWidth = width
            layer.borderColor = colour
        }

    }

    
    struct Lines {
        var name: String
        var colour: UIColor
    }
    
    struct status: Decodable {
        var statusSeverityDescription: String
        var reason: String?
    }
    
    struct TubeStatus: Decodable {
        
        var name: String?
        var lineStatuses = [status]()
    }

    
    extension UIDevice {
        static func vibrate() {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

    struct Matches: Decodable {
        var id: String
    }
    
    
    struct NaptanID: Decodable {
        var matches = [Matches]()
    }
    
    extension Collection {

        subscript(optional i: Index) -> Iterator.Element? {
            return self.indices.contains(i) ? self[i] : nil
        }

    }
    
    extension UIViewController {
        
        func AlertofError(_ error:String, _ Message:String){
            let alertController = UIAlertController(title: "\(error)", message: "\(Message)", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        func Alert(_ field:String){
           let alertController = UIAlertController(title: "\(field) Needed", message: "Please type in \(field)", preferredStyle: .alert)
           let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alertController.addAction(defaultAction)
           self.present(alertController, animated: true, completion: nil)
        }
    }

    struct NaptanLine {
        var line: String?
        var id: String?
        var direction:String?
    }

    struct tableArray {
        var lineName: String?
        var lineid: String?
        var directionName: String?
        var naptanID: String?
        var stationName: String?
        var documentID:String?
    }
    
    struct TimeDestination {
        var time1: Int?
        var time2: Int?
        var time3: Int?
        var destination1: String?
        var destination2: String?
        var destination3: String?
    }
    
    extension UserDefaults {
        static func contains(_ key: String) -> Bool {
            return UserDefaults.standard.object(forKey: key) != nil
        }
    }
    
    extension UITextField {

        func addPadding() {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
            self.leftView = paddingView
            self.leftViewMode = UITextField.ViewMode.always
        }
        
        func layout(placeholder: String, backgroundcolour: UIColor, bordercolour: UIColor,borderWidth: CGFloat, cornerRadius: CGFloat) {
            self.placeholder = placeholder
            self.backgroundColor = backgroundcolour
            layer.borderColor = bordercolour.cgColor
            layer.borderWidth = borderWidth
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    var vSpinner : UIView?
    extension UIViewController {
        func showSpinner(onView : UIView) {
            let spinnerView = UIView.init(frame: onView.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
            ai.startAnimating()
            ai.center = spinnerView.center
            
            DispatchQueue.main.async {
                spinnerView.addSubview(ai)
                onView.addSubview(spinnerView)
            }
            
            vSpinner = spinnerView
        }
        
        func removeSpinner() {
            DispatchQueue.main.async {
                vSpinner?.removeFromSuperview()
                vSpinner = nil
            }
        }
    }

    extension Array where Element:Equatable {
        func removeDuplicates() -> [Element] {
            var result = [Element]()

            for value in self {
                if result.contains(value) == false {
                    result.append(value)
                }
            }

            return result
        }
    }
