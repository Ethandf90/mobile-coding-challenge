//
//  CollectionViewController.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import UIKit
import SnapKit

struct CollectionViewControllerConst {
    static let cellIdentifier = "cellIdentifier"
    static let spinnerSize = 40
}

class CollectionViewController: UIViewController {

    // MARK: property
    
    fileprivate var photoModelArray = [Photo]() {
        didSet {
            collectionView.reloadData()
            if let gallery = self.gallery {
                gallery.imageCollectionView.reloadData()
            }
        }
    }
    fileprivate var photoDetailDic = [String: PhotoDetail]() // [photoId: PhotoDetailModel] to hold downloaded PhotoDetailModel
    
    fileprivate var currentPage = 1  // current pagination, for data downloading
    fileprivate var currentIndex = -1  // current selected index
    
    fileprivate var isLoading = false {
        didSet {
            toggleSpinner(isloading: isLoading)
        }
    }
    
    // MARK: subviews
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 10) / 3, height: (UIScreen.main.bounds.size.width - 10) / 3)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewControllerConst.cellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        
        return collectionView
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: CGRect.zero)
        spinner.activityIndicatorViewStyle = .gray
        
        return spinner
    }()
    
    var gallery: DetailCollectionViewController?
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
        
        addSubviews()
        addConstraints()
        loadData()
    }
    
    // MARK: private function
    
    fileprivate func toggleSpinner(isloading: Bool) {
        if isloading {
            spinner.startAnimating()
//            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                self.spinner.snp.updateConstraints({ (make) in
                    make.height.equalTo(CollectionViewControllerConst.spinnerSize)
                })
//            })
        } else {
            spinner.stopAnimating()
//            UIView.animate(withDuration: 1, animations: { [unowned self] in
                self.spinner.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
//            })
        }
    }
}

// for UI
extension CollectionViewController: ViewControllerProtocol {
    internal func addSubviews() {
        self.view.addSubview(spinner)
        self.view.addSubview(collectionView)
    }
    
    internal func addConstraints() {
        spinner.snp.makeConstraints { (make) in
            make.height.equalTo(0)
            make.width.equalTo(CollectionViewControllerConst.spinnerSize)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(spinner.snp.top)
        }
    }
    
    internal func loadData() {
        isLoading = true
        PhotoAPIService.getPhotos(from: currentPage){ [unowned self] result in
            switch result {
            case .success(let photos):
                self.photoModelArray += photos  // append more on the existing list
            case .failure(let error):
                print(error)
            }
            self.currentPage += 1
            self.isLoading = false
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewControllerConst.cellIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.model = photoModelArray[indexPath.row]
        cell.backgroundColor = .cellBackgroundColor
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoModelArray.count - 1 {
            loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        
        gallery = DetailCollectionViewController(delegate: self, dataSource: self)
        gallery?.modalPresentationStyle = .custom
        gallery?.transitioningDelegate = self
        if let gallery = self.gallery {
            present(gallery, animated: true, completion: { [unowned self] in
                gallery.currentPage = self.currentIndex
            })
        }
        
    }
}

// MARK: DetailCollectionViewControllerDataSource Methods
extension CollectionViewController: DetailCollectionViewControllerDataSource {
    func numberOfCellsInGallery(gallery: DetailCollectionViewController) -> Int {
        return photoModelArray.count
    }
    
    func modelInGallery(gallery: DetailCollectionViewController, forIndex: Int) -> Any {
        return photoModelArray[forIndex]
    }
}

// MARK: DetailCollectionViewControllerDelegate Methods
extension CollectionViewController: DetailCollectionViewControllerDelegate {
    func galleryDidTapToClose(gallery: DetailCollectionViewController) {
        self.currentIndex = gallery.currentPage
        dismiss(animated: true, completion: nil)
    }
    
    func galleryDidMoveTo(index: Int) {
        // make current index cell visible in the middle
        self.currentIndex = index
        self.collectionView.scrollToItem(at: IndexPath(row: index, section:0), at: .centeredVertically, animated: false)
    }
}

extension CollectionViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // need to get the frame against window, not the collectionView
        guard let selectedCellFrame = self.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0))?.globalFrame else { return nil }
        
        print(selectedCellFrame)
        return PresentAnimator(pageIndex: currentIndex, originFrame: selectedCellFrame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // need to get the frame against window, not the collectionView
        guard let returnCellFrame = self.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0))?.globalFrame else { return nil }
        return DismissAnimator(pageIndex: currentIndex, finalFrame: returnCellFrame)
    }
}

