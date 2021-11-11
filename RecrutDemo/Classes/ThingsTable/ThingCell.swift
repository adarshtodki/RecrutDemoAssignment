import Foundation
import UIKit
var count: Int = 0

class ThingCell: UITableViewCell {
    
    private let thingImage = UIImageView()
    private let likeImage = UIImageView()
    private lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    private let background = UIView(frame: .zero)
    var updateThingImage: ((UIImage?) -> (Void)) = { _ in }
    
    var isLiked: Bool? = false {
        didSet {
            self.updateLikeImage(check: isLiked)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        updateThingImage = { image in
            self.change(image: image, in: self.thingImage)
        }
        
        initializeCellUI()
        setConstraintsForComponents()
        addShadow()
        setupImageView()
    }
    
    private func initializeCellUI() {
        background.backgroundColor = UIColor(white: 0.9, alpha: 0.1)
        contentView.addSubview(background)
        
        thingImage.contentMode = .scaleAspectFit
  
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(nameLabel)
        contentView.addSubview(thingImage)
        contentView.addSubview(likeImage)
    }
    
    private func setConstraintsForComponents() {
        thingImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        background.translatesAutoresizingMaskIntoConstraints = false
        
        thingImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        thingImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        thingImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        thingImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: thingImage.trailingAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: likeImage.leadingAnchor).isActive = true
        
        likeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        likeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        likeImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likeImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        thingImage.backgroundColor = UIColor.clear
        thingImage.layer.masksToBounds = true
        thingImage.layer.cornerRadius = 10.0
    }
    
    func update(withText: String) {
        nameLabel.text = withText
    }
    
    func update(withLikeValue: Bool?) {
        isLiked = withLikeValue
    }
    
    /*
    func animateAlphaLikeImage() {
        likeImage.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.likeImage.alpha = 1.0
        }
    }
     */
    
    func setLikeImageWithAnimation(image: UIImage) {
        change(image: image, in: likeImage)
    }
    
    private func updateLikeImage(check: Bool?) {
        if let value = check {
            let resourceName = value ? "likeO96" : "dontlikeO96"
            setLikeImageWithAnimation(image: #imageLiteral(resourceName: resourceName))
        } else {
            likeImage.image = nil
        }
    }
    
    private func change(image: UIImage?, in imageView: UIImageView, animated: Bool = true) {
        imageView.image = image
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
        
        thingImage.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        thingImage.layer.shadowOpacity = 0.3
        thingImage.layer.shadowRadius = 2.0
    }
}















