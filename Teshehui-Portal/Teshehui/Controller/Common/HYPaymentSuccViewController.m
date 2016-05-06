//
//  HYPaymentSuccViewController.m
//  Teshehui
//
//  Created by HYZB on 14/11/19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPaymentSuccViewController.h"
#import "HYMallProductManager.h"
#import "HYMallSectionView.h"
#import "HYProductListSummary.h"
#import "HYUserInfo.h"
#import "UIImage+Addition.h"
#import "HYMallMainProductListCell.h"
#import "HYProductDetailViewController.h"
#import "HYMallOrderDetailViewController.h"

#import "HYShareInfoReq.h"
#import "UMSocial.h"
#import "HYNavigationController.h"

@interface HYPaymentSuccViewController ()
<HYMallProductListCellDelegate,
UMSocialUIDelegate>
{
    HYMallSectionView *_sectionView;
    
    HYShareInfoReq *_getShareInfoReq;
    
    UILabel *_saveDescLab;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *guide;
@property (nonatomic, strong) HYMallProductManager *productManager;

@property (nonatomic, assign) BOOL isShare;

@end

@implementation HYPaymentSuccViewController

- (void)dealloc
{
    [_getShareInfoReq cancel];
    _getShareInfoReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _productManager = [[HYMallProductManager alloc] init];
        _isShare = NO;
    }
    return self;
}

- (void)loadView
{
    self.title = @"支付成功";
    
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
//    tableview.backgroundView = nil;
    tableview.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                                green:126.0/255.0
                                                 blue:127.0/255.0
                                                alpha:1.0];
    
    UIView *headViwe = [[UIView alloc] initWithFrame:TFRectMake(0, 0, 320, 120)];

    UILabel *descLab = [[UILabel alloc] initWithFrame:TFRectMake(30, 100, 260, 20)];
    descLab.font = [UIFont systemFontOfSize:18];
    descLab.textAlignment = NSTextAlignmentCenter;
    descLab.text = @"付款成功，您的包裹整装待发！";
    descLab.textColor = [UIColor whiteColor];
    [headViwe addSubview:descLab];
    
    UIImageView *hImgView = [[UIImageView alloc] initWithFrame:TFRectMake(0, 20, 320, 71)];
    hImgView.image = [UIImage imageWithNamedAutoLayout:@"share_img1"];
    [headViwe addSubview:hImgView];
    tableview.tableHeaderView = headViwe;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    UIView *footerView = [[UIView alloc] initWithFrame:TFRectMake(0, 0, 320, 400)];
    footerView.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                                 green:126.0/255.0
                                                  blue:127.0/255.0
                                                 alpha:1.0];
    
    UIView *lLineView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(20, 8, 120, 0.5)];
    lLineView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:lLineView];
    
    UIView *rLineView = [[UIView alloc] initWithFrame:TFRectMakeFixWidth(180, 8, 120, 0.5)];
    rLineView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:rLineView];
    
    UIImageView *saveIcon = [[UIImageView alloc] initWithFrame:TFRectMake(152, 0, 16, 16)];
    saveIcon.image = [UIImage imageWithNamedAutoLayout:@"share_img2"];
    [footerView addSubview:saveIcon];
    
    _saveDescLab = [[UILabel alloc] initWithFrame:TFRectMake(20, 10, 280, 60)];
    _saveDescLab.font = [UIFont systemFontOfSize:16];
    _saveDescLab.textColor = [UIColor whiteColor];
    _saveDescLab.lineBreakMode = NSLineBreakByCharWrapping;
    _saveDescLab.numberOfLines = 3;
    [footerView addSubview:_saveDescLab];
    
    UIImageView *descIcon = [[UIImageView alloc] initWithFrame:TFRectMake(0, 44, 320, 178)];
    descIcon.image = [UIImage imageWithNamedAutoLayout:@"share_wave"];
    [footerView addSubview:descIcon];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:TFRectMake(0, 178+44, 320, 400-222)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:whiteView];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = TFRectMake(20, 240, 280, 44);
    [shareBtn setBackgroundImage:[[UIImage imageNamed:@"share_btn"] stretchableImageWithLeftCapWidth:20
                                                                               topCapHeight:20]
                        forState:UIControlStateNormal];
    [shareBtn setTitle:@"立即分享"
              forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [shareBtn addTarget:self
                 action:@selector(shareEvent)
       forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:shareBtn];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:TFRectMake(20, 300, 280, 60)];
    tipsLab.font = [UIFont systemFontOfSize:16];
    tipsLab.textColor = [UIColor colorWithWhite:0.4
                                          alpha:1.0];
    tipsLab.lineBreakMode = NSLineBreakByCharWrapping;
    tipsLab.numberOfLines = 3;
    tipsLab.text = @"安全提醒：尊敬的会员：商品签收前务必先核对件数和拆包检查，万一有商品破损，货不对版，数量不符请直接拒收!";
    [footerView addSubview:tipsLab];
    
    tableview.tableFooterView = footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateSaveInfo];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    if (CheckIOS7)
    //    {
    //        CGRect frame = [[UIScreen mainScreen] bounds];
    //        frame.origin.y = 64;
    //        frame.size.height -= 64.0;
    //        self.view.frame = frame;
    //        CGRect tf = CGRectMake(0, 44, frame.size.width, frame.size.height - 108);
    //        self.tableView.frame = tf;
    //
    //        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
    //        [appDelegate hiddenTabbar];
    //    }
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    nav.canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    nav.canDragBack = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToRootViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - private methods
- (void)dismissGuideImage:(id)sender
{
    [_guide removeFromSuperview];
}

- (void)shareEvent
{
    [self getShareInfo];
}

- (void)getShareInfo
{
    //商城支付成功_分享
    NSString *userID = [HYUserInfo getUserInfo].userId;
    if (userID) {
        NSDictionary *dict = @{@"OrderID":self.orderCode, @"UserID":userID};
        [MobClick event:@"v430_shangchengzhifuchenggong_fenxiang_jishu" attributes:dict];
    }
    
    if (!_isShare)
    {
        _isShare = YES;
        _getShareInfoReq = [[HYShareInfoReq alloc] init];
        _getShareInfoReq.user_id = [[HYUserInfo getUserInfo] userId];
        _getShareInfoReq.type = @"0";
        NSNumber *pPoint = [NSNumber numberWithFloat:self.point];
        _getShareInfoReq.price = pPoint.stringValue;
        __weak typeof(self) b_self = self;
        [_getShareInfoReq sendReuqest:^(HYShareInfoResp *res, NSError *error)
         {
             [HYLoadHubView dismiss];
             if (res.status == 200)
             {
                 NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.imgurl]];
                 
                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
                 [UMSocialData defaultData].extConfig.title = res.title;
                 [UMSocialData defaultData].extConfig.wechatSessionData.url = res.url;
                 [UMSocialData defaultData].extConfig.wechatTimelineData.url = res.url;
                 [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                 [UMSocialData defaultData].extConfig.qqData.url = res.url;
                 [UMSocialData defaultData].extConfig.qzoneData.title = res.title;
                 [UMSocialData defaultData].extConfig.qzoneData.url = res.url;
                 [UMSocialData defaultData].extConfig.qqData.title = res.title;
                 
                 [UMSocialSnsService presentSnsIconSheetView:self
                                                      appKey:uMengAppKey
                                                   shareText:[NSString stringWithFormat:@"%@%@", res.msg, res.url]
                                                  shareImage:imgData
                                             shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                                    delegate:self];
             }
             else
             {
                 b_self.isShare = NO;
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:res.rspDesc
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
    
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    _isShare = NO;
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    _isShare = NO;
}

- (void)updateSaveInfo
{
    _saveDescLab.text = [NSString stringWithFormat:@"特奢汇又帮您省了%d元，告诉我的小伙伴们让他们也来省！", (int)self.point];
}

#pragma mark - HYMallProductListCellDelegate
- (void)checkProductDetail:(id)product
{
    if ([product isKindOfClass:[HYProductListSummary class]])
    {
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = [(HYProductListSummary *)product productId];
        vc.loadFromPayResult = YES;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return ([[self.adressInfo fullAddress] length]>0);
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    static NSString *summaryCellId = @"summaryCellId";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:summaryCellId];
    if (!cell)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:summaryCellId];
        [cell setHiddenLine:YES];
        cell.contentView.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                                           green:126.0/255.0
                                                            blue:127.0/255.0
                                                           alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"收件人: %@  %@",
                           self.adressInfo.consignee,
                           self.adressInfo.phoneMobile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"收货地址: %@", [self.adressInfo fullAddress]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
