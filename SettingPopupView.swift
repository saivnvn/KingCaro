import UIKit

class SettingPopupView: UIView {
    var onButtonTapped: ((Int) -> Void)?
    
    private var gradientLayer: CAGradientLayer?
    private var shapeLayer: CAShapeLayer?
    private var container: UIView!
    
    var topRowColor: UIColor =  .systemCyan
    var bottomRowColor: UIColor = .darkGray
    var bottomRowCloseColor: UIColor = .systemRed
    
    var XRowCloseColor: UIColor = .systemPink
    var ORowCloseColor: UIColor = .cyan
    
    private var scaleFactor: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0
    }
    
    init(title: String = "⚙️ Setting") {
        super.init(frame: .zero)
        setupUI(title: title)
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // 🧱 Container chính
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 18 * scaleFactor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.25
        container.layer.shadowRadius = 8 * scaleFactor
        addSubview(container)
        
        // 🔹 Tiêu đề
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22 * scaleFactor)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        container.addSubview(titleLabel)
        
        let preferredLanguage = NSLocale.preferredLanguages.first ?? "en"

        // Xác định ngôn ngữ chính (chỉ lấy 2 ký tự đầu)
        let langCode = String(preferredLanguage.prefix(2))

        var titles: [String]

        switch langCode {
        case "vi": // 🇻🇳 Tiếng Việt
            titles = ["🎵 Bật", "O Trước", "About",
                       "🎵 Tắt", "X Trước", "Đóng"]

        case "ru": // 🇷🇺 Tiếng Nga
            titles = ["🎵 ВКЛ", "O ходит первым", "О программе",
                       "🎵 ВЫКЛ", "X ходит первым", "Закрыть"]

        case "zh": // 🇨🇳 Tiếng Trung (Giản thể)
            titles = ["🎵 开", "O先手", "关于",
                       "🎵 关", "X先手", "关闭"]

        case "ja": // 🇯🇵 Tiếng Nhật
            titles = ["🎵 オン", "O 先攻", "概要",
                       "🎵 オフ", "X 先攻", "閉じる"]

        default: // 🇬🇧 English (mặc định)
            titles = ["🎵 On", "O First", "About",
                       "🎵 Off", "X First", "Close"]
        }

        
        var buttons: [UIButton] = []
        for i in 1...6 {
            let btn = UIButton(type: .system)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitle(titles[i - 1], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16 * scaleFactor, weight: .medium)
            btn.setTitleColor(.white, for: .normal)
            //btn.backgroundColor = (i <= 3) ? topRowColor : bottomRowColor
            
            btn.backgroundColor = {
                if i == 3 || i == 1 {
                    return topRowColor
                }
                else if i == 2
                {
                    return bottomRowColor //namthz
                }
                else if i == 6 {
                    return bottomRowCloseColor   // 🎯 riêng nút thứ 6
                }
             else if i == 4 {
                return bottomRowCloseColor   // 🎯 riêng nút thứ 6
            }
                else {
                    return bottomRowColor
                }
            }()
            
            
            btn.layer.cornerRadius = 8 * scaleFactor
            btn.tag = i
            btn.heightAnchor.constraint(equalToConstant: 44 * scaleFactor).isActive = true
            btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(btn)
        }
        
        // 📐 Hai hàng nút
        let row1 = UIStackView(arrangedSubviews: Array(buttons[0...2]))
        row1.axis = .horizontal
        row1.distribution = .fillEqually
        row1.spacing = 8 * scaleFactor
        
        let row2 = UIStackView(arrangedSubviews: Array(buttons[3...5]))
        row2.axis = .horizontal
        row2.distribution = .fillEqually
        row2.spacing = 8 * scaleFactor
        
        let verticalStack = UIStackView(arrangedSubviews: [row1, row2])
        verticalStack.axis = .vertical
        verticalStack.spacing = 10 * scaleFactor
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(verticalStack)
        
        // 🩶 Label tác giả (clickable)
        let creditLabel = UILabel()
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        creditLabel.text = "© Hai Nam Trinh 🇻🇳"
        creditLabel.font = UIFont.systemFont(ofSize: 15 * scaleFactor)
        creditLabel.textColor = UIColor.darkGray
        creditLabel.textAlignment = .center
        creditLabel.isUserInteractionEnabled = true
        container.addSubview(creditLabel)
        
        // 👉 Thêm gesture mở link App Store
        let tapCredit = UITapGestureRecognizer(target: self, action: #selector(openDeveloperLink))
        creditLabel.addGestureRecognizer(tapCredit)
        
        // 📏 Ràng buộc Auto Layout
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 320 * scaleFactor),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24 * scaleFactor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16 * scaleFactor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16 * scaleFactor),
            
            verticalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24 * scaleFactor),
            verticalStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12 * scaleFactor),
            verticalStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12 * scaleFactor),
            
            creditLabel.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 22 * scaleFactor),
            creditLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            creditLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            creditLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10 * scaleFactor)
        ])
        
        // 📱 Tap ra ngoài để đóng
       // let tapOutside = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      //  addGestureRecognizer(tapOutside)
    }
    
    // MARK: - Hành động nút
    @objc private func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.alpha = 0.7
        }) { _ in
            sender.alpha = 1
            self.close()
            self.onButtonTapped?(sender.tag)
        }
    }
    
   
    // MARK: - Mở link App Store
    @objc private func openDeveloperLink() {
        if let url = URL(string: "https://apps.apple.com/us/developer/hai-nam-trinh/id1139152400") {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Đóng popup
    private func close() {
        gradientLayer?.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - ✨ Viền sáng động
    private func addShiningBorder() {
        gradientLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.white.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.black.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = container.bounds
        gradient.cornerRadius = container.layer.cornerRadius
        gradient.masksToBounds = true
        
        let shape = CAShapeLayer()
        shape.lineWidth = 5 * scaleFactor
        shape.path = UIBezierPath(
            roundedRect: container.bounds.insetBy(dx: 2, dy: 2),
            cornerRadius: container.layer.cornerRadius
        ).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        gradient.mask = shape
        
        container.layer.addSublayer(gradient)
        gradientLayer = gradient
        shapeLayer = shape
        
        let move = CABasicAnimation(keyPath: "startPoint.y")
        move.fromValue = -1.0
        move.toValue = 2.0
        move.duration = 1.3
        move.repeatCount = .infinity
        move.autoreverses = true
        move.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradient.add(move, forKey: "movingLight")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = container.bounds
        shapeLayer?.path = UIBezierPath(
            roundedRect: container.bounds.insetBy(dx: 2, dy: 2),
            cornerRadius: container.layer.cornerRadius
        ).cgPath
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.addShiningBorder()
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                    self.alpha = 1
                    self.transform = .identity
                }
            }
        }
    }
    
    // ✅ Chặn xuyên touch xuống lớp dưới
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || self.alpha < 0.01 || !self.isUserInteractionEnabled {
            return nil
        }
        if container.frame.contains(point) {
            return super.hitTest(point, with: event)
        }
        return self
    }
}
