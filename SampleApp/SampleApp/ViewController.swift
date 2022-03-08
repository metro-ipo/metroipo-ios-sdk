//
//  ViewController.swift
//  SampleApp
//
//  Created by Luechen Christopher on 12/15/21.
//

import UIKit
import MetroIpoSdk

class ViewController: UIViewController {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var codeTextField: UITextField!
  var metroSdk: MetroIpo?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    messageLabel.text = "To add your signature, please enter your verification code. To upload your signature, after signing on the next screen, press the NEXT button."
    
    do {
      let config = MetroIpoConfig()
        .setDomain(url: "YOUR-METROIPO-SERVER")
        .build()
      metroSdk = try MetroIpo(configuration: config)
    } catch let error {
      print("Flow not started. Error: \(error)")
    }
  }
  
  @IBAction func onSubmitPress(_ sender: Any) {
    guard let verificationCode = codeTextField.text else {
      return
    }
    do {
      
      var presentationStyle: UIModalPresentationStyle = .fullScreen
      
      if UIDevice.current.userInterfaceIdiom == .pad {
        presentationStyle = .formSheet
      }
      
      guard let sdk = metroSdk else {
        return
      }
      
      try sdk.start(code: verificationCode, origin: self, style: presentationStyle)
      sdk.with(responseHandler: {response in
        switch response {
        case .success(let result):
          self.showAlert(title: "Congratulations", message: result)
        case .failure(let error):
          print("Metro IPO Sdk encounterd an error: \(error.localizedDescription)")
        case .error(let error):
          switch error {
          case .exception(withMessage: let message):
            self.showAlert(title: "Invalid Code", message: message)
          case .USER_CANCELLED:
            print("Applicant cancelled verification.")
          case .API_NOT_AVAILABLE:
            print("Server is offline.")
          case .UPLOAD_INVALID:
            print("Upload data is corrupted.")
          case .CODE_MISSING:
            print("Verification code is missing.")
          default:
            print("An error occured. \(error.localizedDescription)")
          }
        case .start:
          print("Metro IPO Sdk was initialized")
        @unknown default:
          print("Default response")
        }
      })
    } catch let error {
      print("Flow not started. Error: \(error)")
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok",
                                            style: .default,
                                            handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
}

