//
//  Video_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/26.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AVKit
import AVFoundation

class Video_ViewController: UIViewController {
    
    @IBOutlet var videoVIew: UIView!
    
//    @IBOutlet var videoVIew: UIView!
//    @IBOutlet weak var nav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
//        nav.hidesBackButton = true
//                setupView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupView() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "umotor", ofType: "mov")!)
        let player = AVPlayer(url: path as URL)
        let newlayer = AVPlayerLayer(player: player)
        newlayer.frame = videoVIew.frame
        videoVIew.layer.addSublayer(newlayer)
        newlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        player.play()
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self, selector: "playerItemDidReachEnd", name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
        
    }
    func playerItemDidReachEnd(notifiction: NSNotification)
    {
        let player : AVPlayerItem = notifiction.object as! AVPlayerItem
        player.seek(to: kCMTimeZero)
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
