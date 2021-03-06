//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case search
    case order
    case settings
    case shepardsMode
}

enum ActionSheetMenu: Int {
    case cancel = 0
    case takePhoto
    case getWithLibrary
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    let picker = UIImagePickerController()
    
    var menus = ["КАРТА", "ПОИСК", "МОИ ЗАКАЗЫ", "НАСТРОЙКИ"]
    var images = ["icon_map", "icon_search", "icon_zakazy", "icon_nastroyki"]

    
    var mainViewController:             UIViewController!
    var searchNavigationViewController: UIViewController!
    var settingsNavigationControler:    UIViewController!
    var ordersNavigationControler:    UIViewController!

    
//    var managerCardViewController: UIViewController!
//    var helpViewController: UIViewController!
//    var historyViewController: UIViewController!
//    var historyShepardViewController: UIViewController!
//    var shepardsModeViewController: UIViewController!
    
//    override required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewFooter = UIView()
        viewFooter.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: (self.view.frame.height-64.0) - (44.0*4))
        viewFooter.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 0.0)
        
        let viewFooterUnder = UIView()
        viewFooterUnder.frame = CGRect(x: 0.0, y: viewFooter.frame.size.height - 44.0, width: self.view.frame.size.width, height: 44.0)
        viewFooterUnder.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        viewFooter.addSubview(viewFooterUnder)
        
        let lineBot = UIView()
        lineBot.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 1.0)
        lineBot.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        viewFooterUnder.addSubview(lineBot)
        
        let line = UIView()
        line.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 1.0)
        line.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        viewFooter.addSubview(line)
        
        let viewFooterImage = UIImageView()
        viewFooterImage.frame = CGRect(x: 8.0, y: viewFooter.frame.size.height - 44.0, width: 44.0, height: 44.0)
        viewFooterImage.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 0.0)
        viewFooterImage.contentMode = UIViewContentMode.center
        viewFooterImage.image = UIImage(named: "icon_vhod_vyhod")
        
        viewFooter.addSubview(viewFooterImage)

        let exitButton: UIButton = UIButton(type:UIButtonType.custom) as UIButton
//        .buttonWithType(UIButtonType.Custom) as! UIButton
        exitButton.frame = CGRect(x: 0.0, y: viewFooter.frame.size.height - 44.0, width: self.view.frame.size.width, height: 44.0)
        exitButton.addTarget(self, action: #selector(LeftViewController.onExitButton(_:)), for: UIControlEvents.touchUpInside)
        exitButton.setTitle("ВЫХОД", for: UIControlState())
        exitButton.setTitleColor(UIColor(white: 0.0, alpha: 1.0), for: UIControlState())
        exitButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 170)
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)

        viewFooter.addSubview(exitButton)
        
        self.tableView.tableFooterView = viewFooter
        
        self.tableView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.separatorColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        
        var storyboard = UIStoryboard(name: "Search", bundle: nil)
        self.searchNavigationViewController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        
        
        storyboard = UIStoryboard(name: "Settings", bundle: nil)
        self.settingsNavigationControler = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController") as! UINavigationController

        storyboard = UIStoryboard(name: "OrderBoard", bundle: nil)
        self.ordersNavigationControler = storyboard.instantiateViewController(withIdentifier: "OrdersNavigationControler") as! UINavigationController
        
//        storyboard = UIStoryboard(name: "Help", bundle: nil)
//        let helpViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForHelpViewController") as! UINavigationController
//        self.helpViewController = helpViewController
//
//        storyboard = UIStoryboard(name: "History", bundle: nil)
//        let historyViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForHistoryViewController") as! UINavigationController
//        self.historyViewController = historyViewController
//        
//        storyboard = UIStoryboard(name: "History", bundle: nil)
//        let historyShepardViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForHistoryShepardViewController") as! UINavigationController
//        self.historyShepardViewController = historyShepardViewController
//        
//        storyboard = UIStoryboard(name: "ShepardsMode", bundle: nil)
//        let shepardsModeViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForShepardsModeViewController") as! UINavigationController
//        self.shepardsModeViewController = shepardsModeViewController

        
//        UserHistoryShepardViewController
        
//        let javaViewController = storyboard.instantiateViewControllerWithIdentifier("JavaViewController") as JavaViewController
//        self.javaViewController = UINavigationController(rootViewController: javaViewController)
//        
//        let goViewController = storyboard.instantiateViewControllerWithIdentifier("GoViewController") as GoViewController
//        self.goViewController = UINavigationController(rootViewController: goViewController)
//        
//        let nonMenuController = storyboard.instantiateViewControllerWithIdentifier("NonMenuController") as NonMenuController
//        nonMenuController.delegate = self
//        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
//        self.tableView.registerCellClass(BaseTableViewCell.self)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_getNotification", name: "openShepardMode", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_goToMainScreen", name: kInvalidToken, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
//    func tableView(tableView: UITableView,  indexPath: NSIndexPath) -> CGFloat {
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cellID"
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellID)
        
        cell.textLabel?.text = menus[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        cell.imageView?.contentMode = UIViewContentMode.center
        cell.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section != 0) {
            return
        }
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func onExitButton(_ button: UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "closeMainController"), object: nil)
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            break
        case .search:
            self.slideMenuController()?.changeMainViewController(self.searchNavigationViewController, close: true)
            break
        case .order:
            self.slideMenuController()?.changeMainViewController(self.ordersNavigationControler, close: true)
            break
        case .settings:
            self.slideMenuController()?.changeMainViewController(self.settingsNavigationControler, close: true)
            break
        case .shepardsMode:
            break
        default:
            break
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (cell.respondsToSelector(Selector("tintColor"))){
//            if (tableView == self.tableView) {
//                let cornerRadius : CGFloat = 5.0
//                cell.backgroundColor = UIColor.clearColor()
//                var layer: CAShapeLayer = CAShapeLayer()
//                var pathRef:CGMutablePathRef = CGPathCreateMutable()
//                var bounds: CGRect = CGRectInset(cell.bounds, 5, 0)
//                var addLine: Bool = false
//                
//                if (indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
//                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius)
//                } else if (indexPath.row == 0) {
//                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius)
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
//                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
//                    addLine = true
//                } else if (indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
//                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius)
//                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
//                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
//                } else {
//                    CGPathAddRect(pathRef, nil, bounds)
//                    addLine = true
//                }
//                
//                layer.path = pathRef
//                layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).CGColor
//                layer.strokeColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).CGColor
//                
//                if (addLine == true) {
//                    var lineLayer: CALayer = CALayer()
//                    var lineHeight: CGFloat = (1.0 / UIScreen.mainScreen().scale)
//                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight)
//                    lineLayer.backgroundColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).CGColor
//                    layer.addSublayer(lineLayer)
//                }
//                var testView: UIView = UIView(frame: bounds)
//                testView.layer.insertSublayer(layer, atIndex: 0)
//                testView.backgroundColor = UIColor.clearColor()
//                cell.backgroundView = testView
//            }
//        }
//    }

// MARK: - InternalMethods -
    
    @IBAction func logoutButtonDidClicked(_ sender: UIButton)
    {
//        LogoutRequest().logoutRequestCompletionHandler({ () -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                NSNotificationCenter.defaultCenter().postNotificationName("logOut", object: nil);
//                self._goToMainScreen()
//                ()
//            }
//        }, errorHandler: { () -> Void in
//            
//        })
    }
}
