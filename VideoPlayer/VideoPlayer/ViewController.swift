//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Den Jo on 26/08/2019.
//  Copyright © 2019 nilotic. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Value
    // MARK: Private
    private weak var videoPlayerViewController: VideoPlayerViewController? = nil
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }



}




// MARK: - Segue
extension ViewController: SegueHandlerType {
    
    // MARK: Enum
    enum SegueIdentifier: String {
        case youTubePlayer = "VideoPlayerSegue"
    }
    
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segueIdentifier(with: segue) else {
            log(.error, "Failed to get a segueIdentifier.")
            return
        }
        
        switch segueIdentifier {
        case .youTubePlayer:
            guard let viewController = segue.destination as? VideoPlayerViewController else {
                log(.error, "Failed to get a VideoPlayerViewController.")
                return
            }
            
            videoPlayerViewController = viewController
//            viewController.delegate = self
        }
    }
}
