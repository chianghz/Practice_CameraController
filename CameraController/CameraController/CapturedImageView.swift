//
//  CapturedImageView.swift
//  CustomCamera
//
//  Created by Alex Barbulescu on 2020-05-22.
//  Copyright © 2020 ca.alexs. All rights reserved.
//

import UIKit
import SnapKit

class CapturedImageView : UIView {

    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    var image : UIImage? {
        didSet {
            guard let image = image else { return }
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(){
        backgroundColor = .white
        layer.cornerRadius = 10

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(2)
            $0.bottom.trailing.equalToSuperview().offset(-2)
        }
    }
}
    
