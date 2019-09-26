//
//  DetailsViewController.swift
//  Fetch
//
//  Created by Nhan Truong on 26/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel: PhotoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = viewModel.title
        viewModel?.loadingDelegate = self
        viewModel?.delegate = self
        viewModel?.loadPhoto()
    }

}

extension DetailsViewController: PhotoViewModelDelegate {
    // MARK: - PhotoViewModelDelegate
    func onFetchCompleted(image: UIImage) {
        self.photoView.image = image
    }
    
    func onFetchFailed(with reason: String) {
        let action = UIAlertAction(title: TEXT.OK, style: .default)
        displayAlert(with: TEXT.AlertTitle , message: reason, actions: [action])
    }
}

extension DetailsViewController: IndicatorLoading, AlertDisplayer {}
