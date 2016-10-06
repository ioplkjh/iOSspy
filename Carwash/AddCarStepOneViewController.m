//
//  AddCarStepOneViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/10/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "AddCarStepOneViewController.h"
#import "CarInfoTableViewCell.h"
#import "AddCarStepTwoViewController.h"

#import "GetAllMarkCarsRequest.h"

#define kCarInfoTableViewCellID  @"carInfoTableViewCellID"

@interface AddCarStepOneViewController ()<UISearchBarDelegate>
@property (weak,   nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *carsArray;

@property (strong, nonatomic) NSArray *bakUpCarsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation AddCarStepOneViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCars];
    [self request];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"МАРКА-МОДЕЛЬ-НОМЕР"];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.carsArray[indexPath.row][@"brand"];
    NSStringDrawingContext *ctx = [NSStringDrawingContext new];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]} context:ctx];
    
    return textRect.size.height + 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCarInfoTableViewCellID];
    [self configurationCarInfoTableViewCell:cell index:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = self.carsArray[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MarkModelNumber" bundle:nil];
    AddCarStepTwoViewController *addCarStepTwoViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddCarStepTwoViewController"];
    [self setTitle:@" "];
    addCarStepTwoViewController.brandCar = dict;
    [self.navigationController pushViewController:addCarStepTwoViewController animated:YES];

}

- (void)configurationCarInfoTableViewCell:(CarInfoTableViewCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.carsArray[index];
    cell.carLabel.text = [NSString stringWithFormat:@"%@ (%@)",dict[@"brand"],dict[@"car_models_count"]];
    if(self.carsArray.count == index+1)
    {
        cell.bgView.hidden = YES;
    }
    else
    {
        cell.bgView.hidden = NO;
    }
}

-(void)loadCars
{
    self.carsArray = @[];
}

-(void)request
{
    [[GetAllMarkCarsRequest alloc] getAllMarkCarsRequestWithCompletionHandler:^(NSDictionary *json)
    {
        self.carsArray = json[@"data"];
        self.bakUpCarsArray = json[@"data"];
        [self.tableView reloadData];
    } errorHandler:^(NSDictionary *error){
        
    }];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        self.carsArray = [self.bakUpCarsArray copy];
        [self.tableView reloadData];
        return;
    }
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"brand contains[c] %@",searchText];
    self.carsArray = [self.bakUpCarsArray filteredArrayUsingPredicate:pr];
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
