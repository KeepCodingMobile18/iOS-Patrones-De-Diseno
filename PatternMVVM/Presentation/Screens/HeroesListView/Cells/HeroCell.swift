import UIKit

final class HeroCell: UITableViewCell {
    static let reuseIdentifier = "HeroCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarView: AsyncImage!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.cancel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = avatarView.bounds.height / 2
    }
    
    func populate(title: String, avatar: String) {
        titleLabel.text = title
        avatarView.setImage(avatar)
    }
}
