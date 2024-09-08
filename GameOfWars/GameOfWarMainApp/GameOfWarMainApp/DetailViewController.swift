//
//  DetailViewController.swift
//  GameOfWarMainApp
//
//  Created by Amit Palo on 07/09/24.
//

import UIKit
import GameOfWarKit
import SVProgressHUD

final class DetailViewController: UIViewController {
    
    private lazy var gameManager = DeckOfCardsManager.shared
    
    class func instanceFromStoryboard() -> DetailViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: self)) as! DetailViewController
        return viewController
    }
    
    @IBOutlet private weak var battleCountLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetViews()
    }
    
    private func resetViews() {
        self.battleCountLabel.text = ""
        self.errorLabel.text = ""
        playButton.backgroundColor = UIColor.black
        playButton.isEnabled = true
    }
    
    @IBAction func playRoundAction(_ sender: Any) {
        gameManager.playRound { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let roundResult):
                    self.battleCountLabel.text = "Player \(roundResult.winnerIndex + 1) wins the round!"
                    self.errorLabel.text = ""
                case .failure(let error):
                    if case let GameError.gameOver(winnerIndex) = error {
                        self.battleCountLabel.text = "Player \(winnerIndex + 1) wins the game!"
                        self.playButton.isEnabled = false
                        self.playButton.backgroundColor = UIColor.lightGray
                    } else {
                        self.battleCountLabel.text = ""
                        self.errorLabel.text = "Error playing round: \(error)"
                    }
                }
            }
        }
    }
    
    @IBAction func restGameAction(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Resetting. Please wait...")
        resetViews()
        gameManager.resetGame { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success():
                    print("Game setup complete")
                    self.errorLabel.text = ""
                case .failure(let error):
                    self.errorLabel.text = "Error setting up game: \(error)"
                }
            }
        }
    }
}

