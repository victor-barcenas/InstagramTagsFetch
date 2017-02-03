//
//  ZoomedImage.swift
//  InstaTag
//
//  Created by Victor Alfonso Barcenas Monreal on 03/02/17.
//  Copyright © 2017 Victor Barcenas. All rights reserved.
//

import Foundation
import AlamofireImage
import UIKit

class ZoomedImage:UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(size: view.bounds.size)
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / (imageView.bounds.width)
        let heightScale = size.height / (imageView.bounds.height)
        let maxWidthScale = size.width
        let maxHeightScale = size.height
        let minScale = min(widthScale, heightScale)
        let maxScale = min(maxWidthScale,maxHeightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        scrollView.zoomScale = minScale
    }
}

extension ZoomedImage: UIScrollViewDelegate {
    
    private func updateConstraintsForSize(size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let size:CGSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        updateConstraintsForSize(size: size)
    }
}
