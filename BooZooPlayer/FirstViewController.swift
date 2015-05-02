//
//  FirstViewController.swift
//  BooZooPlayer
//
//  Created by Jin, Ke on 5/1/15.
//  Copyright (c) 2015 BooZoo. All rights reserved.
//

import UIKit
import MediaPlayer


class FirstViewController: UIViewController {
    var moviePlayer: MPMoviePlayerController?
    
    @IBOutlet weak var Left1Play: UIButton!
    @IBOutlet weak var Left2Play: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Left1PlayStart(sender: UIButton) {
        println("start to play left1 !")
        startPlayingVideo("L1", extention: "mp4");
    }
    
    @IBAction func Left2PlayStart(sender: UIButton) {
        println("start to play left2 !")
        startPlayingVideo("L2", extention: "mp4");
    }
    
    func videoHasFinishedPlaying(notification: NSNotification){
        
        println("Video finished playing")
        
        /* Find out what the reason was for the player to stop */
        let reason =
        notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
            as NSNumber?
        
        if let theReason = reason{
            
            let reasonValue = MPMovieFinishReason(rawValue: theReason.integerValue)
            
            switch reasonValue!{
            case .PlaybackEnded:
                /* The movie ended normally */
                println("Playback Ended")
            case .PlaybackError:
                /* An error happened and the movie ended */
                println("Error happened")
            case .UserExited:
                /* The user exited the player */
                println("User exited")
            default:
                println("Another event happened")
            }
            
            println("Finish Reason = \(theReason)")
            stopPlayingVideo()
        }
        
    }
    
    func stopPlayingVideo() {
        
        if let player = moviePlayer{
            NSNotificationCenter.defaultCenter().removeObserver(self)
            player.stop()
            player.view.removeFromSuperview()
        }
        
    }
    
    func startPlayingVideo(name: NSString, extention: NSString){
        
        /* First let's construct the URL of the file in our application bundle
        that needs to get played by the movie player */
        let mainBundle = NSBundle.mainBundle()
        
        let url = mainBundle.URLForResource(name, withExtension: extention)
        
        /* If we have already created a movie player before,
        let's try to stop it */
        if let player = moviePlayer{
            stopPlayingVideo()
        }
        
        /* Now create a new movie player using the URL */
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        if let player = moviePlayer{
            
            /* Listen for the notification that the movie player sends us
            whenever it finishes playing */
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "videoHasFinishedPlaying:",
                name: MPMoviePlayerPlaybackDidFinishNotification,
                object: nil)
            
            println("Successfully instantiated the movie player")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .AspectFit
            
            view.addSubview(player.view)
            
            player.setFullscreen(true, animated: false)
            
            /* Let's start playing the video in full screen mode */
            player.play()
            
        } else {
            println("Failed to instantiate the movie player")
        }
        
    }

}

