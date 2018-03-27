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

    var photoModelArray = [Photo]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var photoDetailDic = [String: PhotoDetail]() // photoId: PhotoDetailModel
    
    var currentPage = 1
    var currentIndex = -1
    
    var isLoading = false {
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
    
    lazy var fullView: FullScreenView = { [unowned self] in
        let view = FullScreenView(frame: CGRect.zero)
        view.delegate = self
        view.isHidden = true
        
        return view
    }()
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadMoreData()
    }
    
    fileprivate func loadMoreData() {
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
    
    fileprivate func setupUI() {
        self.title = "Demo"
        
        self.view.addSubview(fullView)
        self.view.addSubview(spinner)
        self.view.addSubview(collectionView)
        self.view.bringSubview(toFront: fullView)
        
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
        fullView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
       
    }
    
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

    fileprivate func showFullView(with index: Int) {
        // here reuse the spinner, just to indicate
        toggleSpinner(isloading: true)
        let model = photoModelArray[index]
        PhotoAPIService.getPhoto(by: model.id) { [unowned self] result in
            switch result {
            case .success(let photo):
                self.fullView.updateContent(with: photo)
                self.fullView.isHidden = false
            case .failure(let error):
                // todo
                print(error.localizedDescription)
            }
            
            self.toggleSpinner(isloading: false)
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
        
        cell.updateCellWith(model: photoModelArray[indexPath.row])
        cell.backgroundColor = .cellBackgroundColor
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoModelArray.count - 1 {
            loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
//        print(attributes?.frame)
        
        showFullView(with: indexPath.row)
    }
}

extension CollectionViewController: FullScreenViewProtocol {
    func dismiss() {
        fullView.isHidden = true
    }
}
