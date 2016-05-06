//
//  HYQrcodeResultViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYQrcodeResultViewController.h"
#import "UIImage+Addition.h"
#import "HYProductParamInfoCell.h"
#import "HYMallGoodDetailRequest.h"
#import "HYMallAddShoppingCarReq.h"
#import "METoast.h"
#import "UIImageView+WebCache.h"
#import "HYProductImageInfo.h"
#import "HYUserInfo.h"

@interface HYQrcodeResultViewController ()
<UIGestureRecognizerDelegate,
UIAlertViewDelegate,
HYProductParamInfoCellDelegate>
{
    HYMallGoodDetailRequest *_getGoodDetailReq;
    HYMallAddShoppingCarReq *_addShopCarReq;
    
    BOOL _isLoading;
}
//@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottom;

@property (nonatomic, strong) UIImageView *productImage;
@property (nonatomic, strong) UILabel *productNameLab;
@property (nonatomic, strong) UILabel *productPriceLab;
@property (nonatomic, strong) UILabel *productPointLab;
@property (nonatomic, strong) HYProductParamInfoCell *productParamCell;
@property (nonatomic, strong) UIButton *addCartBtn;
@property (nonatomic, strong) UIButton *detailBtn;

@property (nonatomic, strong) HYMallGoodsDetail *goodsDetail;
@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, strong) UILabel *stockLab;


@end

@implementation HYQrcodeResultViewController

- (void)dealloc
{
    [_getGoodDetailReq cancel];
    _getGoodDetailReq = nil;
    
    [_addShopCarReq cancel];
    _addShopCarReq = nil;
}

- (void)showInView
{
    UIViewController *root = [[[UIApplication sharedApplication].delegate
                               window]
                              rootViewController];
    [root addChildViewController:self];
    
    if (!self.view.superview)
    {
        self.view.frame = root.view.bounds;
        [root.view addSubview:self.view];
    }
    
    __weak typeof(self) b_self = self;
    b_self.view.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        b_self.view.alpha = 1;
    }];
}

- (void)dismissInView
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.view.alpha = 0;
     } completion:^(BOOL finished)
     {
         [b_self.view removeFromSuperview];
         [b_self removeFromParentViewController];
     }];
    
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:ScreenRect];
    self.view.backgroundColor = [UIColor clearColor];
    UIView *mask = [[UIView alloc] initWithFrame:ScreenRect];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = .7;
    mask.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mask];
//    UIButton *maskbtn = [[UIButton alloc] initWithFrame:mask.bounds];
//    maskbtn.backgroundColor = [UIColor clearColor];
//    [maskbtn addTarget:self
//                action:@selector(tapAction:)
//      forControlEvents:UIControlEventTouchUpInside];
//    maskbtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [mask addSubview:maskbtn];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(ScreenRect)-40, CGRectGetHeight(ScreenRect)/2)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    UIView *bottom = [[UIView alloc] initWithFrame:
                      CGRectMake(CGRectGetMinX(_scrollView.frame),
                                 CGRectGetMaxY(_scrollView.frame)-50,
                                 CGRectGetWidth(_scrollView.frame),
                                 50)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    self.bottom = bottom;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    UIImage *img = [[UIImage imageNamed:@"mine_login"]
                    utilResizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIButton *addbtn = [[UIButton alloc] initWithFrame:
                        CGRectMake(CGRectGetWidth(bottom.frame)/4 - 45, 5, 90, 30)];
    [addbtn setBackgroundImage:img forState:UIControlStateNormal];
    [addbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addbtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addbtn addTarget:self
               action:@selector(cartAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:addbtn];
    self.addCartBtn = addbtn;
    
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:
                           CGRectMake(CGRectGetWidth(bottom.frame)/4*3 - 45, 5, 90, 30)];
    [detailBtn setBackgroundImage:img forState:UIControlStateNormal];
    [detailBtn setTitle:@"更多图文详情" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [detailBtn addTarget:self
               action:@selector(detailAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:detailBtn];
    self.detailBtn = detailBtn;
    
    //商品图片
    self.productImage = [[UIImageView alloc] initWithFrame:
                         CGRectMake(20, 20, 60, 60)];
    self.productImage.layer.borderWidth = 1.0;
    self.productImage.layer.borderColor = [UIColor colorWithWhite:.73 alpha:1].CGColor;
    [self.scrollView addSubview:self.productImage];
    
    //商品名
    self.productNameLab = [[UILabel alloc] initWithFrame:
                           CGRectMake(CGRectGetMaxX(_productImage.frame) + 10,
                                      CGRectGetMinY(_productImage.frame),
                                      CGRectGetWidth(_scrollView.frame)-CGRectGetMaxX(_productImage.frame)-30,
                                      40)];
    self.productNameLab.font = [UIFont systemFontOfSize:14.0];
    self.productNameLab.backgroundColor = [UIColor clearColor];
    self.productNameLab.textColor = [UIColor blackColor];
    self.productNameLab.numberOfLines = 0;
    [self.scrollView addSubview:_productNameLab];
    
    //价格
    _productPriceLab = [[UILabel alloc] initWithFrame:
                        CGRectMake(CGRectGetMinX(_productNameLab.frame),
                                   CGRectGetMaxY(_productNameLab.frame),
                                   0, 20)];
    _productPriceLab.font = [UIFont systemFontOfSize:14.0];
    _productPriceLab.backgroundColor = [UIColor clearColor];
    _productPriceLab.textColor = [UIColor redColor];
    [self.scrollView addSubview:_productPriceLab];
    
    //现金券
    _productPointLab = [[UILabel alloc] initWithFrame:
                        CGRectMake(CGRectGetMaxX(_productPriceLab.frame),
                                   CGRectGetMinY(_productPriceLab.frame),
                                   0, 20)];
    _productPointLab.font = [UIFont systemFontOfSize:14.0];
    _productPointLab.backgroundColor = [UIColor clearColor];
    _productPointLab.textColor = [UIColor redColor];
    [self.scrollView addSubview:_productPointLab];
    
    self.productParamCell = [[HYProductParamInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@""];
    self.productParamCell.hiddenLine = YES;
    self.productParamCell.delegate = self;
    self.productParamCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.productParamCell.frame = CGRectMake(10, CGRectGetMaxY(_productImage.frame)+10, CGRectGetWidth(_scrollView.frame)-20, 40);
    [self.scrollView addSubview:self.productParamCell];
    
    self.stockLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_productParamCell.frame)+10, CGRectGetWidth(_scrollView.frame)-20, 20)];
    _stockLab.font = [UIFont systemFontOfSize:14.0];
    _stockLab.backgroundColor = [UIColor clearColor];
    _stockLab.textColor = [UIColor blackColor];
    [self.scrollView addSubview:_stockLab];
    
    [self setContentShow:NO];
}

- (void)setContentShow:(BOOL)show
{
    if (show)
    {
        __weak typeof(self) b_self = self;
        [UIView animateWithDuration:.3 animations:^
         {
             b_self.scrollView.alpha = 1;
             b_self.bottom.alpha = 1;
         }
                         completion:^(BOOL finished)
         {
             
         }];
    }
    else
    {
        self.scrollView.alpha = 0;
        self.bottom.alpha = 0;
    }
}

- (void)updateViewWithProductDetail
{
    //self.productImage.image = [self.goodsDetail.images objectAtIndex:0];
    if (self.goodsDetail.currentsSUK.productSKUImagArray.count > 0)
    {
        HYImageInfo *imgInfo = [self.goodsDetail.currentsSUK.productSKUImagArray objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:imgInfo.defaultURL];
        [self.productImage sd_setImageWithURL:url
                             placeholderImage:nil];
    }
    else
    {
        NSString *imgurl = [self.goodsDetail.midImgList objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:imgurl];
        [self.productImage sd_setImageWithURL:url
                             placeholderImage:nil];
    }
    
    self.productParamCell.goodDetaiInfo = self.goodsDetail;
    self.productParamCell.frame = CGRectMake(10,
                                             CGRectGetMaxY(_productImage.frame)+10,
                                             CGRectGetWidth(_scrollView.frame)-20,
                                             self.goodsDetail.attributeHeigth+24);
    
    self.productNameLab.text = self.goodsDetail.productName;
    NSNumber *pricen = [NSNumber numberWithFloat:self.goodsDetail.currentsSUK.price.floatValue];
    self.productPriceLab.text = [NSString stringWithFormat:@"¥%@", pricen];
    [self.productPriceLab sizeToFit];
    
    self.productPointLab.text = [NSString stringWithFormat:@"消费%d现金券", self.goodsDetail.currentsSUK.points.intValue];
    [self.productPointLab sizeToFit];
    self.productPointLab.frame = CGRectMake(CGRectGetMaxX(_productPriceLab.frame) + 10,
                                            CGRectGetMinY(_productPointLab.frame),
                                            CGRectGetWidth(_scrollView.frame) - CGRectGetMaxX(_productPriceLab.frame) - 10,
                                            CGRectGetHeight(_productPointLab.frame));
    self.stockLab.frame = CGRectMake(20,
                                     CGRectGetMaxY(_productParamCell.frame),
                                     CGRectGetWidth(_scrollView.frame)-30,
                                     _stockLab.font.lineHeight);
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame),
                                             CGRectGetMaxY(_stockLab.frame) + 25);
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    if (self.goodsDetail.currentsSUK.stock > 0)
    {
        [_addCartBtn setEnabled:YES];
        self.quantity = 1;
    }
    else
    {
        [_addCartBtn setEnabled:NO];
        self.quantity = 0;
    }
    
    _stockLab.text = [NSString stringWithFormat:@"库存:%@", self.goodsDetail.currentsSUK.stock];
    
    [self setContentShow:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
//    self.goodsId = @"10682";
    if (self.goodsId)
    {
        [self getGoodsDetailInfo];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismissInView];
    if ([self.delegate respondsToSelector:@selector(resultViewControllerDidDismiss)])
    {
        [self.delegate resultViewControllerDidDismiss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据部分
/**
 *  获取商品详情
 */
- (void)getGoodsDetailInfo
{
    [HYLoadHubView show];
    
    _getGoodDetailReq = [[HYMallGoodDetailRequest alloc] init];
    _getGoodDetailReq.productId = self.goodsId;
    
    __weak typeof(self) b_self = self;
    [_getGoodDetailReq sendReuqest:^(id result, NSError *error) {
        [HYLoadHubView dismiss];
        
        if (!error && [result isKindOfClass:[HYMallGoodDetailResponse class]])
        {
            HYMallGoodDetailResponse *response = (HYMallGoodDetailResponse *)result;
            b_self.goodsDetail = response.goodDetailInfo;
            //设置默认的规格
//            b_self.productSpec = response.goodDetailInfo.priceInfo;
            [b_self updateViewWithProductDetail];
            [b_self setContentShow:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"获取商品详情失败"
                                                           delegate:b_self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

/**
 *  添加到购物车
 */
- (void)addProductToShopCar
{
    if (!_isLoading)
    {
        if ([self.goodsDetail.currentsSUK.productSKUId length] > 0)
        {
            _isLoading = YES;
            
            [HYLoadHubView show];
            
            HYUserInfo *user = [HYUserInfo getUserInfo];
            
            _addShopCarReq = [[HYMallAddShoppingCarReq alloc] init];
            _addShopCarReq.productSKUId = self.goodsDetail.currentsSUK.productSKUId;
            _addShopCarReq.userId = user.userId;
            _addShopCarReq.quantity = self.quantity;
            
            __weak typeof(self) b_self = self;
            [_addShopCarReq sendReuqest:^(id result, NSError *error) {
                BOOL succ = NO;
                if (!error && [result isKindOfClass:[HYMallAddOrdersResponse class]])
                {
                    HYMallAddOrdersResponse *response = (HYMallAddOrdersResponse *)result;
                    if (response.status == 200)
                    {
                        succ = YES;
                    }
                }
                
                [b_self updateAddShopCarResult:succ error:error];
            }];
        }
        else
        {
            [METoast toastWithMessage:@"请选择商品型号"];
        }
    }
}

- (void)updateAddShopCarResult:(BOOL)result error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (!error && result)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kShoppingCarHasNew];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /*
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"商品已成功加入购物车"
                                                      delegate:self
                                             cancelButtonTitle:@"再扫扫"
                                             otherButtonTitles:@"去结算", nil];
        [alert show];
         */
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"商品已成功加入购物车"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        // 返回首页
        [self dismissInView];
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(resultViewControllerDidAddCart)])
        {
            [self.delegate resultViewControllerDidAddCart];
        }
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self dismissInView];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(resultViewControllerDidDismiss)])
        {
            [self.delegate resultViewControllerDidDismiss];
        }
    }
    else
    {
        [self dismissInView];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(resultViewControllerDidAddCart)])
        {
            [self.delegate resultViewControllerDidAddCart];
        }
    }
}

#pragma mark - HYProductParamInfoCellDelegate
- (void)didSelectProductSKU:(HYProductSKU *)sku
{
    self.goodsDetail.currentsSUK = sku;
    [self updateViewWithProductDetail];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    CGPoint location = [gestureRecognizer locationInView:self.view];
//    if (CGRectContainsPoint(self.scrollView.frame, location))
//    {
//        return NO;
//    }
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.scrollView.frame, location))
    {
        return NO;
    }
    return YES;
}

- (void)cartAction:(UIButton *)btn
{
    [self addProductToShopCar];
}

- (void)detailAction:(UIButton *)btn
{
    [self dismissInView];
    if ([self.delegate respondsToSelector:@selector(resultViewControllerDidCheckDetail:)])
    {
        [self.delegate resultViewControllerDidCheckDetail:self.goodsId];
    }
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
