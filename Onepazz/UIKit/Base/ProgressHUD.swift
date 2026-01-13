import UIKit

final class ProgressHUDView: UIView {
    private let titleLabel = UILabel()
    private let progress = UIProgressView(progressViewStyle: .default)
    private let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        layer.cornerRadius = 14
        clipsToBounds = true

        addSubview(blur)
        blur.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: topAnchor),
            blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [titleLabel, progress])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        blur.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: blur.contentView.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor, constant: -14),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 240)
        ])
        titleLabel.text = "Uploading…"
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
    }

    func set(title: String) { titleLabel.text = title }
    func set(fraction: Double) { progress.progress = Float(fraction) }
}

extension UIViewController {
    func showProgressHUD(title: String = "Uploading…") -> ProgressHUDView {
        let hud = ProgressHUDView()
        hud.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hud)
        NSLayoutConstraint.activate([
            hud.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hud.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hud.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
        hud.alpha = 0
        UIView.animate(withDuration: 0.2) { hud.alpha = 1 }
        hud.set(title: title)
        return hud
    }
    func hideProgressHUD(_ hud: ProgressHUDView?) {
        guard let hud = hud else { return }
        UIView.animate(withDuration: 0.2, animations: { hud.alpha = 0 }) { _ in hud.removeFromSuperview() }
    }
}