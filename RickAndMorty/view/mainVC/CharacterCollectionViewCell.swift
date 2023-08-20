import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        Label.text = ""
        imageView.image = nil
        imageView.backgroundColor = .gray
        
    }
}
