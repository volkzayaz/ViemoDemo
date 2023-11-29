//  VideoCellView.swift
//  Created by Vladislav Soroka on 29.11.2023.

import UIKit
import RxCocoa
import Toolbox
import RxDataSources
import SnapKit

class VideoCell: UICollectionViewCell {

    struct Props: IdentifiableType, Equatable {
        
        let url: String
        let name: String
        
        let tap: Command
        
        static var initial: Props { .init(url: "", name: "", tap: .nop) }
        
        var identity: String { url }
        
    }; var props: Props = .initial {
        didSet {
            render()
        }
    }
    
    func render() {
        thumbnailView.props = .init(image: .url(props.url), placeholder: UIImage(named: "placeholder"))
        nameLabel.text = props.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailView.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutLabel()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        layoutLabel()
        
        coordinator.addCoordinatedAnimations {
            self.contentView.layoutIfNeeded()
        }
    }
    
    private func layoutLabel() {
        nameLabel.snp.remakeConstraints { make in
            
            let guide: ConstraintAttributesDSL =                 isFocused ? thumbnailView.focusedFrameGuide.snp : thumbnailView.snp
            
            make.bottom.equalTo(guide.bottom).offset(-8)
            make.leading.equalTo(guide.leading).offset(8)
            make.trailing.equalTo(guide.trailing)
        }
        
        gradientView.snp.remakeConstraints { make in
            let guide: ConstraintAttributesDSL =                 isFocused ? thumbnailView.focusedFrameGuide.snp : thumbnailView.snp
            
            make.bottom.equalTo(guide.bottom)
            make.leading.equalTo(guide.leading)
            make.trailing.equalTo(guide.trailing)
        }
        
    }
    
    @IBOutlet weak var thumbnailView: SmartImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradientView: UIVisualEffectView!
    
}
