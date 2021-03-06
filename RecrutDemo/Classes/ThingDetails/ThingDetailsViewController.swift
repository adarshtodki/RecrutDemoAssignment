import Foundation
import UIKit

class ThingDetailsViewController: UIViewController {
    
    private let baseView = ThingDetailsView()
    var thingModel: ThingModel!
    var imageProvider: ImageProvider!
    var delegate: ThingDetailsDelegate? = nil
    
    override func loadView() {
        view = baseView
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeView()
    }
    
    private func initializeView() {
        title = thingModel.name
        baseView.likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        baseView.dislikeButton.addTarget(self, action: #selector(didTapDislikeButton), for: .touchUpInside)
        displayImage()
    }
    
    @objc func didTapLikeButton() {
        delegate?.thingDetails(viewController: self, didLike: &thingModel!)
    }
    
    @objc func didTapDislikeButton() {
        delegate?.thingDetails(viewController: self, didDislike: &thingModel!)
    }
    
    private func displayImage() {
        if let urlString = thingModel.image {
            imageProvider.imageAsync(from: urlString, completion: { (image, imageUrl) in
                self.baseView.setThing(image: image)
            })
        }
    }
}



