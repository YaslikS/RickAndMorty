import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = ""
        numberLabel.text = ""
        dateLabel.text = ""
        activityIndicator.startAnimating()
    }
    
}
