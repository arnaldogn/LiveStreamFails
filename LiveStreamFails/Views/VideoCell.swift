//
//  VideoCell.swift
//  LiveStreamFails
//
//  Created by Arnaldo on 3/24/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    var data: Video? {
        didSet {
            self.previewImage?.kf.setImage(with: data?.thumbnailURL)
            self.titleLbl.text = data?.title
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        selectionStyle = .none
//        titleLbl.backgroundColor = UIColor.black.withAlphaComponent(0.33)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.isHidden = false
        data = nil
    }
}
