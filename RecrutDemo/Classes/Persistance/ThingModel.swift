import Foundation
import UIKit

class ThingModel {
    
    let name: String
    var like: Bool?
    var image: String?
    var type: String?
    var uuid: String?
    var index: NSNumber?
    var modelCell: ThingCell?
    
    init(name: String) {
        self.name = name
    }
    
    func setLike(value: Bool) {    
        like = value
        modelCell?.update(withLikeValue: value)
    }
}

























