//
//  DisruptionsCell.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 06/03/2021.
//

import UIKit

class DisruptionsCell: UICollectionViewCell {
    
    lazy var TubeLogoImage: UIImageView = {
      let imageview = UIImageView()
        imageview.image = UIImage(named: "underground")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var LineName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 15, text: "Unavailable")
        text.numberOfLines = 2
        return text
    }()
    
    lazy var LineStatus: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 15, text: "Unavailable")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var Reason: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 10, text: "Unavailable")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }
    
    func setupView() {
        addSubview(TubeLogoImage)
        addSubview(LineName)
        addSubview(LineStatus)
        //addSubview(Reason)
        
        let leftPadding = CGFloat(10)
        
        TubeLogoImage.anchor(top: topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: leftPadding, right: nil, paddingRight: 0, width: 50, height: 50)
        
        LineName.anchor(top: TubeLogoImage.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: leftPadding, right: rightAnchor, paddingRight: 3, width: 0, height: 0)
        
        LineStatus.anchor(top: LineName.bottomAnchor, paddingTop: 3, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: leftPadding, right: nil, paddingRight: 0, width: 0, height: 0)
        
        //Reason.anchor(top: LineStatus.bottomAnchor, paddingTop: 3, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: leftPadding, right: nil, paddingRight: 0, width: 0, height: 0)
        
        //LineStatus.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
