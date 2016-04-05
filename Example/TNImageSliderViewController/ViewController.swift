//
//  ViewController.swift
//  TNImageSliderViewController
//
//  Created by Frederik Jacques on 06/22/2015.
//  Copyright (c) 06/22/2015 Frederik Jacques. All rights reserved.
//

import UIKit
import TNImageSliderViewController

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    var imageSliderVC:TNImageSliderViewController!
    
    // MARK: - Initializers methods
    
    // MARK: - Lifecycle methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("[ViewController] Prepare for segue")
        
        if( segue.identifier == "seg_imageSlider" ){
            
            imageSliderVC = segue.destinationViewController as! TNImageSliderViewController
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("[ViewController] View did load")
        
        let image1 = UIImage(named: "image-1")
        let image2 = UIImage(named: "image-2")
        let image3 = UIImage(named: "image-3")
        
        if let image1 = image1, let image2 = image2, let image3 = image3 {

            // 1. Set the image array with UIImage objects
            imageSliderVC.images = [image1, image2, image3]
            
            // 2. If you want, you can set some options
            var options = TNImageSliderViewOptions()
            options.pageControlHidden = false
            options.scrollDirection = .Horizontal
            options.pageControlCurrentIndicatorTintColor = UIColor.yellowColor()
            options.autoSlideIntervalInSeconds = 2
            options.shouldStartFromBeginning = true
            options.imageContentMode = .ScaleAspectFit
            
            imageSliderVC.options = options
            
        }else {
    
            print("[ViewController] Could not find one of the images in the image catalog")
            
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Private methods
    
    // MARK: - Public methods
    
    // MARK: - Getter & setter methods
    
    // MARK: - IBActions
    
    // MARK: - Target-Action methods
    
    // MARK: - Notification handler methods
    
    // MARK: - Datasource methods
    
    // MARK: - Delegate methods
    
}