//
//  HYBankViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBankViewController.h"
#import "HYBaseLineCell.h"

@interface HYBankViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *bankList;

@end

@implementation HYBankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v= [[UIView alloc] initWithFrame:CGRectZero];
    tableview.tableHeaderView = v;
    tableview.rowHeight = 44.0f;
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"select_bank_info", nil);
    [self loadBankData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods
- (void)loadBankData
{
    if (!_bankList)
    {
        NSDictionary *banks = @{@"中国银行-信用卡":@"553",
                                @"中国工商银行-信用卡":@"2",
                                @"中国交通银行-信用卡":@"3",
                                @"中国农业银行-信用卡":@"556",
                                @"中国建设银行-信用卡":@"557",
                                @"中国招商银行-信用卡":@"11",
                                @"广东发展银行-信用卡":@"559",
                                @"中国光大银行-信用卡":@"560",
                                @"中国民生银行-信用卡":@"561",
                                @"中信银行-信用卡":@"562",
                                @"浦发银行-信用卡":@"563",
                                @"兴业银行-信用卡":@"564",
                                @"上海银行-信用卡":@"565",
                                @"深圳发展/平安银行-信用卡":@"566",
                                @"华夏银行-信用卡":@"567",
                                @"宁波银行-信用卡":@"568",
                                @"东亚银行-信用卡":@"569",
                                @"北京银行-信用卡":@"570",
                                @"江苏银行-信用卡":@"571",
                                @"运通-信用卡":@"8",
                                @"JCB-信用卡":@"10",
                                @"万事达(Master)-信用卡":@"6",
                                @"威士(VISA)-信用卡":@"7"};
        
        NSMutableArray *bankList = [[NSMutableArray alloc] init];
        for (NSString *key in banks)
        {
            HYCreditCardInfo *bank = [[HYCreditCardInfo alloc] init];
            bank.bankName = key;
            bank.bankId = [banks objectForKey:key];
            [bankList addObject:bank];
        }
        
        self.bankList = [bankList copy];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bankList count];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderSummaryCellId = @"orderSummaryCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSummaryCellId];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:orderSummaryCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.bankList count])
    {
        HYCreditCardInfo *bank = [self.bankList objectAtIndex:indexPath.row];
        cell.textLabel.text = bank.bankName;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectBankInfo:)])
    {
        if (indexPath.row < [self.bankList count])
        {
            HYCreditCardInfo *bank = [self.bankList objectAtIndex:indexPath.row];
            [self.delegate didSelectBankInfo:bank];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/**
 1	中国银行 -- 长城卡
 2	中国工商银行－信用卡
 3	中国交通银行 -- 信用卡（贷记卡）
 4	中国农业银行-信用卡
 5	中国建设银行 -- 信用卡（贷记卡）[有纪录]
 6	境外发行信用卡 -- 万事达(Master)
 7	境外发行信用卡 -- 威士(VISA)
 8	境外发行信用卡 -- 运通(AMEX)
 9	境外发行信用卡 -- 大来(Diners Club)
 10	境外发行信用卡 -- JCB
 11	中国招商银行 -- 信用卡[有纪录]
 13	广东发展银行 -- 信用卡
 15	中国光大银行 -- 阳光卡
 16	中国民生银行 -- 信用卡
 17	中信银行 -- 信用卡
 18	上海浦东发展银行 -- 信用卡
 20	兴业银行 -- 信用卡
 21	上海银行 -- 信用卡
 22	深圳平安银行--平安万里通信用卡
 24	华夏银行 -- 信用卡
 25	宁波银行 -- 信用卡
 26	东亚银行 -- 信用卡
 27	北京银行 -- 信用卡
 28	江苏银行--信用卡
 500	 信用卡(银联)-非标准
*/