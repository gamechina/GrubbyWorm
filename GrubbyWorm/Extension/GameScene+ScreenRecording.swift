//
//  GameScene+ScreenRecording.swift
//  GrubbyWorm
//
//  Created by Wayne on 15/10/9.
//  Copyright © 2015年 GAME-CHINA.ORG. All rights reserved.
//

import ReplayKit

extension GameScene: RPPreviewViewControllerDelegate, RPScreenRecorderDelegate {
    
    // MARK: Computed Properties
    
    var screenRecordingToggleEnabled: Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(Constant.user_data_key_auto_recording)
    }
    
    // MARK: Start/Stop Screen Recording
    
    func startScreenRecording() {
        // Do nothing if screen recording hasn't been enabled.
        guard screenRecordingToggleEnabled else { return }
        
        let sharedRecorder = RPScreenRecorder.sharedRecorder()
        
        // Register as the recorder's delegate to handle errors.
        sharedRecorder.delegate = self
        
        sharedRecorder.startRecordingWithMicrophoneEnabled(true) { error in
            if let error = error {
                self.showScreenRecordingAlert(error.localizedDescription)
            }
            
            print("record started")
        }
    }
    
    func stopScreenRecordingWithHandler(handler:(() -> Void)) {
        let sharedRecorder = RPScreenRecorder.sharedRecorder()
        
        sharedRecorder.stopRecordingWithHandler { (previewViewController: RPPreviewViewController?, error: NSError?) in
            if let error = error {
                // If an error has occurred, display an alert to the user.
                self.showScreenRecordingAlert(error.localizedDescription)
                return
            }
            
            if let previewViewController = previewViewController {
                // Set delegate to handle view controller dismissal.
                previewViewController.previewControllerDelegate = self
                
                /*
                Keep a reference to the `previewViewController` to
                present when the user presses on preview button.
                */
                self.previewViewController = previewViewController
            }
            
            handler()
        }
    }
    
    func showScreenRecordingAlert(message: String) {
        // Pause the scene and un-pause after the alert returns.
        paused = true
        
        // Show an alert notifying the user that there was an issue with starting or stopping the recorder.
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in
            self.paused = false
        }
        alertController.addAction(alertAction)
        
        view?.window?.rootViewController?.presentViewController(alertController, animated: false, completion: nil)
    }
    
    func discardRecording() {
        // When we no longer need the `previewViewController`, tell ReplayKit to discard the recording and nil out our reference
        RPScreenRecorder.sharedRecorder().discardRecordingWithHandler {
            self.previewViewController = nil
        }
    }
    
    // MARK: RPScreenRecorderDelegate
    
    func screenRecorder(screenRecorder: RPScreenRecorder, didStopRecordingWithError error: NSError, previewViewController: RPPreviewViewController?) {
        // Display the error the user to alert them that the recording failed.
        showScreenRecordingAlert(error.localizedDescription)
        
        /*
        Hold onto a reference of the `previewViewController` if not nil. The
        `previewViewController` will be nil when:
        
        - There is an error writing the movie file (disk space, avfoundation).
        - startRecording failed due to AirPlay/TVOut session is in progress.
        - startRecording failed because the device does not support it (lower than A7)
        */
        if previewViewController != nil {
            self.previewViewController = previewViewController
        }
    }
    
    // MARK: RPPreviewViewControllerDelegate
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        previewViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
