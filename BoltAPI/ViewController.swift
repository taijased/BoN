//
//  ViewController.swift
//  BoltAPI
//
//  Created by Maxim Spiridonov on 18/06/2019.
//  Copyright © 2019 Maxim Spiridonov. All rights reserved.
//

import UIKit





class ViewController: UIViewController, CAAnimationDelegate, StoryboardInitializable{
    
    @IBOutlet weak var infoButton: UIButton! {
        didSet {

            infoButton.layer.shadowColor = UIColor.black.cgColor
            infoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            infoButton.layer.shadowRadius = 1.0
            infoButton.layer.shadowOpacity = 0.5
            infoButton.layer.cornerRadius = 20
            infoButton.layer.masksToBounds = false
        }
    }
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let blurEffectView: UIVisualEffectView = UIVisualEffectView()
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 2.5, height: 4)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .redraw
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    let uploadButton: UIButton = {
        let button = UIButton.getCustomtButton(imageName: "upload")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 35
        button.backgroundColor = UIColor.white
        return button
    }()
    
    let colorOne = UIColor(hexValue: "#E47470", alpha: 1)!.cgColor
    let colorTwo = UIColor(hexValue: "#7EC050", alpha: 1)!.cgColor
    let colorThree = UIColor(hexValue: "#3E45E5", alpha: 1)!.cgColor
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    var imageIsChange = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createGradientView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseImageTapped(tapGestureRecognizer:)))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(tap)
        
    }
    
    private func setupUI() {
        view.addSubview(uploadButton)
        uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
//
//        view.addSubview(infoButton)
//        infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
//        infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        infoButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        infoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
        
        view.addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        cardView.addSubview(myImageView)
        myImageView.fillSuperview()
        
    }

    
    private func errorAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .destructive)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @objc func infoButtonTapped(_ sender: UIButton) {
        sender.flash()
    }
    @objc func uploadButtonTapped(_ sender: UIButton) {
        sender.flash()
        
        guard let image = myImageView.image,
            let imageProperties = ImageProperties(withImage: image, forKey: "image.jpg")
        else {
            errorAlert("Выберите изображение для распознавания болта или гайки!")
            return
        }
        
        
        blurEffectView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = false
        view.addSubview(blurEffectView)
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(hexValue: "#3E45E5", alpha: 1)
        view.addSubview(activityIndicator)
      
       
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        NetworkManager.uploadImage(imageProperties: imageProperties) {[weak self] (image, error) in
            DispatchQueue.main.async {
                if error {
                    self?.errorAlert("Упс! что то пошло не так!")
                    return
                }
                guard let image = image else{ return }
                self?.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self?.blurEffectView.isHidden = true
                self?.myImageView.image = image
            }
        }

    }
    
    @objc func chooseImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let cameraIcon = UIImage(named: "photo_camera")
        let photoIcon = UIImage(named: "photo_picture")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    /// Creates gradient view
    
    func createGradientView() {
        
        
        gradientSet.append([colorOne, colorTwo])
        gradientSet.append([colorTwo, colorThree])
        gradientSet.append([colorThree, colorOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:1, y:1)
        gradient.endPoint = CGPoint(x:0, y:1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        animateGradient()
    }
    func animateGradient() {
        
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }

}



// MARK: Work with image

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = source
            present(imagePickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.main.async {
            self.myImageView.image = info[.editedImage] as? UIImage
        }
        
        dismiss(animated: true)
    }
    
}

