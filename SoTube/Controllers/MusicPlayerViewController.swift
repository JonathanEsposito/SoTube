//
//  MusicPlayerViewController.swift
//  SoTube
//
//  Created by .jsber on 12/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit
import CoreImage

class MusicPlayerViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var musicPlayerToolbar: UIToolbar!
    @IBOutlet weak var musicProgressSlider: UISlider!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MusicPlayer")
        
        //
        configureMusicProgresSlider()
        
        // set toolbar background transparent
        musicPlayerToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)

        // Set controller backgroundColor
        let color = averageColor(ofImage: coverImageView.image!)
        controllersView.backgroundColor = UIColor(patternImage: color).withAlphaComponent(0.5)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private Methods
    private func configureMusicProgresSlider() {
        musicProgressSlider.setThumbImage(UIImage(named: "slider"), for: .normal)
    }
    
    private func averageColor(ofImage originalimage: UIImage) -> UIImage {
        
        let context = CIContext(options: nil)
        let convertImage = CIImage(image: originalimage)
        
        let filter = CIFilter(name: "CIAreaAverage")
        filter?.setValue(convertImage , forKey: kCIInputImageKey)
        
        let processImage = filter?.outputImage
        
        let finalImage = context.createCGImage(processImage!, from: processImage!.extent)
        
        let newImage = UIImage(cgImage: finalImage!)
        
        return newImage
    }
    
    private func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return bounds
    }

}
