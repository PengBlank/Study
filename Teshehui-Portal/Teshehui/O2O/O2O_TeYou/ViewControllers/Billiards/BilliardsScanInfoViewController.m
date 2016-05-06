//
//  BilliardsScanInfoViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BilliardsScanInfoViewController.h"
#import "HYBuyDrinksViewController.h"
#import "HYOrderPayViewController.h"
#import "BilliardsOpenTableRequest.h"
#import "BilliardsTableInfoRequest.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "BilliardTisView.h"
#import "MJExtension.h"
#import "HYUserInfo.h"
#import "METoast.h"
#import "BilliardsTableInfo.h"
#import "BilliardsOrderInfo.h"
#import "goodsInfo.h"
#import "TYBuyModelListInfo.h"
#import "UIImageView+WebCache.h"
#import "FLCustomAlertView.h"
#import "PageBaseLoading.h"
@interface BilliardsScanInfoViewController (){
    
}
@property (nonatomic,strong) BilliardTisView           *billiardTisView;
@property (nonatomic,strong) BilliardsOpenTableRequest *openTableRequest;
@property (nonatomic,strong) BilliardsTableInfoRequest *tableInfoRequest;
@property (nonatomic,strong) BilliardsTableInfo        *tableInfo;
@property (nonatomic, assign) CGFloat cash;
@property (nonatomic, assign) NSInteger coupon;
@property (nonatomic,strong) UIButton *openBtn;

@end

@implementation BilliardsScanInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.billiardsTableInfo.MerchantName ? : @"球台信息";
    
    switch (self.type) {
        case 1:
        {
            [self setupUserInterface];
        }
            break;
        case 2:
        {
            [self.view configBlankPage:EaseBlankPageBilliardstableUsing hasData:NO hasError:nil reloadButtonBlock:nil];
        }
            break;
        case 3:
        {
           [self.view configBlankPage:EaseBlankPageBilliardsTablebaning hasData:NO hasError:nil reloadButtonBlock:nil];
        }
            break;
        case 4:
        {
            self.title = @"二维码已失效";
            [self.view configBlankPage:EaseBlankPageQRCodeInvalid hasData:NO hasError:nil reloadButtonBlock:nil];
        }
            break;
            
        default:
            break;
    }
}


/**
 *  请求开台
 */
- (void)openTheTable{
    
 //   [HYLoadHubView show];
     [PageBaseLoading showLoading];
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    [self.openTableRequest cancel];
    self.openTableRequest = nil;
    
    self.openTableRequest               = [[BilliardsOpenTableRequest alloc] init];
    self.openTableRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/OpenBallTable",BILLIARDS_API_URL];
    self.openTableRequest.interfaceType = DotNET2;
    self.openTableRequest.postType      = JSON;
    self.openTableRequest.httpMethod    = @"POST";

    self.openTableRequest.uId           = userInfo.userId;//  用户id
    self.openTableRequest.merId         = self.merId;
    self.openTableRequest.btId          = self.btId;
    self.openTableRequest.mobile        = userInfo.mobilePhone;
    
  WS(weakSelf);
    [self.openTableRequest sendReuqest:^(id result, NSError *error)
     {
         
      
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 
                 [weakSelf openSuccessView];
               //  [_openBtn setEnabled:YES];
                 
             }else{
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"获取球台信息失败"];
               //  [_openBtn setEnabled:YES];
             }
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
             //[_openBtn setEnabled:YES];
         }
         self.view.userInteractionEnabled = YES;
         //[HYLoadHubView dismiss];
          [PageBaseLoading hide_Load];
     }];
}

- (void)openSuccessView{
    
    FLCustomAlertView *alertView = [[FLCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-94, 165) TheViewType:OneButton_TitleMessage];
    // 开台号和文字拼接
    NSString *subTitleStr = self.billiardsTableInfo.TableName;
    
    [alertView setTitle:@"成功开台" TitleColor:[UIColor colorWithHexString:@"0xb80000"] subTitle:subTitleStr AndSubTitleColor:[UIColor colorWithHexString:@"0x343434"] andMessage:@"再扫一扫二维码,可购买酒水或者收台" MessageColor:[UIColor colorWithHexString:@"0x343434"]];
    
    [alertView setTitleLabeltextFont:[UIFont systemFontOfSize:23]];
    
    [alertView setOkButtonWithTitle:@"我知道了" TitleColor:[UIColor colorWithHexString:@"606060"] BackgroundColor:[UIColor whiteColor]];
    // 按钮点击事件回调
    WS(weakSelf);
    [alertView buttonClickBlock:^(FLCAlertViewBtnTag tag) {
        switch (tag) {
            case ButtonTag_OkBtn:
            {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }];
    [alertView show];
}

- (void)setupUserInterface{

    UIImageView *TSHImageV = [[UIImageView alloc] init];
    [TSHImageV sd_setImageWithURL:[NSURL URLWithString:self.billiardsTableInfo.MerchantLogo] placeholderImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:TSHImageV];
    

    WS(weakSelf)
    [TSHImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.mas_equalTo(currentDeviceType() == iPhone4_4S ? 30 : ScaleHEIGHT(110));
        make.size.mas_equalTo(currentDeviceType() == iPhone4_4S ? CGSizeMake(90, 90): CGSizeMake(120, 120));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:self.billiardsTableInfo.MerchantName];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(TSHImageV.mas_bottom).offset(currentDeviceType() == iPhone4_4S ? 20 : g_fitFloat(@[@40,@60,@80]));
    }];
    
    UILabel *tableLable = [[UILabel alloc] init];
    [tableLable setText:self.billiardsTableInfo.TableName];
    [tableLable setFont:[UIFont systemFontOfSize:25]];
    [tableLable setTextColor:[UIColor colorWithHexString:@"343434"]];
    [tableLable setNumberOfLines:0];
    [tableLable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:tableLable];
    
    [tableLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    
    UILabel *priceDes = [[UILabel alloc] init];
   
    [priceDes setFont:[UIFont systemFontOfSize:14]];
    [priceDes setTextColor:[UIColor colorWithHexString:@"343434"]];
    [priceDes setNumberOfLines:0];
    [priceDes setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:priceDes];
    
    [priceDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(tableLable.mas_bottom).offset(g_fitFloat(@[@20,@25,@30]));
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [priceLabel setTextColor:[UIColor colorWithHexString:@"b80000"]];
    [priceLabel setNumberOfLines:0];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(priceDes.mas_bottom).offset(10);
    }];
    
    CGFloat money = _billiardsTableInfo.RateByHour.floatValue;
    CGFloat coupon = _billiardsTableInfo.RateCoupon.floatValue;
    
    if(money == 0 && coupon != 0){
        [priceDes setText:@"收费标准"];
        priceLabel.text  = [NSString stringWithFormat:@"开台时段会员价：%@现金券/小时",_billiardsTableInfo.RateCoupon];
        
    }else if (money != 0 && coupon == 0){
        [priceDes setText:@"收费标准"];
        priceLabel.text  = [NSString stringWithFormat:@"开台时段会员价：￥%@/小时",_billiardsTableInfo.RateByHour];
        
    }else if (money != 0 && coupon != 0){
        [priceDes setText:@"收费标准"];
        priceLabel.text  = [NSString stringWithFormat:@"开台时段会员价：￥%@ + %@现金券/小时",_billiardsTableInfo.RateByHour,_billiardsTableInfo.RateCoupon];
    }
    
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    [originalPriceLabel setText:[NSString stringWithFormat:@"原价:￥%@/小时",self.billiardsTableInfo.RateCostPrice]];
    [originalPriceLabel setFont:[UIFont systemFontOfSize:12]];
    [originalPriceLabel setTextColor:[UIColor colorWithHexString:@"a7a7a7"]];
    [originalPriceLabel setNumberOfLines:0];
    [originalPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:originalPriceLabel];
    
    [originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:[UIColor colorWithHexString:@"a7a7a7"]];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(originalPriceLabel.mas_left);
        make.right.mas_equalTo(originalPriceLabel.mas_right);
        make.centerY.mas_equalTo(originalPriceLabel.mas_centerY);
        make.width.mas_equalTo(originalPriceLabel.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *desLabel = [[UILabel alloc] init];
    [desLabel setText:@"（不同时段有不同折扣）"];
    [desLabel setFont:[UIFont systemFontOfSize:12]];
    [desLabel setTextColor:[UIColor colorWithHexString:@"a7a7a7"]];
    [desLabel setNumberOfLines:0];
    [desLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:desLabel];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-10);
        make.top.equalTo(originalPriceLabel.mas_bottom).offset(5);
    }];
    
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openBtn setTitle:@"确认开台" forState:UIControlStateNormal];
    [_openBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_openBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
    [_openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_openBtn];
    
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(50);
    }];
    
    
}

- (void)openBtnAction{

    self.view.userInteractionEnabled = NO;
    [self openTheTable];
}

- (void)backToRootViewController:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [PageBaseLoading hiddeLoad_anyway];
    [_openTableRequest cancel];
    _openTableRequest = nil;
    [_tableInfoRequest cancel];
    _tableInfoRequest = nil;

    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
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

@end
