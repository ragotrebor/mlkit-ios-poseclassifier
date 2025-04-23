//
//  ClassificationView.swift
//  VisionExample
//
//  Created by Roberto García on 22-04-25.
//  Copyright © 2025 Google Inc. All rights reserved.
//


import UIKit

class ClassificationView: UIView {

    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
      label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
      label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLabel)
        addSubview(bottomLabel)

        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            topLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: -4),

            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            topLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
        ])
    }
}
