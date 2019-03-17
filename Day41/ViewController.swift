//
//  ViewController.swift
//  Day41
//
//  Created by henry on 16/03/2019.
//  Copyright © 2019 HenryNguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var allWords = [String]()
    var allLetters = [String]()
    var threeLetters = [String]()
//    var fourLetters = [String]()
//    var fiveLetters = [String]()
    var scoreLabel : UILabel!
    var answerLabel : UILabel!
    var wrongAnswerLabel : UILabel!
    
    var letterButtons = [UIButton]()
    var startWord = ""
    //
    var usedLetters = [String]()
    var letterArray = [String]()

    var wrongAnswer = 0{
        didSet{
            wrongAnswerLabel.text = "Wrong Answer: \(wrongAnswer)"
        }
    }
    var score = 0
//    {
//        didSet{
//            scoreLabel.text = "Score: \(score)"
//        }
//    }
    //
    var answerWord = ""
    var solution : String!
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
//        scoreLabel = UILabel()
//        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
//        scoreLabel.textAlignment = .right
//        scoreLabel.text = "Score: 0"
//        view.addSubview(scoreLabel)
        
        wrongAnswerLabel = UILabel()
        wrongAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongAnswerLabel.text = "Wrong Answer: 0"
        view.addSubview(wrongAnswerLabel)

        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 32)
        answerLabel.text = "HENRY"
        answerLabel.textAlignment = .center
        view.addSubview(answerLabel)
        
      

        NSLayoutConstraint.activate([

            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.heightAnchor.constraint(equalToConstant: 270),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            answerLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -100),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            wrongAnswerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            wrongAnswerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100)
            

            ])
        
        let width = 70
        let height = 45
        
        for row in 0..<5{
            for col in 0..<6{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: row * width, y: col * height, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
            }
        }
        answerLabel.backgroundColor = .red
//        wrongAnswerLabel.backgroundColor = .blue
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordURL = Bundle.main.url(forResource: "words", withExtension: ".txt"){
            if let startWords = try? String(contentsOf: startWordURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if let startLetterURL = Bundle.main.url(forResource: "letters", withExtension: ".txt"){
            if let startLetters = try? String(contentsOf: startLetterURL){
                allLetters = startLetters.components(separatedBy: "\n")
            }
        }
        //TODO: Load button letters
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(allLetters[i], for: .normal)
            }
        startGame()
        // up to 3 letters
//        for word in allWords{
//            if word.count < 4 && word.count > 2 {
//                threeLetters.append(word)
//            }
//        }
//        threeLetters.shuffle()
//        print(threeLetters[0])
    }
    
    func startGame(action: UIAlertAction! = nil){
        wrongAnswer = 0
        answerWord = ""
        startWord = ""
        usedLetters = []
        print(usedLetters)
        for button in letterButtons{
            button.isHidden = false
        }
        allWords.shuffle()
        print(allWords[0])
        solution = allWords[0]
        //TODO: set text Label
        for _ in solution {
            startWord += "_ "
        }
        answerLabel.text = startWord
        print(startWord)
    }
    
    func checkAnswer(_ sender :UIButton){
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedLetters.append(buttonTitle)
        for letter in solution{
            letterArray.append(String(letter))
        }
        if letterArray.contains(buttonTitle) {
            score += 1
        } else {
            wrongAnswer += 1
        }
    }
    
    func checkLoseGame(){
        if wrongAnswer == 7 {
            let alert = UIAlertController(title: "You lose!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: startGame))
            present(alert, animated: true)
        }
    }
    
    func checkWinGame(){
        print(answerWord)
        if solution?.uppercased() == answerWord{
            let alert = UIAlertController(title: "You Win!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: startGame))
            present(alert, animated: true)
        }
    }
    
    func updateAnswer(){
        answerWord = ""
        guard let solution = solution?.uppercased() else { return }
        for letter in solution{
            let strLetter = String(letter)
            if usedLetters.contains(strLetter){
                answerWord += strLetter
            } else {
                answerWord += "_ "
            }
        }
        print("tap \(usedLetters)")
        answerLabel.text = answerWord
    }

    @objc func letterTapped(_ sender: UIButton ){
        checkAnswer(sender)
        updateAnswer()
        sender.isHidden = true
        checkLoseGame()
        checkWinGame()
    }
}

