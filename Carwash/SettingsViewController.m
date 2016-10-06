//
//  SettingsViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/5/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "SettingsViewController.h"
#import "Carwash-Swift.h"
#import "AddCarStepOneViewController.h"

//Cells
#import "SwithCell.h"
#import "DataConfirmCell.h"
#import "BotSectionButtonCell.h"
#import "UserCarsCell.h"

#define kSwitchAutoRegisterCell                0
#define kSwitchSaveCarFromPastOrderCell        1
#define kSwitchSaveListOfServicesCell          2

#define kDataConfirmCell   3

#define kSwitchCellID        @"switchCellID"
#define kDataConfirmCellID   @"dataConfirmCellID"

#define kUserCarCellID                @"userCarsCellID"
#define kBotSectionButtonCellID       @"botSectionButtonCellID"


#define kOffsetRegistrationDifferens        is_4_inch() ? 120.f : 100.f

CG_INLINE BOOL is_4_inch()
{
    if( 568.f <= [ UIScreen mainScreen ].bounds.size.height )
        return YES;
    return NO;
}

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,SwithCellDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isEnableAuroRegister;
@property (nonatomic, assign) BOOL isEnableSaveCarFromPastOrder;
@property (nonatomic, assign) BOOL isEnableSaveListOfServices;

//From Cell
@property (nonatomic, strong) UITextField *textFieldName;
@property (assign, nonatomic) CGPoint defaultViewCenter;


//Values
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userLocation;

@property (nonatomic, strong) NSMutableArray *myCarrArray;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation SettingsViewController

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData];
    self.title = @"НАСТРОЙКИ";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self  setDefaultViewCenter:self.view.center];
    [self  setNavigationBarItem];
}

-(void)setupData
{
    //Чтение машин из файла
    AppDelegate *appDel = SharedAppDelegate;
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.path];
    
    NSArray *myCarsArray = [savedStock objectForKey:@"MyCars"];
    self.myCarrArray = myCarsArray;
    
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    self.isEnableAuroRegister           = [settings boolForKey:@"isEnableAuroRegister"        ];
    self.isEnableSaveCarFromPastOrder   = [settings boolForKey:@"isEnableSaveCarFromPastOrder"];
    self.isEnableSaveListOfServices     = [settings boolForKey:@"isEnableSaveListOfServices"  ];
    
    self.userName       = [settings stringForKey:@"UserName"].length ? [settings stringForKey:@"UserName"] : @"";
    self.userLocation   = [settings stringForKey:@"userLocation"].length ? [settings stringForKey:@"userLocation"] : @"Выберите область";
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kSwitchAutoRegisterCell:
        {
            return 56;
            break;
        }
        case kSwitchSaveCarFromPastOrderCell:
        {
            return 56;
            break;
        }
        case kSwitchSaveListOfServicesCell:
        {
            return 56;
            break;
        }
        case kDataConfirmCell:
        {
            return  148;
            break;
        }
        default:
        {
            if(indexPath.row >= 4)
            {
                NSInteger countAll = self.myCarrArray.count+4;
                if(indexPath.row == countAll)
                {
                    return 126;
                    //+ Последняя статическая
                }
                else
                {
                    return 50;
                    //Динамический подсчет
                }

            }
            else
            {
                return 0;
            }
            break;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+(self.myCarrArray.count)+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kSwitchAutoRegisterCell:
        {
            SwithCell *cell = [tableView dequeueReusableCellWithIdentifier:kSwitchCellID];
            [self configurationSwithCell:cell index:indexPath.row status:self.isEnableAuroRegister];
            return cell;
            break;
        }
        case kSwitchSaveCarFromPastOrderCell:
        {
            SwithCell *cell = [tableView dequeueReusableCellWithIdentifier:kSwitchCellID];
            [self configurationSwithCell:cell index:indexPath.row status:self.isEnableSaveCarFromPastOrder];
            return cell;
            break;
        }
        case kSwitchSaveListOfServicesCell:
        {
            SwithCell *cell = [tableView dequeueReusableCellWithIdentifier:kSwitchCellID];
            [self configurationSwithCell:cell index:indexPath.row status:self.isEnableSaveListOfServices];
            return cell;
            break;
        }
        case kDataConfirmCell:
        {
            DataConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:kDataConfirmCellID];
            [self configurationDataConfirmCell:cell];
            return cell;
            break;
        }
        default:
        {
            if(indexPath.row >= 4 && indexPath.row < (4+self.myCarrArray.count+1))
            {
                NSInteger countAll = self.myCarrArray.count+4;
                if(indexPath.row == countAll)
                {
                    BotSectionButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kBotSectionButtonCellID];
                    [self configurationBotSectionButtonCell:cell];
                    return cell;
                }
                else
                {
                    UserCarsCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCarCellID];
                    [self configurationUserCarsCell:cell index:indexPath.row-4];
                    return cell;
                    //Динамический подсчет
                }
            }
            else
            {
                return nil;
            }
            break;
        }
    }
    return nil;
}

-(void)changeSwitchValue:(UISwitch*)switchValue
{
    NSInteger tag = switchValue.tag;
    switch (tag)
    {
        case kSwitchAutoRegisterCell:
        {
            self.isEnableAuroRegister           = switchValue.on;
            break;
        }
        case kSwitchSaveCarFromPastOrderCell:
        {
            self.isEnableSaveCarFromPastOrder   = switchValue.on;
            break;
        }
        case kSwitchSaveListOfServicesCell:
        {
            self.isEnableSaveListOfServices     = switchValue.on;
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textFieldName resignFirstResponder];
}

#pragma mark - Configurator TableView Cells -

-(void)configurationSwithCell:(SwithCell*)switchCell index:(NSInteger)index status:(BOOL)status
{
    switch (index)
    {
        case kSwitchAutoRegisterCell:
        {
            [switchCell.labelSwitch setNumberOfLines:2];
            [switchCell.labelSwitch setText:@"Авторегистрация \nпри запуске приложения"];
            [switchCell.switcher setTag:kSwitchAutoRegisterCell];
            [switchCell.switcher setOn:self.isEnableAuroRegister];
            [switchCell setDelegate:self];
            break;
        }
        case kSwitchSaveCarFromPastOrderCell:
        {
            [switchCell.labelSwitch setNumberOfLines:2];
            [switchCell.labelSwitch setText:@"Запоминание машины \nиз предыдущего заказа"];
            [switchCell.switcher setTag:kSwitchSaveCarFromPastOrderCell];
            [switchCell.switcher setOn:self.isEnableSaveCarFromPastOrder];
            [switchCell setDelegate:self];
            break;
        }
        case kSwitchSaveListOfServicesCell:
        {
            [switchCell.lineView setHidden:YES];
            [switchCell.labelSwitch setNumberOfLines:2];
            [switchCell.labelSwitch setText:@"Запоминание списка услуг \nиз предыдущего заказа"];
            [switchCell.switcher setTag:kSwitchSaveListOfServicesCell];
            [switchCell.switcher setOn:self.isEnableSaveListOfServices];
            [switchCell setDelegate:self];
            break;
        }
        default:
        {
            break;
        }
    }
}

-(void)configurationDataConfirmCell:(DataConfirmCell*)dataConfirmCell
{
     dataConfirmCell.topTextField.text = self.userName;
     dataConfirmCell.botLabel.text     = self.userLocation;
    self.textFieldName = dataConfirmCell.topTextField;
    self.textFieldName.delegate = self;
}

-(void)configurationUserCarsCell:(UserCarsCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.myCarrArray[index];
    [cell.deleteButton setTag:index];
    [cell.deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.carLabel.text = [NSString stringWithFormat:@"%@, %@", dict[@"carBrand"],dict[@"carModel"]];
    if(self.myCarrArray.count == index+1)
    {
//        cell.underView.hidden = YES;
    }
    else
    {
//        cell.underView.hidden = NO;
    }
}

-(void)configurationBotSectionButtonCell:(BotSectionButtonCell*)botSectionButtonCell
{
    [botSectionButtonCell.myCarButton addTarget:self action:@selector(onAddMyCarButton:) forControlEvents:UIControlEventTouchUpInside];
    [botSectionButtonCell.saveButton addTarget:self action:@selector(onSaveButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    self.userName = [NSString stringWithFormat:@"%@%@",textField.text,string];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.userName = textField.text;
}

-(void)onAddMyCarButton:(UIButton*)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MarkModelNumber" bundle:nil];
    AddCarStepOneViewController *addCarStepOneViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddCarStepOneViewController"];
    [self setTitle:@" "];
    [self.navigationController pushViewController:addCarStepOneViewController animated:YES];

}

-(void)onDeleteButton:(UIButton*)button
{
    NSInteger index = button.tag;
    AppDelegate *appDel = SharedAppDelegate;
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.path];
    NSMutableArray *myCarsArray = [[savedStock objectForKey:@"MyCars"] mutableCopy];
    NSDictionary *car = [myCarsArray objectAtIndex:index];
    self.currentIndex = index;
    [self deleteConfirm:[NSString stringWithFormat:@"%@, %@", car[@"carBrand"],car[@"carModel"]]];
}
-(void)deleteConfirm:(NSString*)car
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Настройки" message:[NSString stringWithFormat:@"Удалить %@ из гаража?",car] delegate:self cancelButtonTitle:@"Нет" otherButtonTitles: @"Да",nil];
    [alertView setTag:0xdd];
    [alertView show];
}

-(void)onSaveButton:(UIButton*)button
{
    //GetText
    self.userName = self.textFieldName.text;
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    [settings setBool:self.isEnableAuroRegister         forKey:@"isEnableAuroRegister"          ];
    [settings setBool:self.isEnableSaveCarFromPastOrder forKey:@"isEnableSaveCarFromPastOrder"  ];
    [settings setBool:self.isEnableSaveListOfServices   forKey:@"isEnableSaveListOfServices"    ];
    
    [settings setValue:self.userName     forKey:@"UserName"    ];
    [settings setValue:self.userLocation forKey:@"userLocation"];
    
    [settings synchronize];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Настройки" message:@"Успешно сохранено" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
    [alertView show];
}


#pragma mark - Keyboard Notyfications Actions -

-(void)keyboardWillHide:(NSNotification*)notyfication
{
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = self.defaultViewCenter;
//         self.logoImageView.alpha = 1.0;
         //         if(!is_4_inch())
         //             self.stepImageView.alpha = 1.0;
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
    CGFloat offset = kOffsetRegistrationDifferens;
    CGFloat  keyboardSlideOffset = rectKeyboard.size.height - offset;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:
     ^{
         self.view.center = CGPointMake(self.defaultViewCenter.x, self.defaultViewCenter.y - keyboardSlideOffset);
//         self.logoImageView.alpha = 0.0;
         //         if(!is_4_inch())
         //             self.stepImageView.alpha = 0.0;
         
     } completion:^(BOOL finished)
     {
         //empty
     }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0xdd)
    {
        if(buttonIndex == 1)
        {
            NSInteger index = self.currentIndex;
            AppDelegate *appDel = SharedAppDelegate;
            NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:appDel.path];
            NSMutableArray *myCarsArray = [[savedStock objectForKey:@"MyCars"] mutableCopy];
            [myCarsArray removeObjectAtIndex:index];
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: appDel.path];
            [data setObject:[myCarsArray copy] forKey:@"MyCars"];
            [data writeToFile: appDel.path atomically:YES];
            
            [self setupData];
            [self.tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
