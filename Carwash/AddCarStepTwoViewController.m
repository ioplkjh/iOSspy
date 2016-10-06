//
//  AddCarStepTwoViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/10/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "AddCarStepTwoViewController.h"

#import "CarInfoTwoTableViewCell.h"
#import "GetAllCarModelRequet.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kCarInfoTwoTableViewCellID  @"carInfoTwoTableViewCellID"

@interface AddCarStepTwoViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *modelArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *bakUpModelArray;

//Popup
@property (weak, nonatomic) IBOutlet UIView *bgViewPopup;
@property (weak, nonatomic) IBOutlet UITextField *numberEnterTF;
@property (weak, nonatomic) IBOutlet UIView *tfView;

@property (weak, nonatomic) IBOutlet UIView *rootView;

@property (weak, nonatomic) IBOutlet UISearchBar *serchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation AddCarStepTwoViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self render];
    [self.view addSubview:self.bgViewPopup];
    [self loadCars];
    [self request];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}
-(void)render
{
    [self.tfView.layer setBorderWidth:1];
    [self.tfView.layer setBorderColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0].CGColor];
    [self.tfView.layer setCornerRadius:4];
    [self.tfView setClipsToBounds:YES];
    
    [self.rootView.layer setCornerRadius:4];
    [self.rootView setClipsToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bgViewPopup setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setTitle:@"МАРКА-МОДЕЛЬ-НОМЕР"];
    NSString *name = [NSString stringWithFormat:@"Pattern~%@", self.title];
    
    // The UA-XXXXX-Y tracker ID is loaded automatically from the
    // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
    // If you're copying this to an app just using Analytics, you'll
    // need to configure your tracking ID here.
    // [START screen_view_hit_objc]
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // [END screen_view_hit_objc]
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.bgViewPopup setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.modelArray[indexPath.row][@"model"];
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]} context:ctx];
    
    return textRect.size.height + 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoTwoTableViewCellID];
    [self configurationCarInfoTwoTableViewCell:cell index:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = indexPath.row;
    [self showViewEnterNumber];
}

- (void)configurationCarInfoTwoTableViewCell:(CarInfoTwoTableViewCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.modelArray[index];
    cell.carLabel.text = dict[@"model"];
    if(self.modelArray.count == index+1)
    {
                cell.bgView.hidden = YES;
    }
    else
    {
                cell.bgView.hidden = NO;
    }
}

-(void)showViewEnterNumber
{
    [self.bgViewPopup setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.numberEnterTF becomeFirstResponder];
}

-(void)loadCars
{
    self.modelArray = @[];
}
-(void)request
{
    [[GetAllCarModelRequet alloc] getAllCarsModelByIDBrand:@([self.brandCar[@"id"] integerValue]) completionHandler:^(NSDictionary *json)
    {
        self.modelArray = json[@"data"];
        self.bakUpModelArray = json[@"data"];
        [self.tableView reloadData];
    } errorHandler:^{
        
    }];
}

-(void)saveDataCarNo:(NSInteger)index
{
    NSString *brand = self.brandCar[@"brand"];
    NSString *model = self.modelArray[index][@"model"];
    NSString *brandID = self.brandCar[@"id"];
    NSString *modelID = self.modelArray[index][@"id"];
    NSString *car_category_id = self.modelArray[index][@"car_category_id"];
    //    if(self.numberEnterTF.text.length == 0)
    //    {
    //        self.numberEnterTF.text = @"";
    //        [self.numberEnterTF resignFirstResponder];
    //        [self.bgViewPopup setHidden:YES];
    //        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //        [self.navigationController setNavigationBarHidden:NO animated:YES];
    //        [self.tableView reloadData];
    //        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не правильно введен номер" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
    //        return;
    //    }
    //    else
    //    {
    [self.bgViewPopup setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.bgViewPopup removeFromSuperview];
    [self.numberEnterTF resignFirstResponder];
    //    }
    
    AppDelegate *appDel = SharedAppDelegate;
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.path];
    NSMutableArray *myCarsArray = [[savedStock objectForKey:@"MyCars"] mutableCopy];
    
    if(myCarsArray == nil)
        myCarsArray = [@[] mutableCopy];
    
    [myCarsArray addObject:@{
                             @"carBrand":brand,
                             @"carModel":model,
                             @"carNumber":@"",
                             @"carBrandID":brandID,
                             @"carModelID":modelID,
                             @"car_category_id":car_category_id
                             }];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: appDel.path];
    
    [data setObject:[myCarsArray copy] forKey:@"MyCars"];
    [data writeToFile: appDel.path atomically:YES];
    
    NSInteger indexI = 0;
    if(self.navigationController.viewControllers.count >= 3)
    {
        indexI = self.navigationController.viewControllers.count-3;
    }
    
    UIViewController *controller = self.navigationController.viewControllers[indexI];
    [self.navigationController popToViewController:controller animated:YES];
}

-(void)saveDataCar:(NSInteger)index
{
    NSString *brand = self.brandCar[@"brand"];
    NSString *model = self.modelArray[index][@"model"];
    NSString *brandID = self.brandCar[@"id"];
    NSString *modelID = self.modelArray[index][@"id"];
    NSString *car_category_id = self.modelArray[index][@"car_category_id"];
//    if(self.numberEnterTF.text.length == 0)
//    {
//        self.numberEnterTF.text = @"";
//        [self.numberEnterTF resignFirstResponder];
//        [self.bgViewPopup setHidden:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [self.tableView reloadData];
//        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не правильно введен номер" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
//        return;
//    }
//    else
//    {
        [self.bgViewPopup setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.bgViewPopup removeFromSuperview];
        [self.numberEnterTF resignFirstResponder];
//    }
    
    AppDelegate *appDel = SharedAppDelegate;
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.path];
    NSMutableArray *myCarsArray = [[savedStock objectForKey:@"MyCars"] mutableCopy];
    
    if(myCarsArray == nil)
        myCarsArray = [@[] mutableCopy];
    
    [myCarsArray addObject:@{
                             @"carBrand":brand,
                             @"carModel":model,
                             @"carNumber":self.numberEnterTF.text,
                             @"carBrandID":brandID,
                             @"carModelID":modelID,
                             @"car_category_id":car_category_id
                             }];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: appDel.path];
    
    [data setObject:[myCarsArray copy] forKey:@"MyCars"];
    [data writeToFile: appDel.path atomically:YES];
    
    NSInteger indexI = 0;
    if(self.navigationController.viewControllers.count >= 3)
    {
        indexI = self.navigationController.viewControllers.count-3;
    }
    
    UIViewController *controller = self.navigationController.viewControllers[indexI];
    [self.navigationController popToViewController:controller animated:YES];
}

- (IBAction)onNoButton:(id)sender
{
    [self saveDataCarNo:self.currentIndex];
}

- (IBAction)onDoneButton:(id)sender {
    
    [self saveDataCar:self.currentIndex];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        self.modelArray = [self.bakUpModelArray copy];
        [self.tableView reloadData];
        return;
    }
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"model contains[c] %@",searchText];
    self.modelArray = [self.bakUpModelArray filteredArrayUsingPredicate:pr];
    [self.tableView reloadData];
}

#pragma mark - Keyboard Notyfications Actions -

-(void)keyboardWillHide:(NSNotification*)notyfication
{
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.bottomConstraint.constant = 0;
         [self.view layoutIfNeeded];
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)keyboardWillShow:(NSNotification*)notyfication
{
    //reset all rect
    //    self.view.center = self.defaultViewCenter;
    
    NSDictionary *options = notyfication.userInfo;
    NSValue *keyBoardValue = options[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect   rectKeyboard  = keyBoardValue.CGRectValue;
    CGFloat offset = rectKeyboard.size.height;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.bottomConstraint.constant = offset;
         [self.view layoutIfNeeded];
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
