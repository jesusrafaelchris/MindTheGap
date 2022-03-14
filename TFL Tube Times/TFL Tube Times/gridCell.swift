//
//  gridCell.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 08/03/2021.
//

import UIKit

class gridCell: UICollectionViewCell {
    
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
    var purpleThemeColour = UIColor(red: 0.38, green: 0.11, blue: 0.81, alpha: 1.00)
    
    override var isSelected: Bool {
       didSet{
           if self.isSelected {
               UIView.animate(withDuration: 0.3) { // for animation effect
                let index = self.setBG(name: self.lineName.text!)
                let colour = self.lines[index].colour
                self.backgroundColor = .white
                self.lineName.textColor = colour
                self.layer.borderWidth = 2
                self.layer.borderColor = colour.cgColor
               }
           }
           else {
               UIView.animate(withDuration: 0.3) { // for animation effect
                let index = self.setBG(name: self.lineName.text!)
                let colour = self.lines[index].colour
                self.backgroundColor = colour
                self.lineName.textColor = .white
                self.layer.borderWidth = 0
                self.layer.borderColor = nil
                
               }
           }
       }
   }
    
    func setBG(name: String) -> Int {
        switch name {
        case "MET":
        return 0
        case "CIR":
        return 1
        case "DIS":
        return 2
        case "OVR":
        return 3
        case "HMC":
        return 4
        case "BAK":
        return 5
        case "CEN":
        return 6
        case "WAT":
        return 7
        case "VIC":
        return 8
        case "PIC":
        return 9
        case "NOR":
        return 10
        case "JUB":
        return 11
        default:
            return 0
        }
    }
    
    lazy var lineName: UILabel = {
        let label = UILabel()
        label.layout(colour: .white, size: 18, text: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineName)
        lineName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lineName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
