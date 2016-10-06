//
//  CommentsViewController.m
//  Carwash
//
//  Created by Andrei Sabinin on 9/13/15.
//  Copyright (c) 2015 Empty. All rights reserved.
//

#import "CommentsViewController.h"

#import "CloseTableViewCell.h"
#import "OpenTableViewCell.h"
#import "HCSStarRatingView.h"

#import "GetAllCommentsRequest.h"

#define kCloseTableViewCellID @"closeTableViewCellID"
#define kOpenTableViewCellID  @"openTableViewCellID"

@interface CommentsViewController ()
@property (nonatomic, strong) NSArray *commentsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Отзывы"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.commentsArray[indexPath.row];
    BOOL isOpen = [dict[@"isOpen"] integerValue];
    if(isOpen)
    {
        NSString *textComment = dict[@"text"];
        NSString *textAnswer  = dict[@"answer"];

        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        CGRect textRectComment = [textComment boundingRectWithSize:CGSizeMake(self.view.frame.size.width-48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:ctx];
        
        CGRect textRectAnswer  = [textAnswer boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:ctx];
        
        CGFloat textRectCommentHeight = textRectComment.size.height;
        CGFloat textRectAnswerHeight  = textRectAnswer.size.height;

        return  textRectCommentHeight + textRectAnswerHeight + 30;
    }
    else
    {
        return 60;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.commentsArray[indexPath.row];
    BOOL isOpen = [dict[@"isOpen"] integerValue];
    if(isOpen)
    {
        OpenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOpenTableViewCellID];
        [self configurationOpenCell:cell index:indexPath.row];
        return cell;
    }
    else
    {
        CloseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCloseTableViewCellID];
        [self configurationCloseCell:cell index:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.commentsArray[indexPath.row];
    BOOL isOpen = [dict[@"isOpen"] integerValue];
    if(!isOpen)
    {
        [self setCellOpen:indexPath.row];
    }
    else
    {
        [self setCellClose:indexPath.row];
    }
}

- (void)configurationOpenCell:(OpenTableViewCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.commentsArray[index];
    cell.commentLabel.text = dict[@"text"];
    cell.commentLabel.numberOfLines = NSIntegerMax;
    cell.answerLabel.text =  dict[@"answer"];
    cell.answerLabel.numberOfLines = NSIntegerMax;
    cell.ratingView.value =  [dict[@"answer"] doubleValue];
    cell.nameAndCarLabel.text = [NSString stringWithFormat:@"%@, %@ %@",dict[@"phone"],dict[@"carBrand"],dict[@"carModel"]];
}

- (void)configurationCloseCell:(CloseTableViewCell*)cell index:(NSInteger)index
{
    NSDictionary *dict = self.commentsArray[index];
    cell.commentLabel.text = dict[@"text"];
    cell.answerLabel.text =  dict[@"answer"];
    cell.ratingView.value =  [dict[@"answer"] doubleValue];
    cell.nameAndCarLabel.text = [NSString stringWithFormat:@"%@, %@ %@",dict[@"phone"],dict[@"carBrand"],dict[@"carModel"]];}

-(void)setCellOpen:(NSInteger)index
{
    NSMutableArray *mutArray = [self.commentsArray mutableCopy];
    NSMutableDictionary *mutDict = [[mutArray objectAtIndex:index] mutableCopy];
    mutDict[@"isOpen"] = @1;
    [mutArray replaceObjectAtIndex:index withObject:[mutDict copy]];
    self.commentsArray = [mutArray copy];
    [self.tableView reloadData];
}

-(void)setCellClose:(NSInteger)index
{
    NSMutableArray *mutArray = [self.commentsArray mutableCopy];
    NSMutableDictionary *mutDict = [[mutArray objectAtIndex:index] mutableCopy];
    mutDict[@"isOpen"] = @0;
    [mutArray replaceObjectAtIndex:index withObject:[mutDict copy]];
    self.commentsArray = [mutArray copy];
    [self.tableView reloadData];
}

-(void)request
{
    self.commentsArray = [@[] copy];
    [[GetAllCommentsRequest alloc] getAllCommentsByIDWash:@([self.washID integerValue]) completionHandler:^(NSDictionary *json)
    {
        NSArray *comments = json[@"data"];
        if(comments.count)
        {
            [self setupCommentsArray:comments];
        }
        [self.tableView reloadData];
    } errorHandler:^{
        
    }];
}

-(void)setupCommentsArray:(NSArray*)commentsArr
{
    NSMutableArray *mutableComments = [@[] mutableCopy];
    
    for (NSDictionary *dict in commentsArr)
    {
        NSDictionary *dictNew = @{
                                  @"text":dict[@"text"],
                                  @"answer":dict[@"answer"],
                                  @"phone":dict[@"client_phone"],
                                  @"isOpen":@0,
                                  @"carBrand":dict[@"client_car"][@"brand"],
                                  @"carModel":dict[@"client_car"][@"model"],
                                  @"carNumber":dict[@"client_car"][@"gos_number"]
                                  };
        
        [mutableComments addObject:dictNew];
    }
    
    self.commentsArray = [mutableComments copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end