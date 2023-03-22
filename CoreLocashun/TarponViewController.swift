//
//  TarponViewController.swift
//  CoreLocashun
//
//  Created by Daniel Zimmerman on 3/22/23.
//

import UIKit

class TarponViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var numberField: UITextView!

    public var completion: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = "Tarpon"
        numberField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }

    @objc func didTapSave() {
        if let text = titleField.text, !text.isEmpty, !numberField.text.isEmpty {
            completion?(text, numberField.text)
        }
    }


}
