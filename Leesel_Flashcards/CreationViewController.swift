//
//  CreationViewController.swift
//  Leesel_Flashcards
//
//  Created by Leesel Fraser on 3/17/20.
//  Copyright © 2020 Leesel Fraser. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController:ViewController!

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var extraAnswerOne: UITextField!
    @IBOutlet weak var extraAnswerTwo: UITextField!
    @IBOutlet weak var extraAnswerThree: UITextField!
    
    
    
    var initialQuestion: String?
    var initialAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
   @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        
        let alert = UIAlertController(title: "Missing Text", message: "Please enter both a question and an answer or hit the Cancel button on the top left", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
    
        var isExisting = false
        if initialQuestion != nil{
            isExisting = true
        }
        
        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty{
           present(alert, animated: true)
        } else {
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, isExisting: isExisting, extraAnswerOne: extraAnswerOne.text!, extraAnswerTwo: extraAnswerTwo.text!, extraAnswerThree: extraAnswerThree.text!)
            dismiss(animated: true)
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
