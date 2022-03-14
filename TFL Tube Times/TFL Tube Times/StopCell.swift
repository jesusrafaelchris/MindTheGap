//
//  StopCell.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 06/03/2021.
//

import UIKit

class StopCell: SwipeableCollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        LineText.text = ""
        StationDirectionText.text = ""
    }
    
    lazy var colourLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var LineText: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 15, text: "Jubilee Line")
        return label
    }()
    
    lazy var StationDirectionText: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 10, text: "Southwark Westbound")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var TimeText1: UILabel = {
        let label = UILabel()
        label.layout(colour: .blue, size: 15, text: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var TimeText2: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 10, text: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var TimeText3: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 10, text: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let deleteImageView: UIImageView = {
        let image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        visibleContainerView.backgroundColor = .white
        visibleContainerView.addSubview(colourLine)
        visibleContainerView.addSubview(LineText)
        visibleContainerView.addSubview(StationDirectionText)
        visibleContainerView.addSubview(TimeText2)
        visibleContainerView.addSubview(TimeText1)
        visibleContainerView.addSubview(TimeText3)
        
        hiddenContainerView.backgroundColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
        
        hiddenContainerView.addSubview(deleteImageView)
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.centerXAnchor.constraint(equalTo: hiddenContainerView.centerXAnchor).isActive = true
        deleteImageView.centerYAnchor.constraint(equalTo: hiddenContainerView.centerYAnchor).isActive = true
        deleteImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        deleteImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        colourLine.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 65, height: 15)
        colourLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        LineText.anchor(top: nil, paddingTop: 0, bottom: centerYAnchor, paddingBottom: 0, left: colourLine.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        StationDirectionText.anchor(top: LineText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: LineText.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        StationDirectionText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        
        TimeText1.anchor(top: nil, paddingTop: 0, bottom: TimeText2.topAnchor, paddingBottom: 3, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 20, width: 0, height: 0)
        
        TimeText2.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 20, width: 0, height: 0)
        TimeText2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        TimeText3.anchor(top: TimeText2.bottomAnchor, paddingTop: 3, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: rightAnchor, paddingRight: 20, width: 0, height: 0)
    }
    
}
