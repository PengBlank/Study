//
//  PrepayViewController.m
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PrepayViewController.h"
#import "PBItemViewCell.h"
#import "PBCollectionHeaderView.h"

#import "DefineConfig.h"            // 宏
#import "UIView+Common.h"
#import "MJExtension.h"             // mj数据解析
#import "METoast.h"                 // 提示
#import "UIColor+expanded.h"

#import "HYUserInfo.h"              // 用户信息头文件
#import "PrepayRequest.h"           // 余额充值页面请求头
#import "PrepayPBInfo.h"            // 实体店余额充值页面model
#import "RechargePackagesInfo.h"    // 充值套餐列表model

#import "SubmitPrepayRequest.h"     // 会员充值提交请求
#import "HYAlipayOrder.h"           // 支付
#import "HYPaymentViewController.h" // 支付页面
#import "HYNormalLeakViewController.h"  // 获取现金券页面
#import "HYExperienceLeakViewController.h"// 获取现金券页面

#import "PrepaySuccessViewController.h" // 充值成功
#import "JCAlertView.h"                 // 提示框
#import "Masonry.h"

#define pITEM_Spacing 16 // cell间距
#define pLINE_Spacing 20 // cell行距
#define pBACK_Gauge 11   // cell与左右的边距
#define pWH_Scale 1.65   // cell Width比Height

static NSString *cellId = @"cellId";
static NSString *headId = @"headId";

@interface PrepayViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger _markIndex; // 用来记录选中的cell的index
    JCAlertView *_jcAlertVIew; // 提示框
    UILabel *_promptLabel;     // 没有套餐时提示文字
    UIImageView *_promptImage; // 没有套餐时提示图标
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIButton *prepayButton; // 立即充值按钮

@property (nonatomic, strong) PrepayRequest *prepayListRequest; // 余额充值页面
@property (nonatomic, strong) PrepayPBInfo *prepayPBInfo;       // 余额充值页面数据

@property (nonatomic, strong) SubmitPrepayRequest *submitPRequest; // 充值提交

@property (nonatomic, strong) NSString *amount;         // 金额
@property (nonatomic, strong) NSString *coupon;         // 现金券
@property (nonatomic, strong) NSString *userPoints;     // 用户现有的 现金券

@property (nonatomic, strong) NSString *o2o_trade_no;   // o2o订单号
@property (nonatomic, strong) NSString *c2b_trade_no;   // c2b订单号
@property (nonatomic, strong) NSString *c2b_order_id;   // c2b订单id

@end

@implementation PrepayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _markIndex = 999; // 默认为一个较大的数
    self.title = @"实体店余额充值";
    HYUserInfo *userInfo = [HYUserInfo getUserInfo]; // 用户信息
    self.userPoints = userInfo.points;               // 用户现金券
    
    [self createUI];
    [self loadPrepayViewData];
}

#pragma mark - UI相关
// 创建UI
- (void)createUI
{
    // flowLayout
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:pITEM_Spacing]; // 间距
    [layout setMinimumLineSpacing:pLINE_Spacing]; // 行距
    [layout setSectionInset:UIEdgeInsetsMake(0, pBACK_Gauge, 0, pBACK_Gauge)];
    CGFloat itemWidth = (self.view.frame.size.width-pITEM_Spacing-pBACK_Gauge*2)/2;
    CGFloat itemHeight = itemWidth/pWH_Scale; // 高度按宽度的比例来算
    [layout setItemSize:CGSizeMake(itemWidth, itemHeight+g_fitFloat(@[@10,@0,@0]))];
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource =self;
    self.myCollectionView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    // 注册cell
    [self.myCollectionView registerClass:[PBItemViewCell class] forCellWithReuseIdentifier:cellId];
    // 注册SectionHeader
    [self.myCollectionView registerClass:[PBCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    
    [self.view addSubview:self.myCollectionView];
    
    self.prepayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect rect2 = CGRectMake(0, self.view.frame.size.height-49-64, self.view.size.width, 49);
    [self.prepayButton setFrame: rect2];
    [self.prepayButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.prepayButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [self.prepayButton setTitle:@"" forState:UIControlStateDisabled];
    [self.prepayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.prepayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//    [self.prepayButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled]; // 禁用
    [self.prepayButton setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    [self.view addSubview:self.prepayButton];
    [self.prepayButton addTarget:self action:@selector(prepayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.prepayButton setEnabled:NO]; // 不可用
    
    // 没套餐时提
    _promptImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 66)]; // 80*66
    [_promptImage setCenter:CGPointMake(self.view.centerX, self.view.centerY-33)];
    [_promptImage setImage:[UIImage imageNamed:@"No-prepaid-phone-package"]];
    [self.view addSubview:_promptImage];
    [_promptImage setHidden:YES];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [_promptLabel setCenter:CGPointMake(self.view.centerX, self.view.centerY+33)];
    [_promptLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [_promptLabel setFont:[UIFont systemFontOfSize:17]];
    [_promptLabel setText:@"此商家未设置充值套餐!"];
    [_promptLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_promptLabel];
    [_promptLabel setHidden:YES];
//    [_promptLabel setBackgroundColor:[UIColor yellowColor]];
    
}

#pragma mark - CollectionViewDataSource相关
// cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 7;
    
    return self.prepayPBInfo.rechargePackages.count; // 套餐列表数量
}
// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PBItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSMutableArray *rpArray = self.prepayPBInfo.rechargePackages; // 取出数组
    RechargePackagesInfo *rpInfo = [rpArray objectAtIndex:indexPath.row]; // 获取数据
    BOOL havePoint = [self.userPoints integerValue] > [rpInfo.givenAmount integerValue]? YES:NO;
    
    [cell refreshUIDataWithModel:rpInfo Index:indexPath.row HavePoint:havePoint Type:self.merchantType]; // 刷新数据
    if (indexPath.row == _markIndex) {
        [cell pickTheCell:YES HavePoint:havePoint];
    }else
    {
        [cell pickTheCell:NO HavePoint:havePoint];
    }
    
    return cell;
}
//Section Header Footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        PBCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId forIndexPath:indexPath];
        
        [headerView refreshUIDataWithModel:self.prepayPBInfo];
        
        return headerView;
    }
    return nil;
}
#pragma mark - CollectionViewDelegate相关
// header Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.prepayPBInfo) {
        return CGSizeMake(0, 0); // 没有数据时不现实Header
    }
    return CGSizeMake(0, 168+5);
}
// 点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.prepayPBInfo.rechargePackages;
    RechargePackagesInfo *rpInfo = [array objectAtIndex:indexPath.row]; // 获取数据
    
    if (self.merchantType == 0)
    {// 普通商家才要判断现金券
        if ([self.userPoints integerValue] < [rpInfo.givenAmount integerValue])
        {// 现金券不足
            [self showTheJCAlertView:self.userPoints];
        }else
        {// 现金券充足 记录index
            _markIndex = indexPath.row;
            [self.myCollectionView reloadData];
        }
    }else
    {// 桌球商家 直接记录index
        _markIndex = indexPath.row;
        [self.myCollectionView reloadData];
    }
}

#pragma mark - 网络请求
- (void)loadPrepayViewData
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        return;
    }
    [HYLoadHubView show]; //??
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    // 默认参数
    self.prepayListRequest               = [[PrepayRequest alloc] init];
    self.prepayListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Member/RechargePackages",BASEURL];
    self.prepayListRequest.interfaceType = DotNET2;
    self.prepayListRequest.postType      = JSON;
    self.prepayListRequest.httpMethod    = @"POST";
    
    self.prepayListRequest.UId           = userInfo.userId ? :@""; // 用户id
    self.prepayListRequest.merId         = self.merId ? :@"";
//    NSString *str = @" ";
//    if (self.merchantType) {
//        str = @"Billiard";
//    }
    self.prepayListRequest.merchantType  = self.merchantType ? @"Billiard" : @""; //商家类型 桌球类型：Billiard，默认""
    self.prepayListRequest.mobile        = userInfo.mobilePhone;
    
    [self.prepayListRequest sendReuqest:^(id result, NSError *error) {
        
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {//状态值为0 代表请求成功  其他为失败
                NSDictionary *tmpDic = objDic[@"data"];
                
                // model中再转换model
                [PrepayPBInfo setupObjectClassInArray:^NSDictionary *{
                    return @{@"rechargePackages":@"RechargePackagesInfo"};
                }];
                
                weakSelf.prepayPBInfo = [PrepayPBInfo objectWithKeyValues:tmpDic];
                
                if (weakSelf.prepayPBInfo.rechargePackages.count == 0)
                {// 无套餐
                    [_promptImage setHidden:NO];
                    [_promptLabel setHidden:NO];
                    [weakSelf.prepayButton setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
                    [weakSelf.prepayButton setEnabled:NO]; // 不可用
                }else
                {// 有套餐
                    [_promptImage setHidden:YES];
                    [_promptLabel setHidden:YES];
                    [weakSelf.prepayButton setEnabled:YES]; // 可用
                    [weakSelf.prepayButton setBackgroundColor:[UIColor colorWithHexString:@"0xb80000"]];
                }
                [weakSelf.myCollectionView reloadData]; // 刷新
                
            }else if(code == 1)
            {// 商家禁用或没开通充值
               if(weakSelf.comeType == 0)
               {    // 扫码进来的 二维码实效
                   [weakSelf createScanPromptView];
               }else
               {// 从实体店进来
                   NSString *msg = objDic[@"msg"];
                   [weakSelf createPromptView:msg];
               }
            }else
            {// code==2 获取套餐失败，请重试
                NSString *msg = objDic[@"msg"];
                [weakSelf createPromptView:msg];
            }
        }else
        {
//            [METoast toastWithMessage:@"无法连接服务器"];
            [weakSelf createPromptView:@"服务器请求异常"];
        }
        [HYLoadHubView dismiss]; // load
    }];
    
}

#pragma mark -- 充值按钮
// 充值按钮点击
- (void)prepayButtonClick
{
    if (_markIndex == 999) {
        [METoast toastWithMessage:@"请选择一种充值套餐!"];
        //        [self showTheJCAlertView:@"10"];
        return;
    }
    
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
//        [self.prepayButton setEnabled:YES];
        return;
    }
    self.view.userInteractionEnabled = NO; // 不可点
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo]; // 用户信息
    NSString *points = userInfo.points;              // 用户现金券
    
    NSArray *rpArray = self.prepayPBInfo.rechargePackages; // 取出数组
    RechargePackagesInfo *rpInfo = [rpArray objectAtIndex:_markIndex]; // 获取套餐数据
    
    self.amount = rpInfo.amount;     // 金额
    self.coupon = rpInfo.givenAmount;// 现金券
    
    [HYLoadHubView show]; //??
        
        // 默认参数
    self.submitPRequest               = [[SubmitPrepayRequest alloc] init];
    self.submitPRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Member/Recharge",BASEURL]; // 会员充值提交
    self.submitPRequest.interfaceType = DotNET2;
    self.submitPRequest.postType      = JSON;
    self.submitPRequest.httpMethod    = @"POST";
        
    self.submitPRequest.UId           = userInfo.userId ? :@"";         // 用户id
    self.submitPRequest.merId         = self.merId ? :@"";              // 商家id
    self.submitPRequest.amount        = self.amount;                    // 金额
    self.submitPRequest.coupon        = self.coupon; // 现金券 桌球的是赠送金额
    self.submitPRequest.userName      = userInfo.realName ? : @"";      // 用户名
    self.submitPRequest.cardNo        = userInfo.number ? : @"";        // 会员卡号
    self.submitPRequest.mobile        = userInfo.mobilePhone ? : @"";   // 手机号
    self.submitPRequest.merchantName  = self.prepayPBInfo.merchantName; // 商家名
    self.submitPRequest.productName   = @"RechargePay"; // 类型 桌球城pc端 Billiards 橙巨人端 Orange 充值支付 RechargePay 充值消费 RechargeCost
    self.submitPRequest.merchantLogo  = self.prepayPBInfo.merchantLogo? :@""; // 商家logo
//    NSString *str = @"";
//    if (self.merchantType) {
//        str = @"Billiard";
//    }
    self.submitPRequest.merchantType  = self.merchantType ? @"Billiard" : @""; //商家类型 桌球类型：Billiard，默认""
        
    [self.submitPRequest sendReuqest:^(id result, NSError *error) {
            
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {//状态值为0 代表请求成功  其他为失败
                NSDictionary *objKeyValue = objDic[@"data"];
                    
                weakSelf.o2o_trade_no = objKeyValue[@"o2o_trade_no"]; // o2o订单号
                weakSelf.c2b_trade_no = objKeyValue[@"c2b_trade_no"]; // c2b订单号
                weakSelf.c2b_order_id = objKeyValue[@"c2b_order_id"]; // c2b订单id
                    
                [weakSelf gotoPay];
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
            }else
            {
                [METoast toastWithMessage:@"服务器请求异常"];
            }
        [HYLoadHubView dismiss]; // load
//        [weakSelf.prepayButton setEnabled:YES]; // 按钮可点击
        weakSelf.view.userInteractionEnabled = YES; // 可点
        }];
    
}
#pragma mark -- 提示框
// 参数points 用户当前现金券
- (void)showTheJCAlertView:(NSString *)points
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width-73, 121);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:10.0f];
    [view setClipsToBounds:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"您的现金券不足!"];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:titleLabel];
    
    UILabel *subLabel = [[UILabel alloc] init];
    [subLabel setText:[NSString stringWithFormat:@"当前有%@现金券",points]];
    [subLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [subLabel setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:subLabel];
    
    UIView *lLine = [[UIView alloc] init];
    [lLine setBackgroundColor:[UIColor colorWithHexString:@"d0d0d0"]];
    [view addSubview:lLine];
    UIView *sLine = [[UIView alloc] init];
    [sLine setBackgroundColor:[UIColor colorWithHexString:@"d0d0d0"]];
    [view addSubview:sLine];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundColor:view.backgroundColor];
    [okButton setTitle:@"去赚现金券" forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"prompthl"] forState:UIControlStateHighlighted]; // 高亮图片
    [okButton setTag:101];
    [okButton addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:okButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundColor:view.backgroundColor];
    [cancelButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"prompthl"] forState:UIControlStateHighlighted]; // 高亮图片
    [cancelButton setTag:102];
    [cancelButton addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).with.offset(20);
        make.centerX.mas_equalTo(view.mas_centerX);
    }];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
    }];
    [lLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom).with.offset(-42);
        make.height.mas_equalTo(@1);
    }];
    [sLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lLine.mas_bottom);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.mas_equalTo(@1);
    }];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.top.mas_equalTo(lLine.mas_bottom);
        make.right.mas_equalTo(sLine.mas_left);
        make.bottom.mas_equalTo(view.mas_bottom);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine.mas_right);
        make.top.mas_equalTo(lLine.mas_bottom);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
    }];
    
    _jcAlertVIew = [[JCAlertView alloc]initWithCustomView:view dismissWhenTouchedBackground:NO];
    [_jcAlertVIew show];
}
// 提示框按钮
- (void)alertButtonClick:(UIButton *)sender
{
        WS(weakSelf);
    if (sender.tag == 101)
    {// okBtn
        [_jcAlertVIew dismissWithCompletion:^{
//    ** 这里进行现金券不足页面跳转 页面由总部那边提供**
            
            if ([HYUserInfo getUserInfo].userLevel == 0)
            { //体验用户跳转到体验用户的页面
                HYExperienceLeakViewController *vc = [[HYExperienceLeakViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else
            {//正式会员用户跳转到正式会员的页面
                HYNormalLeakViewController *vc = [[HYNormalLeakViewController alloc] init];
                vc.pushType = @"O2O";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }else
    {
        [_jcAlertVIew dismissWithCompletion:^{
            
        }];
    }
}
// 没数据时提示View
- (void)createPromptView:(NSString *)msg
{
    CGRect viewRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIView *promptView = [[UIView alloc] initWithFrame:viewRect];
    promptView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    CGRect imageRect = CGRectMake(0, 94, 90, 90);
    UIImageView *image = [[UIImageView alloc] initWithFrame:imageRect];
    [image setCenterX:promptView.centerX];
    [image setClipsToBounds:YES];
    [image setImage:[UIImage imageNamed:@"not-available"]];
    [promptView addSubview:image];
    
    CGRect labelRect = CGRectMake(8, imageRect.origin.y+90, promptView.frame.size.width-16, 35);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    [label setCenterX:promptView.centerX];
    [label setText:msg];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor colorWithHexString:@"333333"]];
    [promptView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:promptView];
}
// 扫码进来 没有开通充值
-(void)createScanPromptView
{
    self.title = @"扫码结果";
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 69, 70)];
    [image setCenterX:bgView.centerX];
    [image setImage:[UIImage imageNamed:@"Qr-code-failure"]];
    [bgView addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 84+70+30, self.view.frame.size.width, 30)];
    [label setTextColor:[UIColor colorWithHexString:@"333333"]];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"此充值二维码已失效!"];
    [bgView addSubview:label];
    
    [self.view addSubview:bgView];
}


#pragma mark - 支付页面
- (void)gotoPay
{
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner = PartnerID;
    alOrder.seller = SellerID;
    alOrder.tradeNO = self.c2b_trade_no; //订单号 (显示订单号)
    alOrder.productName = [NSString stringWithFormat:@"【特奢汇】实体店充值: %@", self.c2b_trade_no]; //商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】实体店充值: %@", self.c2b_trade_no]; //商品描述
    alOrder.amount = [NSString stringWithFormat:@"%0.2ld",[self.amount integerValue]]; //商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alOrder;
    payVC.amountMoney = self.amount;   //付款总额
    payVC.point = self.merchantType ? 0.00f : [self.coupon integerValue];//  现金券 如果是桌球商家 就不用扣现金券
    payVC.orderID = self.c2b_order_id;          //用户获取银联支付流水号
    payVC.orderCode = self.c2b_trade_no;        //订单号
    //    payVC.O2O_OrderNo = self.O2O_Order_Number;
    //    payVC.O2O_storeName = self.businessdetailInfo.MerchantsName;
    payVC.type = Pay_O2O_QRScan;
    payVC.O2OpayType = CateringPay;
    
    __weak typeof(self) weakSelf = self;
    [payVC setBusinessPaymentSuccess:^(O2OPayType type) {
        
        [weakSelf pushPaySuccessWithType:type];
        
    }];
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}
//　回调支付成功
- (void)pushPaySuccessWithType:(O2OPayType)type
{
    PrepaySuccessViewController *vc = [[PrepaySuccessViewController alloc] init];
    vc.merName = self.prepayPBInfo.merchantName; // 商家名
    vc.money = self.amount; // 充值金额
    vc.coupon = self.coupon;// 扣除的现金券
    vc.successType = 1;
    vc.comeType = self.comeType;
    vc.businessType = self.merchantType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [_prepayListRequest cancel]; // 余额充值页面
    _prepayListRequest = nil;
    
    [_submitPRequest cancel]; // 充值提交
    _submitPRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
