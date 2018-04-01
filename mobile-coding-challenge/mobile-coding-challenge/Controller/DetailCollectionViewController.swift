//
//  DetailCollectionViewController
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-28.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

@objc public protocol DetailCollectionViewControllerDataSource {
    func numberOfCellsInGallery(gallery: DetailCollectionViewController) -> Int
    func modelInGallery(gallery: DetailCollectionViewController, forIndex: Int) -> Any
}

@objc public protocol DetailCollectionViewControllerDelegate {
    func galleryDidTapToClose(gallery: DetailCollectionViewController)
    func galleryDidMoveTo(index: Int)
}

struct DetailCollectionViewControllerConst {
    static let cellidentifier = "detailcellidentifier"
}

public class DetailCollectionViewController: UIViewController {

    public weak var dataSource: DetailCollectionViewControllerDataSource?
    public weak var delegate: DetailCollectionViewControllerDelegate?

    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    public lazy var imageCollectionView: UICollectionView = {
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DetailCollectionViewControllerConst.cellidentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()

    public var currentPage: Int {
        set(page) {
            if page < numberOfImages {
                scrollToImage(withIndex: page, animated: false)
            } else {
                scrollToImage(withIndex: numberOfImages - 1, animated: false)
            }
        }
        get {
            // everytime using the value 'currentPage', update pageBeforeRotation so that it scrolls to that index after rotation
            pageBeforeRotation = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
            return Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
        }
    }
    
    private var numberOfImages: Int {
        return collectionView(imageCollectionView, numberOfItemsInSection: 0)
    }

    private var pageBeforeRotation: Int = 0
    private var needsLayout = true
    
    fileprivate var photoDetailDic = [String: PhotoDetail]() // [photoId: PhotoDetailModel] to hold downloaded PhotoDetailModel
    
    // MARK: Public
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

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        addSubviews()
        addConstraints()
        setupGestureRecognizers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        if currentPage < 0 {
            currentPage = 0
        }
    }
    
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
            
//            imageCollectionView.reloadItems(at: [desiredIndexPath])
            
            for cell in imageCollectionView.visibleCells {
                if let cell = cell as? DetailCollectionViewCell {
                    cell.configureForNewImage(animated: false)
                }
            }
            
            needsLayout = false
        }
    }

    // MARK: Rotation Handling
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        needsLayout = true
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .allButUpsideDown
        }
    }

    public override var shouldAutorotate: Bool {
        get {
            return true
        }
    }

    // MARK: Gesture Handlers

    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(recognizer:)))
        tap.numberOfTapsRequired = 1
//        tap.delegate = self
        imageCollectionView.addGestureRecognizer(tap)
    }

    @objc public func tapAction(recognizer: UITapGestureRecognizer) {
        delegate?.galleryDidTapToClose(gallery: self)
    }

    // MARK: Private Methods

    private func scrollToImage(withIndex: Int, animated: Bool = false) {
        imageCollectionView.scrollToItem(at: IndexPath(item: withIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }

    fileprivate func getModel(currentPage: Int) -> Photo {
        return dataSource?.modelInGallery(gallery: self, forIndex: currentPage) as! Photo
    }
}

extension DetailCollectionViewController: ViewControllerProtocol {
    func addSubviews() {
        view.addSubview(imageCollectionView)
    }
    func addConstraints() {
        imageCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    func loadData() {
    }
}

// MARK: UICollectionViewDataSource Methods
extension DetailCollectionViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfCellsInGallery(gallery: self) ?? 0
    }

    public func collectionView(_ imageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewControllerConst.cellidentifier, for: indexPath) as! DetailCollectionViewCell
        cell.model = getModel(currentPage: indexPath.row)
        return cell
    }
}

// MARK: UICollectionViewDelegate Methods
extension DetailCollectionViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // do the downloading here
        
        if let model = (cell as! DetailCollectionViewCell).model,
            (cell as! DetailCollectionViewCell).detailModel == nil {
            if let photo = photoDetailDic[model.id] {
                (cell as! DetailCollectionViewCell).detailModel = photo
            } else {
                PhotoAPIService.getPhoto(by: model.id) { [unowned self] result in
                    switch result {
                    case .success(let photo):
                        self.photoDetailDic[model.id] = photo
                        (cell as! DetailCollectionViewCell).detailModel = photo
                    case .failure(let error):
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
        if (indexPath.row > 0) {
            self.delegate?.galleryDidMoveTo(index: indexPath.row)
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageBeforeRotation = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
    }
}

// MARK: UIGestureRecognizerDelegate Methods
//extension DetailCollectionViewController: UIGestureRecognizerDelegate {
//
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return otherGestureRecognizer is UITapGestureRecognizer &&
//            gestureRecognizer is UITapGestureRecognizer &&
//            otherGestureRecognizer.view is DetailCollectionViewCell &&
//            gestureRecognizer.view == imageCollectionView
//    }
//}
