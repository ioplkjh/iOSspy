//
//  OunCarsViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/10/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "OunCarsViewController.h"
#import "CarOunTableViewCell.h"
#import "AddCarStepOneViewController.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


#define kCarOunTableViewCellID @"carOunTableViewCellID"

#define minCellHeight 35

@interface OunCarsViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myCarsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) NSArray *bakUpCarsArray;

@end

@implementation OunCarsViewController

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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCars];
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

-(void)render
{
    [self.addCarButton.layer setBorderWidth:2];
    [self.addCarButton.layer setBorderColor:[UIColor colorWithRed:61.0/255.0 green:177.0/255.0 blue:173.0/255.0 alpha:1.0].CGColor];
    [self.addCarButton.layer setCornerRadius:4];
    [self.addCarButton setClipsToBounds:YES];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.myCarsArray[indexPath.row][@"carModel"];
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]} context:ctx];
    
    return textRect.size.height + minCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myCarsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarOunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarOunTableViewCellID];
    [self configurationCarOunTableViewCell:cell index:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.myCarsArray[indexPath.row];
    self.currentCar[@"model"]  = dict[@"carModel"];
    self.currentCar[@"brand"]  = dict[@"carBrand"];
    self.currentCar[@"number"] = dict[@"carNumber"];
    self.currentCar[@"carBrandID"]     = dict[@"carBrandID"];
    self.currentCar[@"carModelID"]     = dict[@"carModelID"];
    self.currentCar[@"car_category_id"]  = dict[@"car_category_id"];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if([settings boolForKey:@"isEnableSaveCarFromPastOrder"])
    {
        [settings setBool:YES forKey:@"isHaveCar"];
        [settings setObject:self.currentCar forKey:@"RememberCar"];
        [settings synchronize];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configurationCarOunTableViewCell:(CarOunTableViewCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.myCarsArray[index];
    cell.carLabel.text = [NSString stringWithFormat:@"%@, %@", dict[@"carBrand"],dict[@"carModel"]];
    if(self.myCarsArray.count == index+1)
    {
        cell.underView.hidden = YES;
    }
    else
    {
        cell.underView.hidden = NO;
    }
}

- (IBAction)onAddCarButton:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MarkModelNumber" bundle:nil];
    AddCarStepOneViewController *addCarStepOneViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddCarStepOneViewController"];
    [self setTitle:@" "];
    [self.navigationController pushViewController:addCarStepOneViewController animated:YES];
}

-(void)loadCars
{
    AppDelegate *appDel = SharedAppDelegate;
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.path];
    
    NSArray *myCarsArray = [savedStock objectForKey:@"MyCars"];
    self.myCarsArray = myCarsArray;
    self.bakUpCarsArray = [myCarsArray copy];
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        self.myCarsArray = [self.bakUpCarsArray copy];
        [self.tableView reloadData];
        return;
    }
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"carBrand contains[c] %@ OR carModel contains[c] %@",searchText,searchText];
    self.myCarsArray = [self.bakUpCarsArray filteredArrayUsingPredicate:pr];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
