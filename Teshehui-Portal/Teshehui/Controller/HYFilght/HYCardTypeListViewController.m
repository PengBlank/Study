//
//  HYCardTypeListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCardTypeListViewController.h"
#import "HYCardTypeRequest.h"
#import "HYBaseLineCell.h"
#import "HYLoadHubView.h"
#import "HYUserInfo.h"
#import "METoast.h"

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
    
    [HYLoadHubView dismiss];
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
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:TFRectMakeFixHeight(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"选择证件类型";
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
    [HYLoadHubView show];
    
    _cardReqeust = [[HYCardTypeRequest alloc] init];
    _cardReqeust.applicationType = (UseForBuyInsourance == self.type) ? @"1":@"2";
    
    __weak typeof(self) b_self = self;
    [_cardReqeust sendReuqest:^(id result, NSError *error) {
        
        NSArray *cardList = nil;
        if (!error && [result isKindOfClass:[HYCardTypeResponse class]])
        {
            cardList = [(HYCardTypeResponse *)result cardList];
        }
        
        [b_self updateDataWithCardList:cardList error:error];
    }];
    
    /*
    if (_type == UseForPassenger)
    {
        
    }
    else
    {
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        
        HYCardType *card1 = [[HYCardType alloc] init];
        card1.certifacateCode = @"01";
        card1.certifacateName = @"身份证";
        [cards addObject:card1];
        
        HYCardType *card2 = [[HYCardType alloc] init];
        card2.certifacateCode = @"02";
        card2.certifacateName = @"护照";
        [cards addObject:card2];
        
        HYCardType *card3 = [[HYCardType alloc] init];
        card3.certifacateCode = @"03";
        card3.certifacateName = @"军人证";
        [cards addObject:card3];
        
        HYCardType *card4 = [[HYCardType alloc] init];
        card4.certifacateCode = @"05";
        card4.certifacateName = @"驾驶证";
        [cards addObject:card4];
        
        HYCardType *card5 = [[HYCardType alloc] init];
        card5.certifacateCode = @"06";
        card5.certifacateName = @"港澳回乡证或台胞证";
        [cards addObject:card5];
        
        HYCardType *card6 = [[HYCardType alloc] init];
        card6.certifacateCode = @"99";
        card6.certifacateName = @"其他";
        [cards addObject:card6];
        
        self.cardList = [cards copy];
        [self.tableView reloadData];
    }
     */
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
        [METoast toastWithMessage:error.domain];
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

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *nameCellId = @"nameCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCellId];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:nameCellId];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.row < [self.cardList count])
    {
        HYCardType *card = [self.cardList objectAtIndex:indexPath.row];
        cell.textLabel.text = card.certifacateName;
        
        if (self.selectedCard && [self.selectedCard.certifacateCode isEqualToString:card.certifacateCode])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
