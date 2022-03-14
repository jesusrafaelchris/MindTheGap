//
//  StationCell.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 08/03/2021.
//

import UIKit

class StationCell: UICollectionViewCell {
    
    lazy var stationName: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 12, text: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stationName)
        stationName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stationName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
