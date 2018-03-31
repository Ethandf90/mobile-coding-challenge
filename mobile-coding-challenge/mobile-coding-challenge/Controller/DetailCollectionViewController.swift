//
//  DetailCollectionViewController
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-28.
//  Copyright © 2018 FEI DONG. All rights reserved.
//


import Foundation
import UIKit

@objc public protocol DetailCollectionViewControllerDataSource {
    func numberOfImagesInGallery(gallery:DetailCollectionViewController) -> Int
    func imageInGallery(gallery:DetailCollectionViewController, forIndex:Int) -> UIImage?
}

@objc public protocol DetailCollectionViewControllerDelegate {
    func galleryDidTapToClose(gallery:DetailCollectionViewController)
}

let cellidentifier = "detailcellidentifier"

public class DetailCollectionViewController: UIViewController {

    fileprivate var animateImageTransition = false
    fileprivate var isViewFirstAppearing = true
    fileprivate var deviceInRotation = false

    public weak var dataSource: DetailCollectionViewControllerDataSource?
    public weak var delegate: DetailCollectionViewControllerDelegate?

    public lazy var imageCollectionView: UICollectionView = self.setupCollectionView()

    public var numberOfImages: Int {
        return collectionView(imageCollectionView, numberOfItemsInSection: 0)
    }

    public var backgroundColor: UIColor {
        get {
            return view.backgroundColor!
        }
        set(newBackgroundColor) {
            view.backgroundColor = newBackgroundColor
        }
    }

//    public var currentPageIndicatorTintColor: UIColor {
//        get {
//            return pageControl.currentPageIndicatorTintColor!
//        }
//        set(newCurrentPageIndicatorTintColor) {
//            pageControl.currentPageIndicatorTintColor = newCurrentPageIndicatorTintColor
//        }
//    }

//    public var pageIndicatorTintColor: UIColor {
//        get {
//            return pageControl.pageIndicatorTintColor!
//        }
//        set(newPageIndicatorTintColor) {
//            pageControl.pageIndicatorTintColor = newPageIndicatorTintColor
//        }
//    }

    public var currentPage: Int {
        set(page) {
            if page < numberOfImages {
                scrollToImage(withIndex: page, animated: false)
            } else {
                scrollToImage(withIndex: numberOfImages - 1, animated: false)
            }
//            updatePageControl()
        }
        get {
//            if isRevolvingCarouselEnabled {
//                pageBeforeRotation = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width) - 1
//                return Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width) - 1
//            } else {
                pageBeforeRotation = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
                return Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
//            }
        }
    }

//    public var hidePageControl: Bool = false {
//        didSet {
//            pageControl.isHidden = hidePageControl
//        }
//    }

    #if os(iOS)
    public var hideStatusBar: Bool = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    #endif

    public var isSwipeToDismissEnabled: Bool = true
//    public var isRevolvingCarouselEnabled: Bool = true

    private var pageBeforeRotation: Int = 0
    private var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//    fileprivate var pageControl: UIPageControl = UIPageControl()
//    private var pageControlBottomConstraint: NSLayoutConstraint?
//    private var pageControlCenterXConstraint: NSLayoutConstraint?
    private var needsLayout = true

    // MARK: Public Interface
    public init(delegate: DetailCollectionViewControllerDelegate, dataSource: DetailCollectionViewControllerDataSource) {
        super.init(nibName: nil, bundle: nil)

        self.dataSource = dataSource
        self.delegate = delegate
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func reload(imageIndexes:Int...) {

        if imageIndexes.isEmpty {
            imageCollectionView.reloadData()

        } else {
            let indexPaths: [IndexPath] = imageIndexes.map({IndexPath(item: $0, section: 0)})
            imageCollectionView.reloadItems(at: indexPaths)
        }
    }


    // MARK: Lifecycle methods

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        flowLayout.itemSize = view.bounds.size
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if needsLayout {
            let desiredIndexPath = IndexPath(item: pageBeforeRotation, section: 0)

            if pageBeforeRotation >= 0 {
                scrollToImage(withIndex: pageBeforeRotation, animated: false)
            }

            imageCollectionView.reloadItems(at: [desiredIndexPath])

            for cell in imageCollectionView.visibleCells {
                if let cell = cell as? DetailCollectionViewCell {
//                    cell.configureForNewImage(animated: false)
                }
            }

            needsLayout = false
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

//        pageControl.currentPageIndicatorTintColor = UIColor.white
//        pageControl.pageIndicatorTintColor = UIColor(white: 0.75, alpha: 0.35) //Dim Gray

//        isRevolvingCarouselEnabled = numberOfImages > 1
//        setupPageControl()
        setupGestureRecognizers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        if currentPage < 0 {
            currentPage = 0
        }
        isViewFirstAppearing = false
    }

    #if os(iOS)
    public override var prefersStatusBarHidden: Bool {
        get {
            return hideStatusBar
        }
    }
    #endif


    // MARK: Rotation Handling
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        deviceInRotation = true
        needsLayout = true
    }

    #if os(iOS)
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .allButUpsideDown
        }
    }
    #endif

    #if os(iOS)
    public override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    #endif


    // MARK: - Internal Methods

//    func updatePageControl() {
//        pageControl.currentPage = currentPage
//    }


    // MARK: Gesture Handlers

    private func setupGestureRecognizers() {

        #if os(iOS)
//            let panGesture = PanDirectionGestureRecognizer(direction: PanDirection.vertical, target: self, action: #selector(wasDragged(_:)))
//            imageCollectionView.addGestureRecognizer(panGesture)
//            imageCollectionView.isUserInteractionEnabled = true
        #endif


        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        imageCollectionView.addGestureRecognizer(singleTap)
    }

    #if os(iOS)
//    @objc private func wasDragged(_ gesture: PanDirectionGestureRecognizer) {
//
//        guard let image = gesture.view, isSwipeToDismissEnabled else { return }
//
//        let translation = gesture.translation(in: self.view)
//        image.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY + translation.y)
//
//        let yFromCenter = image.center.y - self.view.bounds.midY
//
//        let alpha = 1 - abs(yFromCenter / self.view.bounds.midY)
//        self.view.backgroundColor = backgroundColor.withAlphaComponent(alpha)
//
//        if gesture.state == UIGestureRecognizerState.ended {
//
//            var swipeDistance: CGFloat = 0
//            let swipeBuffer: CGFloat = 50
//            var animateImageAway = false
//
//            if yFromCenter > -swipeBuffer && yFromCenter < swipeBuffer {
//                // reset everything
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.view.backgroundColor = self.backgroundColor.withAlphaComponent(1.0)
//                    image.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
//                })
//            } else if yFromCenter < -swipeBuffer {
//                swipeDistance = 0
//                animateImageAway = true
//            } else {
//                swipeDistance = self.view.bounds.height
//                animateImageAway = true
//            }
//
//            if animateImageAway {
//                if self.modalPresentationStyle == .custom {
//                    self.delegate?.galleryDidTapToClose(gallery: self)
//                    return
//                }
//
//                UIView.animate(withDuration: 0.35, animations: {
//                    self.view.alpha = 0
//                    image.center = CGPoint(x: self.view.bounds.midX, y: swipeDistance)
//                }, completion: { (complete) in
//                    self.delegate?.galleryDidTapToClose(gallery: self)
//                })
//            }
//
//        }
//    }
    #endif

    @objc public func singleTapAction(recognizer: UITapGestureRecognizer) {
        delegate?.galleryDidTapToClose(gallery: self)
    }


    // MARK: Private Methods

    private func setupCollectionView() -> UICollectionView {
        // Set up flow layout
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        // Set up collection view
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellidentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        #if os(iOS)
            collectionView.isPagingEnabled = true
        #endif

        // Set up collection view constraints
        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .leading,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .leading,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .trailing,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .trailing,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .bottom,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .bottom,
                                                                 multiplier: 1,
                                                                 constant: 0))

        view.addSubview(collectionView)
        view.addConstraints(imageCollectionViewConstraints)

//        collectionView.contentSize = CGSize(width: 1000.0, height: 1.0)

        return collectionView
    }

//    private func setupPageControl() {
//
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//
//        pageControl.numberOfPages = numberOfImages
//        pageControl.currentPage = 0
//
//        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
//        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
//
//        pageControl.alpha = 1
//        pageControl.isHidden = hidePageControl
//
//        view.addSubview(pageControl)
//
//        pageControlCenterXConstraint = NSLayoutConstraint(item: pageControl,
//                                                          attribute: NSLayoutAttribute.centerX,
//                                                          relatedBy: NSLayoutRelation.equal,
//                                                          toItem: view,
//                                                          attribute: NSLayoutAttribute.centerX,
//                                                          multiplier: 1.0,
//                                                          constant: 0)
//
//        pageControlBottomConstraint = NSLayoutConstraint(item: view,
//                                                         attribute: NSLayoutAttribute.bottom,
//                                                         relatedBy: NSLayoutRelation.equal,
//                                                         toItem: pageControl,
//                                                         attribute: NSLayoutAttribute.bottom,
//                                                         multiplier: 1.0,
//                                                         constant: 15)
//
//        view.addConstraints([pageControlCenterXConstraint!, pageControlBottomConstraint!])
//    }

    private func scrollToImage(withIndex: Int, animated: Bool = false) {
        imageCollectionView.scrollToItem(at: IndexPath(item: withIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }

    fileprivate func getImage(currentPage: Int) -> UIImage {
        let imageForPage = dataSource?.imageInGallery(gallery: self, forIndex: currentPage)
        return imageForPage!
    }

}


// MARK: UICollectionViewDataSource Methods
extension DetailCollectionViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfImagesInGallery(gallery: self) ?? 0
    }

    public func collectionView(_ imageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as! DetailCollectionViewCell
//        cell.image = getImage(currentPage: indexPath.row)
        return cell
    }
}


// MARK: UICollectionViewDelegate Methods
extension DetailCollectionViewController: UICollectionViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animateImageTransition = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateImageTransition = false
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let cell = cell as? SwiftPhotoGalleryCell {
//            cell.configureForNewImage(animated: animateImageTransition)
//        }
    }

}


// MARK: UIGestureRecognizerDelegate Methods
extension DetailCollectionViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return otherGestureRecognizer is UITapGestureRecognizer &&
            gestureRecognizer is UITapGestureRecognizer &&
            otherGestureRecognizer.view is DetailCollectionViewCell &&
            gestureRecognizer.view == imageCollectionView
    }
}
