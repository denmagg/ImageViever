//
//  ImageAddingViewCell.swift
//  ImageViever
//
//  Created by Denis Medvedev on 11/02/2022.
//  Copyright © 2022 Denis Medvedev. All rights reserved.
//

import UIKit

final class ImageAddingViewCell: UITableViewCell {
    
    //MARK: properties
    
    var textField = UITextField()
    
    //MARK: private properties
    
    private var clearTextButton = UIButton()
    
    private var view: ImageAddingViewProtocol!
    
    private enum Consts {
        enum ClearTextButton {
            static let image = UIImage(systemName: "multiply.circle")
        }
    }

    //MARK: inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        configurateTextField()
        configurateClearTextButton()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init helpers
    
    private func setupSubviews() {
        addSubview(textField)
        addSubview(clearTextButton)
    }
    
    private func configurateTextField() {
        textField.delegate = self
        textField.isUserInteractionEnabled = true
        addSubview(clearTextButton)

    }
    
    private func configurateClearTextButton() {
        clearTextButton.imageView?.image = Consts.ClearTextButton.image
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.trailing.equalTo(self.contentView.snp.trailing).inset(40)
            make.leading.equalTo(self.contentView.snp.leading).inset(10)
        }
        
        clearTextButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
//            make.height.equalToSuperview()
            make.trailing.equalTo(self.contentView.snp.trailing).inset(10)
            make.leading.equalTo(textField)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension ImageAddingViewCell: UITextFieldDelegate {
    //FIXME: [general] Connection to daemon was invalidated???
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
