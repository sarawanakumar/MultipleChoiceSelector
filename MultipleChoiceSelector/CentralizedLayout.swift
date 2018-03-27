//
//  CentralizedLayout.swift
//  CollectorTester
//
//  Created by Sarawanak on 3/21/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import Foundation
import UIKit

protocol UICollectionViewMatchWidthLayoutProtocol: class {
    var cellHeight: CGFloat { get }
}

class UICollectionViewMatchWidthLayout: UICollectionViewLayout {

    var numberOfColumns: Int!
    var cellPadding: CGFloat!
    weak var delegate: UICollectionViewMatchWidthLayoutProtocol?

    var cache = [UICollectionViewLayoutAttributes]()
    var contentHeight = CGFloat(0)

    private override init() {
        super.init()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(columns: Int, cellPadding: CGFloat) {
        self.init()
        self.numberOfColumns = columns
        self.cellPadding = cellPadding
    }

    var contentWidth: CGFloat {
        guard let cv = collectionView else { return 0 }

        let insets = cv.contentInset
        return cv.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let cv = collectionView, cache.isEmpty else { return  }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()

        for col in 0..<numberOfColumns {
            xOffset.append(CGFloat(col) * columnWidth)
        }

        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0..<cv.numberOfItems(inSection: 0) {
            let ip = IndexPath(item: item, section: 0)

            let height = cellPadding * 2 + (delegate?.cellHeight)!

            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)

            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attr = UICollectionViewLayoutAttributes(forCellWith: ip)
            attr.frame = insetFrame
            cache.append(attr)
            
            contentHeight = max(contentHeight, frame.maxY)
            column += 1
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttr = [UICollectionViewLayoutAttributes]()

        for attr in cache {
            if attr.frame.intersects(rect) {
                visibleLayoutAttr.append(attr)
            }
        }

        return visibleLayoutAttr
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
