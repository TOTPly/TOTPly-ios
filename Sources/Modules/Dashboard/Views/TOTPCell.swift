//
//  TOTPCell.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class TOTPCell: UITableViewCell {
    static let reuseIdentifier = "TOTPCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let codeLabel: UILabel = {
        let l = UILabel()
        l.font = .monospacedDigitSystemFont(ofSize: 22, weight: .bold)
        l.textColor = .systemBlue
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timerLabel: UILabel = {
        let l = UILabel()
        l.font = .monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        l.textColor = .secondaryLabel
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.trackTintColor = .systemGray5
        pv.progressTintColor = .systemBlue
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let leftStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2
        leftStack.translatesAutoresizingMaskIntoConstraints = false

        let rightStack = UIStackView(arrangedSubviews: [codeLabel, timerLabel, progressView])
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing
        rightStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(leftStack)
        contentView.addSubview(rightStack)

        NSLayoutConstraint.activate([
            leftStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            leftStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            rightStack.leadingAnchor.constraint(greaterThanOrEqualTo: leftStack.trailingAnchor, constant: 12),

            leftStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            progressView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }

    func configure(with viewModel: TOTPCellModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle == nil
        codeLabel.text = viewModel.code
        timerLabel.text = viewModel.timeRemaining
        progressView.progress = Float(viewModel.progress)

        if viewModel.isExpiringSoon {
            codeLabel.textColor = .systemRed
            progressView.progressTintColor = .systemRed
            timerLabel.textColor = .systemRed
        } else {
            codeLabel.textColor = .systemBlue
            progressView.progressTintColor = .systemBlue
            timerLabel.textColor = .secondaryLabel
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = false
        codeLabel.text = nil
        codeLabel.textColor = .systemBlue
        timerLabel.text = nil
        timerLabel.textColor = .secondaryLabel
        progressView.progress = 0
        progressView.progressTintColor = .systemBlue
    }
}
