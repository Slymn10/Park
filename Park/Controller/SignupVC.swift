//
//  SignupVC.swift
//  Park
//
//  Created by Süleyman Koçak on 18.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit
import iOSDropDown

class SignupVC: UIViewController {
   private let dropDown = DropDown()  // set frame
   private var viewWidth: CGFloat!
   private var viewHeight: CGFloat!
   private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "PARK"
      label.font = UIFont(name: "Avenir-Light", size: 36)
      label.textColor = UIColor(white: 1, alpha: 0.8)
      return label
   }()
   private lazy var fullnameContainerView: UIView = {
      let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x-1").withTintColor(.label), textField: fullnameTextField)
      view.heightAnchor.constraint(equalToConstant: 50).isActive = true
      return view
   }()
   private let fullnameTextField: UITextField = {
      return UITextField().textField(withPlaceholder: "Ad Soyad")
   }()
   private let signupButton: AuthButton = {
      let button = AuthButton(type: .system)
      button.setTitle("Go Inside", for: .normal)
      button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
      return button
   }()
   override func viewDidLoad() {
      super.viewDidLoad()
      navigationController?.navigationBar.isHidden = true
      configureUI()
      viewWidth = view.frame.width
      viewHeight = view.frame.height
      dropDown.arrowColor = .systemPink
      dropDown.textColor = .label
      dropDown.rowBackgroundColor = .systemBackground
      dropDown.selectedRowColor = .systemPink
      dropDown.attributedPlaceholder = NSAttributedString(string: "  Arabanı Seç", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
      let leftview = UIView()
      leftview.frame.size.width = 15
      dropDown.leftView = leftview
      dropDown.adjustsFontSizeToFitWidth = true
      // The list of array to display. Can be changed dynamically
      dropDown.optionArray = ["  Volkswagen golf", "  Mercedes c180", "  Audi a4"]
      // Its Id Values and its optional
      dropDown.optionIds = [1, 23, 54, 22]
      // Image Array its optional
      dropDown.didSelect { (selectedText, index, id) in
         self.dropDown.text = "\(selectedText)"
      }
   }

   //MARK: - Helpers
   func configureUI() {
      view.addSubview(titleLabel)
      titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
      titleLabel.centerX(inView: view)
      view.backgroundColor = .systemBackground

      view.addSubview(titleLabel)
      titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
      titleLabel.centerX(inView: view)

      let stack = UIStackView(arrangedSubviews: [fullnameContainerView, dropDown, signupButton])
      stack.distribution = .fillEqually
      stack.axis = .vertical
      stack.spacing = 24
      stack.setCustomSpacing(110, after: dropDown)

      view.addSubview(stack)
      stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
   }

   //MARK: - Selectors
   @objc func handleSignup() {
      navigationController?.pushViewController(HomeVC(), animated: true)
   }



}
