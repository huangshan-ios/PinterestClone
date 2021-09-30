//
//  ImageCollectionViewCell.swift
//  PinterestClone
//
//  Created by SonHoang on 3/1/21.
//

import UIKit
import Combine

class ImageCollectionViewCell: UICollectionViewCell {
    
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var collectionImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionImage.image = nil
        cancellables = Set<AnyCancellable>()
    }
    
    func setupCell(with item: ImageCollectionItem) {
        guard let url = URL(string: item.coverImageURL) else { return }
        ImageLoader().publisher(for: url).sink { (_) in
        } receiveValue: { [weak self] (image) in
            guard let self = self else { return }
            self.collectionImage.image = image
        }.store(in: &cancellables)
    }
    
}
