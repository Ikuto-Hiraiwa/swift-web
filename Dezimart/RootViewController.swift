//
//  ViewController.swift
//  Dezimart
//
//  Created by 平岩郁人 on 2017/10/24.
//  Copyright © 2017年 ikuto. All rights reserved.
//

import UIKit
import MMDrawerController
import PagingMenuController

var storyboard = UIStoryboard(name: "Main", bundle: nil)
let viewController1 = storyboard.instantiateViewController(withIdentifier: "MainView") as! MainViewController

let viewController2 = storyboard.instantiateViewController(withIdentifier: "GuitarView") as! GuitarViewController

let viewController3 = storyboard.instantiateViewController(withIdentifier: "BassView") as! BassViewController

let viewController4 = storyboard.instantiateViewController(withIdentifier: "DrumView") as! DrumViewController

let viewController5 = storyboard.instantiateViewController(withIdentifier: "AccosticView") as! AccosticViewController

private struct PagingMenuOptions: PagingMenuControllerCustomizable {

    
  //  private let viewController1 = MainViewController()
  //  private let viewController2 = GuitarViewController()
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(animationDuration:0.25), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [viewController1, viewController2,viewController3,viewController4,viewController5]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        
        var displayMode: MenuDisplayMode {
            return .infinite(widthMode: .flexible, scrollingMode: .scrollEnabledAndBouces)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(),MenuItem3(),MenuItem4(),MenuItem5()]
        }
        var menuPosition: MenuPosition{
            return .top
        }
        var focusMode: MenuFocusMode{
            //return .roundRect(radius: 3, horizontalPadding: 3, verticalPadding: 3, selectedColor: UIColor.lightGray)
            return .underline(height: 3, color: UIColor.red, horizontalPadding: 3, verticalPadding: 0)
        }
        //var backgroundColor: UIColor
        var animationDuration: TimeInterval
        
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            //return .multilineText(title: MenuItemText(text:"Home"), description: MenuItemText(text:""))
            return .text(title: MenuItemText(text: "Home"))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Guitar"))
        }
    }
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Bass"))
        }
    }
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Drum"))
        }
    }
    fileprivate struct MenuItem5: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Accostic"))
        }
    }
}



class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        let leftButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(RootViewController.menu_view(sender:)))
        leftButtonItem.image = #imageLiteral(resourceName: "Menu_img")
        navigationItem.leftBarButtonItem = leftButtonItem
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y += 64
        pagingMenuController.view.frame.size.height -= 64
       /* pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }*/
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
        
        
    }
    
    @objc func menu_view(sender:UIButton) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left,animated: true, completion:nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

