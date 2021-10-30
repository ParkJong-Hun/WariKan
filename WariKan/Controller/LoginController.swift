//
//  ViewController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/16.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

//OK

class LoginController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ログイン状態チェックして自動ログイン
        if let _ = Auth.auth().currentUser {
            guard let controller:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") else { return }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func googleSignIn() {
        // ファイアベースのClientIDをインスタンス化
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Client IDを利用してグーグルログインConfigurationを生成
        let config = GIDConfiguration(clientID: clientID)

        // グーグルからログインしてCredentialをもらう
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {( user, error) in
            if let error = error {
                print("ログインエラーが起こりました：\(error.localizedDescription)")
                return
            }
            guard let authentication = user?.authentication,let idToken = authentication.idToken
            else { return }
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                if let error = error {
                    print("ログインエラーが起こりました：\(error.localizedDescription)")
                    return
                }
                guard let controller:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main") else { return }
                self.navigationController?.pushViewController(controller, animated: true)
            })
        }
    }
    @IBAction func clickedGoogleLoginButton(_ sender: Any) {
        googleSignIn()
    }
}
