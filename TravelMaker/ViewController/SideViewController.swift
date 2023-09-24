//
//  SideViewController.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/24.
//

import UIKit
import SideMenu

class SideViewController: UIViewController {
    
    @IBOutlet weak var sideTableView: UITableView!
    
    var menu: [SideMenuModel] = []
    
    
    var defaultHighlightedCell: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataInit()
        
        // TableView
        self.sideTableView.delegate = self
        self.sideTableView.dataSource = self
//        self.sideTableView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        self.sideTableView.separatorStyle = .none
        
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
            
            // Do any additional setup after loading the view.
        }
        
    }
    
    
    func dataInit(){
        menu.append(SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"))
        menu.append(SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "Music"))
        menu.append(SideMenuModel(icon: UIImage(systemName: "film.fill")!, title: "Movies"))
        menu.append(SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: "Books"))
        menu.append(SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Profile"))
        menu.append(SideMenuModel(icon: UIImage(systemName: "slider.horizontal.3")!, title: "Settings"))
        menu.append(SideMenuModel(icon: UIImage(systemName: "hand.thumbsup.fill")!, title: "Like us on facebook"))
    }
    
    
    
    
    
    
}
extension SideViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
       return menu.count
   }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideTableViewCell
        
        
                cell.imgIcon.image = menu[indexPath.row].icon
                cell.lblTitle.text = menu[indexPath.row].title

                // Highlighted color
//                let myCustomSelectionColorView = UIView()
//                myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
//                cell.selectedBackgroundView = myCustomSelectionColorView
                return cell
    }
    
    
}


