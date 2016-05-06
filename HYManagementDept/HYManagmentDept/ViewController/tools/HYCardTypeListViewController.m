//
//  HYCardTypeListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCardTypeListViewController.h"
#import "HYCardTypeRequest.h"
#import "HYDataManager.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "UINavigationItem+Margin.h"

@interface HYCardTypeListViewController ()
{
    HYCardTypeRequest *_cardReqeust;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cardList;

@end

@implementation HYCardTypeListViewController

- (void)dealloc
{
    [_cardReqeust cancel];
    _cardReqeust = nil;
    
    [self hideLoadingView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _type = UseForPassenger;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorColor = [UIColor grayColor];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
//    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
//                                                                                   topCapHeight:0];
//    tableview.tableHeaderView = lineView;
    tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)backItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *back = [UIImage imageNamed:@"icon_back.png"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:back forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:backItem];
    
    [self loadCardInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        self.view = nil;
    }
}

#pragma mark private methods
- (void)loadCardInfo
{
    if (_type == UseForPassenger)
    {
        _cardReqeust = [[HYCardTypeRequest alloc] init];
        [HYLoadHubView show];
        
        HYUserInfo *user = [HYDataManager sharedManager].userInfo;
        _cardReqeust.user_id = user.user_id;
        
        __weak typeof(self) b_self = self;
        [_cardReqeust sendReuqest:^(id result, NSError *error) {
            NSArray *cardList = nil;
            if (!error && [result isKindOfClass:[HYCardTypeResponse class]])
            {
                cardList = [(HYCardTypeResponse *)result cardList];
            }
            
            [b_self updateDataWithCardList:cardList error:nil];
        }];
    }
    else
    {
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        
        HYCardType *card1 = [[HYCardType alloc] init];
        card1.card_id = 1;
        card1.card_name = @"身份证";
        [cards addObject:card1];
        
        HYCardType *card2 = [[HYCardType alloc] init];
        card2.card_id = 2;
        card2.card_name = @"护照";
        [cards addObject:card2];
        
        HYCardType *card3 = [[HYCardType alloc] init];
        card3.card_id = 3;
        card3.card_name = @"军人证";
        [cards addObject:card3];
        
        HYCardType *card4 = [[HYCardType alloc] init];
        card4.card_id = 5;
        card4.card_name = @"驾驶证";
        [cards addObject:card4];
        
        HYCardType *card5 = [[HYCardType alloc] init];
        card5.card_id = 6;
        card5.card_name = @"港澳回乡证或台胞证";
        [cards addObject:card5];
        
        HYCardType *card6 = [[HYCardType alloc] init];
        card6.card_id = 99;
        card6.card_name = @"其他";
        [cards addObject:card6];
        
        self.cardList = [cards copy];
        [self.tableView reloadData];
    }
}

- (void)updateDataWithCardList:(NSArray *)cardList error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        self.cardList = cardList;
        [self.tableView reloadData];
    }
    else
    {
        [METoast toastWithMessage:@"查询证件类型失败"];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

//- (void)tableView:(UITableView *)tableView
//  willDisplayCell:(UITableViewCell *)cell
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
//    if(indexPath.row == totalRow -1)
//    {
//        UITableViewCell *lineCell = (HYBaseLineCell *)cell;
//        lineCell.separatorLeftInset = 0.0f;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *nameCellId = @"nameCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:nameCellId];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.row < [self.cardList count])
    {
        HYCardType *card = [self.cardList objectAtIndex:indexPath.row];
        cell.textLabel.text = card.card_name;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCardtype:)])
    {
        if (indexPath.row < [self.cardList count])
        {
            HYCardType *card = [self.cardList objectAtIndex:indexPath.row];
            [self.delegate didSelectCardtype:card];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
