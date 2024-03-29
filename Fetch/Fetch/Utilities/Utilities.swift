//
//  UIUtilities.swift
//  Fetch
//
//  Created by kyle on 25/09/2019.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit


// MARK: - CGRect extension

extension CGRect {
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}


// MARK: - UIColor extension

extension UIColor {
    static let appBackgroundColor = #colorLiteral(red: 0.05882352941, green: 0.09019607843, blue: 0.1098039216, alpha: 1)
}


// MARK: - String extension

extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}


// MARK: - AlertDisplayer Protocol

protocol AlertDisplayer {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
    guard presentedViewController == nil else {
      return
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions?.forEach { action in
      alertController.addAction(action)
    }
    present(alertController, animated: true)
  }
}


// MARK: - LoadingWebserviceDelegate

protocol LoadingWebservice: class {
    func willInvokeService()
    func didServiceResponse()
}


// MARK: - Loading

protocol IndicatorLoading: LoadingWebservice {
    var spinner: UIActivityIndicatorView! { get set }
}

extension IndicatorLoading where Self: UIViewController {
    
    func willInvokeService() {
        spinner.startAnimating()
    }
    
    func didServiceResponse() {
        spinner.stopAnimating()
    }
}


// MARK: - Enum Text

enum TEXT {
    static let Title      = "Flickr".localizedString
    static let AlertTitle = "Warning".localizedString
    static let OK         = "OK".localizedString
}


// MARK: - SegueHandlerType

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where
    Self: UIViewController,
    SegueIdentifier.RawValue == String {
    
    func performSegue(segueIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Invalid segue identifier \(String(describing: segue.identifier)).")
        }
        return segueIdentifier
    }
}
