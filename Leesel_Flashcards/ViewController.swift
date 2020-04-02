//
//  ViewController.swift
//  Leesel_Flashcards
//
//  Created by Leesel Fraser on 2/20/20.
//  Copyright © 2020 Leesel Fraser. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    var correctAnswerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20.0 //optional - card have rounded edges
        //card.clipsToBounds = true
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 1.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.9390786917, green: 0.34056547, blue: 0.3704205954, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 1.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.9390786917, green: 0.34056547, blue: 0.3704205954, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 1.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.9390786917, green: 0.34056547, blue: 0.3704205954, alpha: 1)
        
        // Do any additional setup after loading the view.
        backLabel.isHidden = true
        frontLabel.isHidden = false
        readSavedFlashcards()
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the Capital of Brazil?", answer: "Brasilia", isExisting: false, extraAnswerOne: "Sâo Paulo", extraAnswerTwo: "Rio De Janeiro")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
    }

    @IBAction func didTapOptionOne(_ sender: Any) {
        if btnOptionOne == correctAnswerButton {
            flipFlashcard()
        } else {
            btnOptionOne.isEnabled = false
        }
       // backLabel.isHidden = true
        
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        if btnOptionTwo == correctAnswerButton {
            flipFlashcard()
        } else {
            btnOptionTwo.isEnabled = false
        }
//        frontLabel.isHidden = true
//        backLabel.isHidden = false
        //btnOptionTwo.backgroundColor = UIColor(red: 0/255, green: 184/255, blue: 148/255, alpha: 1.0)
        //UIColor(hex: "#00b894")
        //rgb(0,184,148)
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        if btnOptionThree == correctAnswerButton {
            flipFlashcard()
        } else {
            btnOptionThree.isEnabled = false
        }
//        backLabel.isHidden = true
//        frontLabel.isHidden = false
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateLabels()
        updateNextPrevButtons()
        animateCardOutPrev()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
           currentIndex = currentIndex + 1
           //updateLabels()
           updateNextPrevButtons()
           animateCardOutNext()
       }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let message : String!
        if flashcards.count == 1 {
            message = "This is your last flashcard. Are you sure you want to delete this flashcard?"
        }
        else{
            message = "Are you sure you want to delete this flashcard?"
        }
        let alert = UIAlertController(title: "Delete Flashcard", message: message, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteCurrentFlashcard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func deleteCurrentFlashcard(){
        flashcards.remove(at: currentIndex)
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        if currentIndex < 0 {
            
            performSegue(withIdentifier: "CreationSegue", sender: self)
                return
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extra answer one"]!, extraAnswerTwo: dictionary["extra answer two"]!)
            }
            
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer":card.answer, "extra answer one":card.extraAnswerOne, "extra answer two":card.extraAnswerTwo]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("🎉 Flashcards saved to UserDefaults")
    }
    
    func updateLabels() {
        let currentFlashcard =  flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        for (button, answer) in zip(buttons, answers) {
        button?.setTitle(answer, for: .normal)
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
    }
    
//    @IBAction func didTapOnNext(_ sender: Any) {
//        currentIndex = currentIndex + 1
//        updateLabels()
//        updateNextPrevButtons()
//    }
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if (self.frontLabel.isHidden) {
                self.frontLabel.isHidden = false
                self.backLabel.isHidden = true
            } else {
              self.backLabel.isHidden = false
              self.frontLabel.isHidden = true
            }
        })
    }
    
    func animateCardOutNext() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardInNext()
    })
    }
    
    func animateCardInNext() {
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animateCardOutPrev() {
           UIView.animate(withDuration: 0.3, animations: {
               self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
           }, completion: { finished in
               self.updateLabels()
               self.animateCardInPrev()
       })
       }
       
       func animateCardInPrev() {
           card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
           UIView.animate(withDuration: 0.3) {
               self.card.transform = CGAffineTransform.identity
           }
       }
    
    func updateFlashcard(question: String, answer: String, isExisting: Bool, extraAnswerOne: String, extraAnswerTwo: String) {
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
//        frontLabel.text = flashcard.question
//        backLabel.text = flashcard.answer
        
        btnOptionOne.setTitle(extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(extraAnswerTwo, for: .normal)
        
        if isExisting {
            flashcards[currentIndex] = flashcard
        } else {
            flashcards.append(flashcard)
            print("😎 Added new flashcard")
            print("😎 We now have \(flashcards.count) flashcards")
            currentIndex = flashcards.count - 1
            print("😎 Our current index is \(currentIndex)")
        }
    
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        btnOptionOne.isEnabled = true
        btnOptionTwo.isEnabled = true
        btnOptionThree.isEnabled = true
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
           prevButton.isEnabled = false
        } else {
           prevButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
        
        
    }
    
}

//code below is to convert hex to UIColor
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

