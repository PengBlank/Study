//
//  HYAroundMallDetailViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallDetailViewController.h"
#import "HYQRCodeGetShopListResponse.h"
#import "HYQRCodeGetShopDetailRequest.h"
#import "HYAroundMallDetailDataSource.h"
#import "HYHotelMapViewController.h"
#import "METoast.h"

@interface HYAroundMallDetailViewController ()
<
UITableViewDelegate,
UIWebViewDelegate
>

@property (nonatomic, strong) HYAroundMallDetailDataSource *dataSource;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWebView *merchantDescView;
@property (nonatomic, strong) HYQRCodeGetShopDetailRequest *detailRequest;

@end

@implementation HYAroundMallDetailViewController

- (void)dealloc
{
    [self.detailRequest cancel];
    self.detailRequest = nil;
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"商户详情";
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = self.view.bounds;
//    frame.size.height -= 64;
    UITableView *tableview = [[UITableView alloc]initWithFrame:frame
                                                         style:UITableViewStylePlain];
	tableview.delegate = self;
//	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [tableview registerNib:[UINib nibWithNibName:@"HYAroundMallSummaryCell" bundle:nil]
    forCellReuseIdentifier:@"summaryCell"];
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
    
    if (!self.merchantDescView)
    {
        _merchantDescView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        self.view.bounds.size.width,
                                                                        10)];
        
        _merchantDescView.delegate = self;
    }
    
    self.tableView.tableFooterView = self.merchantDescView;
    
    HYAroundMallDetailDataSource *datasource = [[HYAroundMallDetailDataSource alloc] init];
    tableview.dataSource = datasource;
    self.dataSource = datasource;
    self.dataSource.telBtnCallback = [self telBtnCallback];
    self.dataSource.viewController = self;
    self.dataSource.tableView = tableview;
    self.dataSource.shopDetail = self.shop;
    [tableview reloadData];

    [self updateWithDetail];
    [self fetchDetailFromNet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (!self.view.window)
    {
        [self.detailRequest cancel];
        self.detailRequest = nil;
        self.dataSource = nil;
        self.tableView = nil;
        self.view = nil;
    }
}

#pragma mark - GetData

- (void)fetchDetailFromNet
{
    if (self.shop)
    {
        [HYLoadHubView show];
        self.detailRequest = [[HYQRCodeGetShopDetailRequest alloc] init];
        _detailRequest.merchant_id = _shop.store_id;
        __weak HYAroundMallDetailViewController *weak_self = self;
        [_detailRequest sendReuqest:^(id result, NSError *error)
        {
            [HYLoadHubView dismiss];
            if ([result isKindOfClass:[NSString class]])
            {
                NSString *html = (NSString *)result;
               [weak_self.merchantDescView loadHTMLString:html
                                                  baseURL:nil];
            }
        }];
    }
}

- (void)updateWithDetail
{
    self.dataSource.shopDetail = self.shop;
    [self.tableView reloadData];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    CGRect rect = self.merchantDescView.frame;
    rect.size = fittingSize;
    self.merchantDescView.frame = rect;
    self.tableView.tableFooterView = self.merchantDescView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource rowHeightForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.dataSource tableView:tableView viewForHeaderInSection:section];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return section == 0 ? 0 : 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        if (_shop.latitude == 0 && _shop.lontitude == 0)
        {
            //提示没有地址信息
            [METoast toastWithMessage:@"该商户没有录入地理位置信息，无法定位"];
        }
        else
        {
            HYHotelMapViewController *map = [[HYHotelMapViewController alloc] init];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_shop.latitude, _shop.lontitude);
            map.annotationTitle = _shop.store_name;
            map.showAroundShops = NO;
            map.location = location;
            map.coorType = HYCoorGeneral;
            map.redThemeNavbar = YES;
            [self.navigationController pushViewController:map animated:YES];
        }
    }
}

- (void (^)(id sender))telBtnCallback
{
    __weak id w_self = self;
    void (^callback)(id) = ^(id sender)
    {
        HYAroundMallDetailViewController *s_self = w_self;
        HYQRCodeShop *shopDetail = s_self.shop;
        if (shopDetail && shopDetail.tel.length > 0)
        {
            NSString *prompt = [NSString stringWithFormat:@"是否向%@拨打电话?", shopDetail.tel];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:prompt delegate:s_self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1033;
            [alert show];
        }
    };
    return callback;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 1033)
    {
        NSString *s = [NSString stringWithFormat:@"tel:%@", _shop.tel];
        NSURL *URL = [NSURL URLWithString:s];
        if ([[UIApplication sharedApplication] canOpenURL:URL])
        {
            [[UIApplication sharedApplication] openURL:URL];
        }
    }
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
