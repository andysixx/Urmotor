//
//  ViewControllerFirst.swift
//  Umotor
//
//  Created by SIX on 2016/10/11.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AVKit
import AVFoundation
import FirebaseAuth


class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var Umotor_inc: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var videoVIew: UIView!
    @IBOutlet weak var nav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nav.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupView() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "MotorGP", ofType: "mov")!)
        let player = AVPlayer(url: path as URL)
        let newlayer = AVPlayerLayer(player: player)
        newlayer.frame = videoVIew.frame
        videoVIew.layer.addSublayer(newlayer)
        newlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        player.play()
        player.isMuted = true
        
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerItemDidReachEnd(notifiction:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
        
        videoVIew.bringSubview(toFront: loginButton)
        videoVIew.bringSubview(toFront: registerButton)
        videoVIew.bringSubview(toFront: Umotor_inc)
        
    
    }
    func playerItemDidReachEnd(notifiction: NSNotification)
    {
//        let player : AVPlayerItem = notifiction.object as! AVPlayerItem
//        
        //player.seek(to: kCMTimeZero)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                if FIRAuth.auth()?.currentUser != nil{
        
                    let revealViewControl = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = revealViewControl
        
                }
            else{
                // No user is signed in.
                self.setupView()
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
