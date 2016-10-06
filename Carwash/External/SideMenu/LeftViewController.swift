//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case Main = 0
    case Payment
    case History
    case Help
    case ShepardsMode
}

enum ActionSheetMenu: Int {
    case Cancel = 0
    case TakePhoto
    case GetWithLibrary
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ShepardModeTableViewCellDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    let picker = UIImagePickerController()
    
    var menus = ["Search bike", "Payment", "History", "Terms"]
    var mainViewController: UIViewController!
    var searchBykeViewController: UIViewController!
    var managerCardViewController: UIViewController!
    var helpViewController: UIViewController!
    var historyViewController: UIViewController!
    var historyShepardViewController: UIViewController!
    var shepardsModeViewController: UIViewController!
//    var nonMenuViewController: UIViewController!
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self

//        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchBykeViewController = storyboard.instantiateViewControllerWithIdentifier("SearchBykeViewController") as! SearchBykeViewController
        self.searchBykeViewController = UINavigationController(rootViewController: searchBykeViewController)

        storyboard = UIStoryboard(name: "ManagerCards", bundle: nil)
        let managerCardViewController = storyboard.instantiateViewControllerWithIdentifier("ManagerCardNavigationController") as! UINavigationController
        self.managerCardViewController = managerCardViewController

        storyboard = UIStoryboard(name: "Help", bundle: nil)
        let helpViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForHelpViewController") as! UINavigationController
        self.helpViewController = helpViewController

        storyboard = UIStoryboard(name: "History", bundle: nil)
        let historyViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForHistoryViewController") as! UINavigationController
        self.historyViewController = historyViewController
        
        storyboard = UIStoryboard(name: "History", bundle: nil)
        let historyShepardViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForHistoryShepardViewController") as! UINavigationController
        self.historyShepardViewController = historyShepardViewController
        
        storyboard = UIStoryboard(name: "ShepardsMode", bundle: nil)
        let shepardsModeViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationForShepardsModeViewController") as! UINavigationController
        self.shepardsModeViewController = shepardsModeViewController

        
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
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_getNotification", name: "openShepardMode", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_goToMainScreen", name: kInvalidToken, object: nil)
    }
    
    func _getNotification() {
        DBUserManager.sharedManager().user.isShepard = true
        DBUserManager.sharedManager().user.isActiveShepard = true
        self.activeShepardMode(true)
    }
    
    func _goToMainScreen() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "auth")
            NSUserDefaults.standardUserDefaults().synchronize()
            DBUserManager.sharedManager().cleanData()
            self.avatarImage?.image = UIImage(named: "defaultAvatar")
            self.navigationController?.popToRootViewControllerAnimated(false)
        });
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.usernameLabel?.text = DBUserManager.sharedManager().user.userName
        self._checkImage()
        self.tableView.reloadData();
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if (DBUserManager.sharedManager().user.isShepard) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menus.count
        } else {
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        switch (indexPath.section)
        {
            case 0:
                cell = self._sectionOne(tableView, cellForRowAtIndexPath: indexPath)  as UITableViewCell
                break;

            case 1:
                cell = self._sectionTwo(tableView, cellForRowAtIndexPath: indexPath) as UITableViewCell
                break;

            default:
                break;
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section != 0) {
            return
        }
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            if (DBUserManager.sharedManager().user.isActiveShepard) {
                self.slideMenuController()?.changeMainViewController(self.shepardsModeViewController, close: true)    
            } else {
                self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            }
            
            break
        case .Payment:
            self.slideMenuController()?.changeMainViewController(self.managerCardViewController, close: true)
            break
        case .Help:
            self.slideMenuController()?.changeMainViewController(self.helpViewController, close: true)
            break
        case .History:
            
            if (DBUserManager.sharedManager().user.isActiveShepard) {
            self.slideMenuController()?.changeMainViewController(self.historyShepardViewController, close: true)
            } else {
            self.slideMenuController()?.changeMainViewController(self.historyViewController, close: true)
            }
            

            break

        case .ShepardsMode:
            self.slideMenuController()?.changeMainViewController(self.shepardsModeViewController, close: true)
            break

        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (cell.respondsToSelector(Selector("tintColor"))){
            if (tableView == self.tableView) {
                let cornerRadius : CGFloat = 5.0
                cell.backgroundColor = UIColor.clearColor()
                var layer: CAShapeLayer = CAShapeLayer()
                var pathRef:CGMutablePathRef = CGPathCreateMutable()
                var bounds: CGRect = CGRectInset(cell.bounds, 5, 0)
                var addLine: Bool = false
                
                if (indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius)
                } else if (indexPath.row == 0) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius)
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
                    addLine = true
                } else if (indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius)
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
                } else {
                    CGPathAddRect(pathRef, nil, bounds)
                    addLine = true
                }
                
                layer.path = pathRef
                layer.fillColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).CGColor
                layer.strokeColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).CGColor
                
                if (addLine == true) {
                    var lineLayer: CALayer = CALayer()
                    var lineHeight: CGFloat = (1.0 / UIScreen.mainScreen().scale)
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight)
                    lineLayer.backgroundColor = UIColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).CGColor
                    layer.addSublayer(lineLayer)
                }
                var testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, atIndex: 0)
                testView.backgroundColor = UIColor.clearColor()
                cell.backgroundView = testView
            }
        }
    }

// MARK: - InternalMethods -
    
    func _sectionOne(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: BaseTableViewCell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        
        cell.backgroundColor = UIColor(red: 1, green: 171, blue: 1, alpha: 1.0)
        cell.textLabel?.text = NSLocalizedString(menus[indexPath.row], tableName: nil, bundle: NSBundle.mainBundle(), value: menus[indexPath.row], comment: "")
        
        switch menus[indexPath.row] {
        case "Search bike":
            if (DBUserManager.sharedManager().user.isActiveShepard) {
                cell.textLabel?.text = NSLocalizedString("My Bikes", tableName: nil, bundle: NSBundle.mainBundle(), value: "My Bikes", comment: "")
            } else if (DBUserManager.sharedManager().user.isRiding) {
                cell.textLabel?.text = NSLocalizedString("Ride", tableName: nil, bundle: NSBundle.mainBundle(), value: "Ride", comment: "")
            }
            
            cell.imageView?.image = UIImage(named: "search")
            break;
            
        case "Payment":
            cell.imageView?.image = UIImage(named: "card")
            break;
            
        case "History":
            cell.imageView?.image = UIImage(named: "clock_history")
            break;
            
        case "Terms":
            cell.imageView?.image = UIImage(named: "help")
            break;
            
        default:
            break;
        }
        
        return cell
    }
    
    func _sectionTwo(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:ShepardModeTableViewCell = tableView.dequeueReusableCellWithIdentifier("shepardModeCell") as! ShepardModeTableViewCell
        
        cell.delegate = self
        cell.backgroundColor = UIColor(red: 1, green: 171, blue: 1, alpha: 1.0)
        cell.nameLabel?.text = "ShepardMode"
        cell.shepardModeSwitcher.on = DBUserManager.sharedManager().user.isActiveShepard
        return cell
    }

    func _uploadPhoto(image: UIImage)
    {
        UploadPhotoRequest().uploadPhotoRequest(image, completionHandler: { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                DBUserManager.sharedManager().user.avatarImage = image
                self._checkImage()
                ()
            }
        }) { () -> Void in
            
        }
    }
    
    func _checkImage()
    {
        if ((DBUserManager.sharedManager().user.avatarImage) != nil) {
            self.avatarImage?.image = DBUserManager.sharedManager().user.avatarImage
            self.avatarButton.hidden = true
        }
    }
    
// MARK: - IBAction -
    
    @IBAction func logoutButtonDidClicked(sender: UIButton)
    {
        LogoutRequest().logoutRequestCompletionHandler({ () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName("logOut", object: nil);
                self._goToMainScreen()
                ()
            }
        }, errorHandler: { () -> Void in
            
        })
    }
    
    @IBAction func setNewAvatarButtonDidClicked(sender: AnyObject)
    {
        var actionSheet : UIActionSheet = UIActionSheet(title: NSLocalizedString("Set Picture", tableName: nil, bundle: NSBundle.mainBundle(), value: "Set Picture", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("Cancel", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: ""), destructiveButtonTitle: nil, otherButtonTitles:NSLocalizedString("Take a photo", tableName: nil, bundle: NSBundle.mainBundle(), value: "Take a photo", comment: ""), NSLocalizedString("Choose from gallery", tableName: nil, bundle: NSBundle.mainBundle(), value: "Choose from gallery", comment: ""))
        actionSheet.delegate = self
        actionSheet.showInView(self.view)
    }
    
//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismissViewControllerAnimated(true, completion: nil)
        self._uploadPhoto(self .correctlyOrientedImage(chosenImage))
    }
    
    func correctlyOrientedImage(image : UIImage) -> UIImage {
        if image.imageOrientation == UIImageOrientation.Up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        var normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UIActionSheetDelegate -
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if let num = ActionSheetMenu(rawValue: buttonIndex)
        {
            switch num {
            case .Cancel:
                
                break;
                
            case .TakePhoto:
                var picker : UIImagePickerController = UIImagePickerController()
                picker.sourceType = .Camera
                picker.delegate = self
                picker.allowsEditing = false
                self.presentViewController(picker, animated: true, completion: nil)
                break;
                
            case .GetWithLibrary:
                picker.allowsEditing = false //2
                picker.sourceType = .PhotoLibrary //3
                presentViewController(picker, animated: true, completion: nil)
                
                break;
                
            default:
                break;
            }
        }
    }
    
    // MARK : - ShepardModeTableViewCellDelegate -
    
    func activeShepardMode(active: Bool) {
        
        if(self.slideMenuController()?.mainViewController == self.historyViewController || self.slideMenuController()?.mainViewController == self.historyShepardViewController)
        {
            DBUserManager.sharedManager().pushForUserId = nil
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            if active {
                self.slideMenuController()?.changeMainViewController(self.historyShepardViewController, close: false)
            } else {
                self.slideMenuController()?.changeMainViewController(self.historyViewController, close: false)
            }
        }
        else
        {
            DBUserManager.sharedManager().pushForUserId = nil
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            if active {
                self.slideMenuController()?.changeMainViewController(self.shepardsModeViewController, close: false)
            } else {
                self.slideMenuController()?.changeMainViewController(self.mainViewController, close: false)
            }
        }
    }
}