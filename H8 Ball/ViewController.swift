//
//  ViewController.swift
//  H8 Ball
//
//  Created by Fernandez, Eduardo (CONT) on 4/9/16.
//  Copyright © 2016 Lunch Heroes. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import CoreMotion

class ViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        //Store an Audio/Video capture session.
        let captureSession = AVCaptureSession()
        
        //Lets me know if there are any capture devices in general.
        var captureDevice : AVCaptureDevice?
        
        //Store information for devices we can access. (Microphone/Camera)
        var devices = AVCaptureDevice.devices()
        
        //Set camera quality settings to Frame
        captureSession.sessionPreset = AVCaptureSessionPresetiFrame1280x720
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        
        func showVideoFeed() {
            let err : NSError? = nil
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            } catch _ {
                print("error: \(err?.localizedDescription)")
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            let screen = UIScreen.mainScreen().bounds
            
            self.view.layer.addSublayer(previewLayer)
            previewLayer?.frame = screen
            captureSession.startRunning()
        }
        
        if captureDevice != nil {
            showVideoFeed()
        }
        
        var eightBallViewObject :UIImageView
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let eightBallSize = screenSize.width * 1.65;
        
        let eightBallXPos = screenSize.width - (screenSize.width * 1.328);
        
        let eightBallYPos = screenSize.height - (screenSize.height / 1.05);
        
        eightBallViewObject = UIImageView(frame:CGRectMake(eightBallXPos, eightBallYPos, eightBallSize, eightBallSize))
        
        eightBallViewObject.image = UIImage(named:"8Ball")
        
        func add8Ball () {
            
            self.view.addSubview(eightBallViewObject)
            
        }
        
        add8Ball ()
        
       var triangleImageViewObject :UIImageView
        
        let triangleSize = screenSize.width * 0.65;
        
        let triangleXPos = screenSize.width - (triangleSize * 1.32);
        
        let triangleYPos = screenSize.height - (screenSize.height / 1.4765) ;
        
        triangleImageViewObject = UIImageView(frame:CGRectMake(triangleXPos, triangleYPos, triangleSize * 1.1, triangleSize))
        
        triangleImageViewObject.image = UIImage(named:"triangle")
        
        triangleImageViewObject.tag = 1;
        
        func addTriangle () {
            
            self.view.addSubview(triangleImageViewObject)
            
        }
        
        addTriangle()
        
        func spinTriangle () {
            
            motionManager.deviceMotionUpdateInterval = 0.01
            
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
                
                let rotation = atan2(motion!.gravity.x, motion!.gravity.y) - M_PI

                
                for view in self.view.subviews {
                    
                    let viewTag = view.tag
                    
                    if viewTag == 1 {
                        view.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                    }
                    
                }
                
            }
            
        }
        
        spinTriangle()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
    
        UIView.animateWithDuration(0.4, animations: {
            for view in self.view.subviews {
                
                let viewTag = view.tag
                
                if viewTag == 1 {
                    view.alpha = 0;
                    view.bounds.size.width = 0
                    view.bounds.size.height = 0
                }
                
            }
        })
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {

        UIView.animateWithDuration(0.4, animations: {
            for view in self.view.subviews {
                
                let viewTag = view.tag
                
                if viewTag == 1 {
                    view.alpha = 1;
                    view.bounds.size.width = UIScreen.mainScreen().bounds.size.width * 0.65 * 1.1
                    view.bounds.size.height = UIScreen.mainScreen().bounds.size.width * 0.65
                }
                
            }
        })
        
    }

}

