//
//  TNImageSliderViewController.swift
//
//  Created by Frederik Jacques on 20/06/15.
//  Copyright (c) 2015 Frederik Jacques. All rights reserved.
//

import UIKit

public protocol TNImageSliderViewControllerDelegate:class {
    
    func imageSlider( _ imageSlider:TNImageSliderViewController, didScrollToPage pageNumber:Int )
    
}

public struct TNImageSliderViewOptions {
    
    public var scrollDirection:UICollectionViewScrollDirection
    public var backgroundColor:UIColor
    public var pageControlHidden:Bool
    public var pageControlCurrentIndicatorTintColor:UIColor
    public var autoSlideIntervalInSeconds:TimeInterval
    public var shouldStartFromBeginning:Bool
    public var imageContentMode:UIViewContentMode
    
    public init(){
        
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.backgroundColor = UIColor.black
        self.pageControlHidden = false
        self.pageControlCurrentIndicatorTintColor = UIColor.white
        self.autoSlideIntervalInSeconds = 0
        self.shouldStartFromBeginning = false
        self.imageContentMode = .scaleToFill
        
    }
    
    public init( scrollDirection:UICollectionViewScrollDirection, backgroundColor:UIColor, pageControlHidden:Bool, pageControlCurrentIndicatorTintColor:UIColor, imageContentMode:UIViewContentMode){
        
        self.scrollDirection = scrollDirection
        self.backgroundColor = backgroundColor
        self.pageControlHidden = pageControlHidden
        self.pageControlCurrentIndicatorTintColor = pageControlCurrentIndicatorTintColor
        self.autoSlideIntervalInSeconds = 0
        self.shouldStartFromBeginning = false
        self.imageContentMode = imageContentMode
        
    }
}

open class TNImageSliderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - IBOutlets
    
    // MARK: - Properties
    open weak var delegate:TNImageSliderViewControllerDelegate?
    
    var collectionView:UICollectionView!
    var collectionViewLayout:UICollectionViewFlowLayout {
    
        get {
            
            return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
        }
        
    }
    
    var pageControl:UIPageControl!
    
    open var options:TNImageSliderViewOptions! {
    
        didSet {
            
            if let collectionView = collectionView, let pageControl = pageControl {
            
                collectionViewLayout.scrollDirection = options.scrollDirection
                
                collectionView.collectionViewLayout = collectionViewLayout
                collectionView.backgroundColor = options.backgroundColor
                pageControl.isHidden = options.pageControlHidden
                pageControl.currentPageIndicatorTintColor = options.pageControlCurrentIndicatorTintColor
                
                setupAutoSliderIfNeeded()
                
            }
            
        }
        
    }
    
    open var images:[UIImage]! {
        
        didSet {
            
            collectionView.reloadData()
            
            pageControl.numberOfPages = images.count
        }
        
    }
    
    var currentPage:Int {
        
        get {
            
            switch( collectionViewLayout.scrollDirection ) {
                
                case .horizontal:
                    return Int((collectionView.contentOffset.x / collectionView.contentSize.width) * CGFloat(images.count))
                
                case .vertical:
                    return Int((collectionView.contentOffset.y / collectionView.contentSize.height) * CGFloat(images.count))
                
            }
            
        }
        
    }
    
    // MARK: - Initializers methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    // MARK: - Lifecycle methods
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        options = TNImageSliderViewOptions()
        
        setupCollectionView()
        setupPageControl()
        
    }
    
    open override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Calculate current page to update the content offset to the correct position when the orientation changes
        // I take a copy of the currentPage variable, as it will be incorrectly calculated once we are in the animateAlongsideTransition block
        // Because the contentSize will already be changed to reflect the new orientation
        let theCurrentPage = Int(currentPage)
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            
            let contentOffSet:CGPoint
            
            switch( self.collectionViewLayout.scrollDirection ) {
                
            case .horizontal:
                
                contentOffSet = CGPoint(x: Int(self.collectionView.bounds.size.width) * theCurrentPage, y: 0)
                
            case .vertical:
                
                contentOffSet = CGPoint(x: 0, y: Int(self.collectionView.bounds.size.height) * self.currentPage)
                
            }
            
            self.collectionView.contentOffset = contentOffSet
            
            }, completion: { (context) -> Void in
                
        })
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    // MARK: - Private methods
    fileprivate func setupCollectionView(){
    
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = options.scrollDirection
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        
        let bundle = Bundle(for: TNImageSliderViewController.classForCoder())
        let nib = UINib(nibName: "TNImageSliderCollectionViewCell", bundle: bundle)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "TNImageCell")
        collectionView.backgroundColor = options.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView":collectionView])
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
        
    }
    
    fileprivate func setupPageControl() {
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = options.pageControlCurrentIndicatorTintColor
    
        pageControl.isHidden = options.pageControlHidden
        view.addSubview(pageControl)
        
        let centerXConstraint = NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: -5)
        
        view.addConstraints([centerXConstraint, bottomConstraint])
        
    }
    
    fileprivate func setupAutoSliderIfNeeded() {
        
        if options.autoSlideIntervalInSeconds > 0 {
            Timer.scheduledTimer(timeInterval: options.autoSlideIntervalInSeconds, target: self, selector: #selector(TNImageSliderViewController.timerDidFire(_:)), userInfo: nil, repeats: true)
        }
        
    }
    
    func timerDidFire(_ timer: Timer) {
        
        let theNextPage = currentPage + 1
        var contentOffSet = CGPoint.zero
        
        if theNextPage < images.count {
            switch( self.collectionViewLayout.scrollDirection ) {
                
            case .horizontal:
                
                contentOffSet = CGPoint(x: Int(self.collectionView.bounds.size.width) * theNextPage, y: 0)
                
            case .vertical:
                
                contentOffSet = CGPoint(x: 0, y: Int(self.collectionView.bounds.size.height) * theNextPage)
                
            }
        }
        
        if options.shouldStartFromBeginning || contentOffSet != CGPoint.zero {
            collectionView.setContentOffset(contentOffSet, animated: true)
        } else {
            timer.invalidate()
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Getter & setter methods
    
    // MARK: - IBActions
    
    // MARK: - Target-Action methods
    
    // MARK: - Notification handler methods
    
    // MARK: - Datasource methods
    // MARK: UICollectionViewDataSource methods
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if let images = images {
        
            return images.count
            
        }
        
        return 0
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TNImageCell", for: indexPath) as! TNImageSliderCollectionViewCell
        
        cell.imageView.image = images[(indexPath as NSIndexPath).row]
        cell.imageView.contentMode = options.imageContentMode
        
        return cell
        
    }
    
    open func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
        
    }
    
    // MARK: - Delegate methods
    // MARK: UICollectionViewDelegate methods
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // If the scroll animation ended, update the page control to reflect the current page we are on
        pageControl.currentPage = currentPage
        
        self.delegate?.imageSlider(self, didScrollToPage: currentPage)
        
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        // Called when manually setting contentOffset
        scrollViewDidEndDecelerating(scrollView)
        
    }
}
