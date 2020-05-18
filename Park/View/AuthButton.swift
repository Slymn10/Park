//
//  AuthButton.swift
//  Park
//
//  Created by Süleyman Koçak on 18.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        setTitleColor(UIColor(white: 1, alpha: 0.8), for: .normal)
        backgroundColor = .systemPink
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
