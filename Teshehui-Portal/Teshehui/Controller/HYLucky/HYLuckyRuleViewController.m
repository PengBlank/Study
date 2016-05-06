//
//  HYLuckyRuleViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyRuleViewController.h"
#import "HYLuckyRuleCell.h"
#import "UIImage+Addition.h"
#import "HYLuckyListReq.h"

@interface HYLuckyRuleViewController ()
{
    HYLuckyListReq *_loadLuckyListReq;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYLuckyRuleViewController

- (void)dealloc
{
    [_loadLuckyListReq cancel];
    _loadLuckyListReq = nil;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    self.view = view;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:rect];
    [self.view addSubview:bgView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageWithNamedAutoLayout:@"lucky_rule"]];
    if (rect.size.height <= 416)
    {
        rect = TFRectMake(30, 88, 260, rect.size.height-144);
        [titleView setFrame:TFRectMake(110, 48, 99, 24)];
        bgView.image = [UIImage imageWithNamedAutoLayout:@"lucky_bg_3_3_5"];
    }
    else
    {
        rect = TFRectMake(30, 68, 260, 385);
        [titleView setFrame:TFRectMake(110, 36, 99, 24)];
        bgView.image = [UIImage imageWithNamedAutoLayout:@"lucky_bg_3"];
    }
    
    [self.view addSubview:titleView];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:rect
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:TFRectMake(0, 0, 320, 0)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"*本活动与苹果公司无关";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame)-10, 30)];
    label.frame = CGRectMake(CGRectGetMidX(self.view.frame) - size.width/2 - 5, CGRectGetHeight(self.view.frame)-size.height - 10, size.width, size.height);
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"游戏规则";
    if (!self.lukcy)
    {
        [self loadLuckyList];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_loadLuckyListReq cancel];
    _loadLuckyListReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark private methods
- (void)loadLuckyList
{
    [_loadLuckyListReq cancel];
    _loadLuckyListReq = nil;
    
    _loadLuckyListReq = [[HYLuckyListReq alloc] init];
    _loadLuckyListReq.version = kLotteryVersion;
    _loadLuckyListReq.lotteryCode = kLotteryCode;
    _loadLuckyListReq.lotteryTypeCode = kLotteryTypeCode;
    _loadLuckyListReq.actType = @"findLotteries";
    _loadLuckyListReq.page = @"1";
    _loadLuckyListReq.pageSize = @"10";
    
    __weak typeof(self) bself = self;
    [_loadLuckyListReq sendReuqest:^(id result, NSError *error) {
        if (!error)
        {
            bself.lukcy = [[(HYLuckyListResp *)result luckyList] lastObject];
            [bself.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ruleCellId = @"ruleCellId";
    HYLuckyRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:ruleCellId];
    if (!cell)
    {
        cell = [[HYLuckyRuleCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:ruleCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = self.lukcy.lotteryInfo;

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    CGSize size = [self.lukcy.lotteryInfo sizeWithFont:[UIFont systemFontOfSize:14]
                                     constrainedToSize:CGSizeMake(CGRectGetWidth(tableView.frame)-20, MAXFLOAT)
                                         lineBreakMode:NSLineBreakByCharWrapping];
    size.height += 14;
    height = (height>size.height) ? height : size.height;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
