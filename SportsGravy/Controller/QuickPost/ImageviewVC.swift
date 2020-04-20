//
//  ImageviewVC.swift
//  SportsGravy
//
//  Created by CSS on 14/04/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit


class ImageviewVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var image_scroll: UIScrollView!
    @IBOutlet weak var noimage: UILabel!
    var ImageCount: NSMutableArray!
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 50, y: 300, width: 200, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageControl()

        self.image_scroll.delegate = self
        for i in 0..<ImageCount.count {
            let imageView = UIImageView()
            let x = self.image_scroll.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: image_scroll.frame.origin.y - 80, width: self.image_scroll.frame.width, height: self.image_scroll.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = ImageCount[i] as? UIImage
            self.image_scroll.isPagingEnabled = true

            image_scroll.contentSize.width = image_scroll.frame.size.width * CGFloat(i + 1)
            image_scroll.addSubview(imageView)

        }
    }
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = ImageCount.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.image_scroll.addSubview(pageControl)
        noimage.text = "\(self.pageControl.currentPage + 1)" + "/" + "\(ImageCount.count)"


    }
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * image_scroll.frame.size.width
        image_scroll.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    @IBAction func imageBackbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        noimage.text = "\(Int(pageNumber) + 1)" + "/" + "\(ImageCount.count)"
        pageControl.currentPage = Int(pageNumber)
    }
}
