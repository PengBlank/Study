//
//  HYGoodsRetStatViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetStatViewController.h"
#import "UIImageView+WebCache.h"
#import "HYMallReturnsProgress.h"
#import "HYGoodsRetVerifingViewController.h"
#import "HYGoodsRetVerifiedViewController.h"
#import "HYGoodsRetRefusedViewController.h"
#import "HYGoodsRetBuyerSentViewController.h"
#import "HYGoodsRetMoneyViewController.h"
#import "HYGoodsRetExchangeViewController.h"

@interface HYGoodsRetStatViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HYGoodsRetStatViewController

+ (instancetype)statViewControllerWithRetusnInfo:(HYMallReturnsInfo *)returnsInfo
{
    //测试数据
    HYGoodsRetStatViewController *ret = nil;
    switch (returnsInfo.refundStatus) {
        case HYRefund_MerchantVerifing:
            ret = [[HYGoodsRetVerifingViewController alloc] init];
            break;
        case HYRefund_MerchantRefused:
            ret = [[HYGoodsRetRefusedViewController alloc] init];
            break;
        case HYRefund_MerchantVerified:
            ret = [[HYGoodsRetVerifiedViewController alloc] init];
            break;
        case HYRefund_BuyerRecieved:
            ret = [[HYGoodsRetExchangeViewController alloc] init];
            break;
        case HYRefund_BuyerSent:
            ret = [[HYGoodsRetBuyerSentViewController alloc] init];
            break;
        case HYRefund_MerchantRecieved:
            if (returnsInfo.refund_type == 1) {
                ret = [[HYGoodsRetMoneyViewController alloc] init];
            } else if (returnsInfo.refund_type == 2) {
                ret = [[HYGoodsRetExchangeViewController alloc] init];
            }
            break;
        case HYRefund_MerchantResend:
            ret = [[HYGoodsRetExchangeViewController alloc] init];
            break;
        case HYRefund_Refunding:
        case HYRefund_Refunded:
            ret = [[HYGoodsRetMoneyViewController alloc] init];
            break;
        default:
            break;
    }
    ret.refundStatus = returnsInfo.refundStatus;
    ret.refundType = returnsInfo.refund_type;
    ret.returnsInfo = returnsInfo;
    return ret;
}

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
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //frame.size.height -= 44;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundView = nil;
    tableview.delaysContentTouches = NO;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    /*
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:footer];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:footer.bounds];
    bg.image = [UIImage imageNamed:@"g_ret_foot_bg.png"];
    [footer addSubview:bg];
    
    UIImage *cancel = [UIImage imageNamed:@"g_ret_cancel.png"];
    CGFloat x = CGRectGetMidX(footer.bounds) - 15 - cancel.size.width;
    CGFloat y = CGRectGetMidY(footer.bounds) - cancel.size.height/2;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, cancel.size.width, cancel.size.height)];
    [cancelBtn setImage:cancel forState:UIControlStateNormal];
    [footer addSubview:cancelBtn];
    
    UIImage *apply = [UIImage imageNamed:@"g_ret_apply.png"];
    x = CGRectGetMidX(footer.bounds) + 15;
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, apply.size.width, apply.size.height)];
    [applyBtn setImage:apply forState:UIControlStateNormal];
    [footer addSubview:applyBtn];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.refundType == 1)
    {
        self.title = @"退货详情";
    }
    else
    {
        self.title = @"换货详情";
    }
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //_refundStatus = self.returnsInfo.refundStatus;
    //self.datasource.refundStatus = _refundStatus;
    //self.datasource.refundType = self.returnsInfo.refund_type;
    
    
    [_tableView registerClass:[HYGoodsRetGrayCell class] forCellReuseIdentifier:@"grayCell"];
    [_tableView registerClass:[HYGoodsRetDetailCell class] forCellReuseIdentifier:@"detailCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"photoCell"];
    [_tableView registerClass:[HYGoodsRetWarningCell class] forCellReuseIdentifier:@"warningCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"progressCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Use for childrens.
- (HYGoodsRetGrayCell *)statCell
{
    HYGoodsRetGrayCell *grayCell = [_tableView dequeueReusableCellWithIdentifier:@"grayCell"];
    grayCell.isGray = YES;
    grayCell.nessary = NO;
    grayCell.keyLab.text = (_refundType == 1) ? @"退货状态" : @"换货状态";
    grayCell.valueLab.text = [self statusDisplay];
    grayCell.valueLab.textColor = [UIColor orangeColor];
    grayCell.selectable = NO;
    return grayCell;
}

- (NSString *)statusDisplay
{
    NSString *stat = nil;
    switch (_refundStatus) {
        case HYRefund_MerchantVerifing:
            stat = @"审核中";
            break;
        case HYRefund_MerchantVerified:
            stat = @"卖家已同意退/换货";
            break;
        case HYRefund_MerchantRefused:
            stat = @"卖家拒绝退/换货";
            break;
        case HYRefund_BuyerSent:
            stat = @"卖家确认收货中";
            break;
        case HYRefund_BuyerRecieved:
            stat = @"换货已完成";
            break;
        case HYRefund_MerchantRecieved:
        {
            if (_refundType == 1) {
                stat = @"退款中";
            } else if (_refundType == 2) {
                stat = @"换货中";
            }
            break;
        }
        case HYRefund_Refunding:
        {
            if (_refundType == 1)
            {
                stat = @"退款中";
            }
            break;
        }
        case HYRefund_Refunded:
        {
            if (_refundType == 1)
            {
                stat = @"退款已完成";
            }
            break;
        }
        default:
            stat = @"";
            break;
    }
    return stat;
}

- (HYGoodsRetGrayCell *)serviceTypeCell
{
    NSString *service = nil;
    if (_refundType == 1) {
        service = @"退货";
    }
    if (_refundType == 2) {
        service = @"换货";
    }
    
    NSDictionary *dic = nil;
    if (service)
    {
        dic = [NSDictionary dictionaryWithObject:service forKey:@"服务类型"];
    }
    return [self infoCellWithInfo:dic];
}

- (UITableViewCell *)numCell
{
    HYMallOrderItem *goods = [self.returnsInfo.orderItem objectAtIndex:0];
    NSString *num = [NSString stringWithFormat:@"%d", (int)goods.quantity];
    return [self infoCellWithInfo:[NSDictionary dictionaryWithObject:num forKey:@"提交数量"]];
}

- (HYGoodsRetGrayCell *)infoCellWithInfo:(NSDictionary *)info
{
    HYGoodsRetGrayCell *grayCell = [_tableView dequeueReusableCellWithIdentifier:@"grayCell"];
    grayCell.isGray = NO;
    grayCell.nessary = NO;
    grayCell.selectable = NO;
    grayCell.keyLab.text = [info.allKeys objectAtIndex:0];
    grayCell.valueLab.text = [info.allValues objectAtIndex:0];
    grayCell.valueLab.textColor = [UIColor blackColor];
    return grayCell;
}

- (HYGoodsRetDetailCell *)detailCell
{
    HYGoodsRetDetailCell *detailCell = [_tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    detailCell.keyLab.text = @"问题描述";
    detailCell.detailContent = self.returnsInfo.refund_desc;
    return detailCell;
}

- (UITableViewCell *)photoCell
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    cell.frame = CGRectMake(0, 0, CGRectGetWidth(ScreenRect), 80);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat w = 55;
    CGFloat x = 20;
    CGFloat y = 15;
    NSArray *photos = self.returnsInfo.attachments;
    for (int i = 0; i < 4; i++)
    {
        UIImageView * btn = (UIImageView *)[cell.contentView viewWithTag:1000+i];
        if (!btn) {
            btn = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
            [cell.contentView addSubview:btn];
        }
        
        if (photos.count > i) {
            NSDictionary *photoStrDict = [photos objectAtIndex:i];
            if ([photoStrDict isKindOfClass:[NSDictionary class]])
            {
                NSString *photoStr = [photoStrDict objectForKey:@"thumb"];
                [btn sd_setImageWithURL:[NSURL URLWithString:photoStr]];
            }
        }
        else{
            btn.image = nil;
        }
        x += w + 10; //右移一个按钮的距离，加15空白再减去右上角空白
    }
    return cell;
}

- (UITableViewCell *)progressCell
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"progressCell"];
    cell.frame = CGRectMake(0, 0, CGRectGetWidth(ScreenRect), 95);
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1023];
    if (!nameLabel) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 150, 18)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:17.0];
        [cell.contentView addSubview:nameLabel];
        nameLabel.tag = 1023;
    }
    nameLabel.text = @"售后服务进度条";
    
    HYMallReturnsProgress *progressV = (HYMallReturnsProgress *)[cell.contentView viewWithTag:1024];
    if (!progressV)
    {
        progressV = [[HYMallReturnsProgress alloc] initWithFrame:
                     CGRectMake(10, 44, ScreenRect.size.width-20, 44)
                     
                                                      stepTitles:[self progressTitlesWithType:_refundType]];
        
        [cell.contentView addSubview:progressV];
        progressV.tag = 1024;
    }
    progressV.currStep = [self refundStep];
    return cell;
}

- (NSArray *)progressTitlesWithType:(NSInteger)type
{
    if (type == 1) {
        return [NSArray arrayWithObjects:@"提交申请",
                @"卖家审核",
                @"货物快递",
                @"退款",
                @"完成", nil];
    }
    else if (type == 2) {
        return [NSArray arrayWithObjects:@"提交申请",
                @"卖家审核",
                @"货物快递",
                @"换新",
                @"完成", nil];
    }
    return nil;
}

- (NSInteger)refundStep
{
    NSInteger step = -1;
    if (_refundType == 1) //退货
    {
        switch (_refundStatus) {
            case HYRefund_MerchantVerifing:
                step = 0;
                break;
            case HYRefund_MerchantVerified:
            case HYRefund_BuyerSent:
                step = 2;
                break;
            case HYRefund_MerchantRefused:
                step = 1;
                break;
            case HYRefund_MerchantRecieved:
            case HYRefund_Refunding:
                step = 3;
                break;
            case HYRefund_Refunded:
                step = 4;
                break;
            default:
                break;
        }
    }
    else if (_refundType == 2) //换货
    {
        switch (_refundStatus) {
            case HYRefund_MerchantVerifing:
                step = 0;
                break;
            case HYRefund_MerchantVerified:
            case HYRefund_BuyerSent:
                step = 2;
                break;
            case HYRefund_MerchantRefused:
                step = 1;
                break;
            case HYRefund_MerchantResend:
            case HYRefund_MerchantRecieved:
                step = 3;
                break;
            case HYRefund_BuyerRecieved:
                step = 4;
                break;
            default:
                break;
        }
    }
    return step + 1;
}



- (HYGoodsRetEntryCell *)entryCellWithKey:(NSString *)entryKey
{
    HYGoodsRetEntryCell *entryCell = [_tableView dequeueReusableCellWithIdentifier:@"entryCell"];
    entryCell.keyLab.text = entryKey;
    return entryCell;
}

- (HYGoodsRetWarningCell *)warningCellWithWarning:(NSString *)warning
{
    HYGoodsRetWarningCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"warningCell"];
    cell.warning = warning;
    return cell;
}

#pragma mark - table, implement in childrens
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self tableView:tableView cellForRowAtIndexPath:indexPath] bounds].size.height;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
