//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var items: [MenuItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(R.nib.menuTableViewCell)

        items = [
            MenuItem(id: "about", icon: R.image.menu.about()!, label: "About"),
            MenuItem(id: "address", icon: R.image.menu.address()!, label: "My address"),
            MenuItem(id: "key", icon: R.image.menu.key()!, label: "Private key"),
            MenuItem(id: "social", icon: R.image.menu.social()!, label: "Social network"),
            MenuItem(id: "faq", icon: R.image.menu.faq()!, label: "FAQ"),
            MenuItem(id: "language", icon: R.image.menu.language()!, label: "Language"),
        ]
        tableView.reloadData()
    }

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

extension MenuViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.menuTableViewCell,
                                                 for: indexPath)!

        let item = items[indexPath.row]
        cell.iconView.image = item.icon
        cell.itemLabel.text = item.label
        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   let detailViewController = R.storyboard.vehicle.vehicleDetailViewController()!
        //  detailViewController.vehicleId = items[indexPath.row].id
        //   present(detailViewController, animated: true)
    }
}

class MenuItem {
    var id: String
    var icon: UIImage
    var label: String

    init(id: String, icon: UIImage, label: String) {
        self.id = id
        self.icon = icon
        self.label = label
    }
}
