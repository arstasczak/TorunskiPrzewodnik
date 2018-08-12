import UIKit

class NavigationItem: UINavigationItem {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
}
