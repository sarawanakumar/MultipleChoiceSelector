
//  PriorityTypeCollectionViewCell.swift
//  CollectorTester
//
//  Created by Sarawanak on 3/21/18.
//  Copyright © 2018 Sarawanak. All rights reserved.
//

import UIKit

typealias PriorityTypeCollectionViewCellDelegate = PriorityCellViewConstraintDelegate & PriorityCellViewActionDelegate

protocol PriorityCellViewActionDelegate {
    func selected(cell: PriorityTypeCollectionViewCell)
}

class PriorityTypeCollectionViewCell: UICollectionViewCell {
    
    private let highlightImage = UIImage(named: "tick")
    private var stackView: UIStackView!

    private lazy var priorityImageView: UIButton! = {
        guard let htConstant = delegate?.priorityImageHeightConstant else { return nil }

        let button = UIButton(type: UIButtonType.custom)
        button.setImage(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(selected(_:)), for: .touchDown)
        button.heightAnchor.constraint(equalToConstant: htConstant).activate()
        return button
    }()

    private lazy var highlightImageView: UIImageView! = {
        guard let htConstant = delegate?.highlightImageHeightConstant else { return nil }

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: htConstant).activate()
        return imageView
    }()

    private lazy var priorityNameLabel: UILabel! = {
        guard let htConstant = delegate?.highlightImageHeightConstant else { return nil }

        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = ""
        return label
    }()

    var isChosen: Bool = false {
        didSet {
            highlightImageView.image = isChosen ? highlightImage : nil
            contentView.alpha = isChosen ? 1.0 : 0.6
        }
    }

    weak var delegate: PriorityTypeCollectionViewCellDelegate? {
        didSet {
            stackView.spacing = delegate!.priorityCellStackSpacing
            stackView.addArrangedSubview(highlightImageView)
            stackView.addArrangedSubview(priorityImageView)
            stackView.addArrangedSubview(priorityNameLabel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.topAnchor.constraint(equalTo: stackView.superview!.topAnchor).activate()
        stackView!.centerXAnchor.constraint(equalTo: stackView.superview!.centerXAnchor).activate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews(_ priorityImage: UIImage?, _ priorityText: String) {
        self.priorityImageView.setImage(priorityImage, for: .normal)
        self.priorityNameLabel.text = priorityText.replacingOccurrences(of: " ", with: "\n")
    }

    @objc func selected(_ sender: UIButton) {
        delegate?.selected(cell: self)
    }

}

extension NSLayoutConstraint {
    func activate() {
        isActive = true
    }
}
