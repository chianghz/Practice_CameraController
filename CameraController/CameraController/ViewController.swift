//
//  ViewController.swift
//  CameraController
//
//  Created by 江翰臻 on 2021/10/14.
//

import UIKit
import Combine
import SnapKit

class ViewController: UIViewController {

    // MARK: - View Components

    let previewContainerView = UIView()

    let capturedImageView = CapturedImageView()

    lazy var switchCameraButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "switchcamera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
        return button
    }()

    lazy var captureImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Variables

    lazy var cameraController = CameraController(previewContainer: previewContainerView)

    var cancellables = Set<AnyCancellable>()

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        initConstraints()

        bindCameraController()
        cameraController.checkPermissions { [weak self] authorized in
            if authorized {
                self?.cameraController.setup()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        cameraController.stop()
    }
}

private extension ViewController {

    func initConstraints() {
        view.addSubview(previewContainerView)
        previewContainerView.snp.makeConstraints { $0.edges.equalToSuperview() }

        view.addSubview(switchCameraButton)
        switchCameraButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        view.addSubview(captureImageButton)
        captureImageButton.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        view.addSubview(capturedImageView)
        capturedImageView.snp.makeConstraints {
            $0.size.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.33)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }

    func bindCameraController() {
        cameraController.errorCatched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                let alert = UIAlertController(title: error.string, message: nil, preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "close", style: .cancel, handler: nil)
                alert.addAction(closeAction)
                self?.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)

        cameraController.imageCaptured
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.capturedImageView.image = image
            }
            .store(in: &cancellables)

        cameraController.$isCameraSwitching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSwitching in
                self?.captureImageButton.isEnabled = !isSwitching
            }
            .store(in: &cancellables)
    }

    @objc func captureImage(_ sender: UIButton?) {
        cameraController.captureImage()
    }

    @objc func switchCamera(_ sender: UIButton?) {
        cameraController.switchCamera()
    }
}

