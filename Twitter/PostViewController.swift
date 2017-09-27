//
//  PostViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/27/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostViewController: UIViewController {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var usernameLabel: UILabel!
    
    var originalBottomConstraintConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "@\(User.currentUser?.screenName ?? "")"
        originalBottomConstraintConstant = bottomConstraint.constant
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = keyboardHeight + 8
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard bottomConstraint.constant != originalBottomConstraintConstant else { return }
        self.bottomConstraint.constant = self.originalBottomConstraintConstant
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onCancel(sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPostTweet(sender: UIButton?) {
        guard !tweetTextView.text.isEmpty else { return } // FIXME: display more meaningful message to user!
        MBProgressHUD.showAdded(to: view, animated: true)
        TwitterClient.shared.post(tweet: tweetTextView.text) {
            didSuccessfullyPost, potentialError in
            if didSuccessfullyPost {
                self.dismiss(animated: true, completion: nil)
            } else {
                // FIXME: Show nice error somewhere...
                print(potentialError!.localizedDescription)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

}