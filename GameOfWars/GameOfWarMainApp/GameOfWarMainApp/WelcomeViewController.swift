//
//  WelcomeViewController.swift
//  GameOfWarMainApp
//
//  Created by Amit Palo on 08/09/24.
//

import UIKit
import SVProgressHUD
import GameOfWarKit

final class WelcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var noOfPlayersTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private lazy var gameManager = DeckOfCardsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func startButtonAction(_ sender: Any) {
        guard let text = noOfPlayersTextField.text,
              !text.isEmpty else {
            errorLabel.text = "Please enter number of players"
            return
        }
        
        guard let numberOfPlayers = Int(text), numberOfPlayers <= 4 else {
            errorLabel.text = "Only 4 players are allowed"
            return
        }
    
        SVProgressHUD.show(withStatus: "Configuring game. Please wait...")
        errorLabel.text = ""
        setupGame(players: numberOfPlayers)
        
    }
    
    private func setupGame(players: Int) {
        gameManager.setupGame(numberOfPlayers: players) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                switch result {
                case .success():
                    print("Game setup complete")
                    self.navigationController?.pushViewController(DetailViewController.instanceFromStoryboard(),
                                                                  animated: true)
                case .failure(let error):
                    self.errorLabel.text = "Error setting up game: \(error)"
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberSet = NSCharacterSet(charactersIn:"123456789").inverted
        let componentSeperatedByCharInSet = string.components(separatedBy: numberSet)
        let numberFiltered = componentSeperatedByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
