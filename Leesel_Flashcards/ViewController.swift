//
//  ViewController.swift
//  Leesel_Flashcards
//
//  Created by Leesel Fraser on 2/20/20.
//  Copyright © 2020 Leesel Fraser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true;
    }
    
    
}

