//
//  HYProductSummaryCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductSummaryCell.h"
#import "HYStrikeThroughLabel.h"
#import "UIImage+Addition.h"
#import "METoast.h"
#import "NSBKeyframeAnimation.h"
#import "HYExpensiveExplainView.h"
#import "HYUserInfo.h"
#import "HYProductQrcodeView.h"
#import "HYQuantityControl.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "HYAppDelegate.h"
#import "UMSocial.h"

#import "HYExpensiveExplainRequest.h"
#import "HYMallApplaudRequest.h"
#import "HYProductPraiseAnimation.h"
#import "HYAnalyticsManager.h"
#import "Masonry.h"
#import "HYImageButton.h"

@interface HYProductSummaryCell ()
{
    UILabel *_descLab;
    UILabel *_priceLab;
    UILabel *_pointLab;
    UILabel *_payAmountLab;
    UIImageView *_saveBgView;
    UIImageView *_saveIconView;
    HYImageButton *_praiseBtn;
    
    HYStrikeThroughLabel *_marketPriceLab;
    
    BOOL _isLoading;
    
    HYMallApplaudRequest *_applaudReq;
}

//@property (nonatomic, strong) UIButton *discount;  //折扣
@property (nonatomic, strong) HYQuantityControl *quantityControl;  //增加数量

@property (nonatomic, strong) UIButton *rightBtn;  //维权

@property (nonatomic, strong) UIImageView *cameraView;  //视频动画

@property (nonatomic, strong) HYExpensiveExplainRequest *expensiveRequest;

@end

@implementation HYProductSummaryCell

- (void)dealloc
{
    [_expensiveRequest cancel];
    _expensiveRequest = nil;
    
    [HYLoadHubView dismiss];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat org_x = 10;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(org_x,
                                                                  4,
                                                                  CGRectGetWidth(ScreenRect)-2*org_x,
                                                                  TFScalePoint(100)+116)];
        [self.contentView addSubview:bgView];
        
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, CGRectGetWidth(bgView.frame)-60, 36)];
        _descLab.font = [UIFont systemFontOfSize:15];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.textAlignment = NSTextAlignmentLeft;
        _descLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _descLab.numberOfLines = 0;
        _descLab.textColor = [UIColor blackColor];
        [bgView addSubview:_descLab];
        
        _praiseBtn = [HYImageButton buttonWithType:UIButtonTypeCustom];
        _praiseBtn.frame = CGRectMake(CGRectGetMaxX(bgView.frame)-50,
                                        0,
                                        50,
                                        50);
        _praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_praiseBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_praiseBtn setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"applaud_norml"]
                    forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"applaud_select"]
                    forState:UIControlStateDisabled];
        _praiseBtn.type = ImageButtonTypeVerticle;
        [_praiseBtn addTarget:self
                       action:@selector(praiseEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_praiseBtn];
        
        //vertical line
        UIView *vLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_praiseBtn.frame)+4, 8, 1, 34)];
        vLine.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:vLine];
        
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, bgView.frame.size.width/2, 20)];
        _priceLab.font = [UIFont boldSystemFontOfSize:24];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textColor = [UIColor redColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:_priceLab];
        
        _pointLab = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(CGRectGetMaxX(_priceLab.frame),
                                                                      55,
                                                                      bgView.frame.size.width/2,
                                                                      14)];
        _pointLab.font = [UIFont systemFontOfSize:14];
        _pointLab.backgroundColor = [UIColor redColor];
        _pointLab.textColor = [UIColor whiteColor];
        _pointLab.textAlignment = NSTextAlignmentCenter;
        _pointLab.layer.cornerRadius = 2;
        _pointLab.layer.masksToBounds = YES;
        [bgView addSubview:_pointLab];
        
        //add
//        _quantityControl = [[HYQuantityControl alloc] initWithFrame:TFRectMake(96, 70, 108, 36)];
//        [_quantityControl addTarget:self
//                             action:@selector(quantityChangeEvent:)
//                   forControlEvents:UIControlEventValueChanged];
//        [bgView addSubview:_quantityControl];
        
        _payAmountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, 200, 20)];
        _payAmountLab.font = [UIFont systemFontOfSize:16];
        _payAmountLab.backgroundColor = [UIColor clearColor];
        _payAmountLab.textColor = [UIColor colorWithRed:0
                                                  green:112.0/255.0
                                                   blue:223.0/255.0
                                                  alpha:1.0];
        _payAmountLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:_payAmountLab];
        
        //horizonal line
        UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_payAmountLab.frame)+10, bgView.frame.size.width, 1)];
        hLine.backgroundColor = [UIColor colorWithWhite:.94 alpha:1.0f];
        [bgView addSubview:hLine];
        
        //贵就赔
        NSString *pathGuijiupei = [NSString stringWithFormat:@"%@/productDetail_fake.png",[[NSBundle mainBundle]resourcePath]];
        UIImage *guijiupei = [UIImage imageWithContentsOfFile:pathGuijiupei];
        UIImageView *imgGuiView = [[UIImageView alloc]initWithImage:guijiupei];
        imgGuiView.frame = CGRectMake(0,
                                      CGRectGetMaxY(_payAmountLab.frame)+18,
                                      bgView.frame.size.width,
                                      bgView.frame.size.width*0.125);
        imgGuiView.userInteractionEnabled = YES;
        [bgView addSubview:imgGuiView];
        
        //正品保障
        NSString *pathBaoxian = [NSString stringWithFormat:@"%@/productDetail_quality.png",[[NSBundle mainBundle]resourcePath]];
        UIImage *baoxian = [UIImage imageWithContentsOfFile:pathBaoxian];
        UIImageView *imgBaoxianView = [[UIImageView alloc]initWithImage:baoxian];
        imgBaoxianView.frame = CGRectMake(0, CGRectGetMaxY(imgGuiView.frame)+6, bgView.frame.size.width, bgView.frame.size.width * 0.18);
        [bgView addSubview:imgBaoxianView];
        
        UIButton *checkDescBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [checkDescBtn setFrame:CGRectMake(0,
                                          CGRectGetMaxY(_payAmountLab.frame)+18,
                                          bgView.frame.size.width,
                                          50+CGRectGetHeight(imgBaoxianView.frame))];
        [checkDescBtn addTarget:self
                         action:@selector(checkServiceDescEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:checkDescBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(CGRectGetMidX(_praiseBtn.frame)-TFScalePoint(30)/2,
                                     54,
                                     TFScalePoint(30),
                                     TFScalePoint(30));
        [_rightBtn setImage:[UIImage imageNamed:@"weiquan"]
                   forState:UIControlStateNormal];
        [_rightBtn addTarget:self.delegate
                             action:@selector(beginRighting)
                   forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_rightBtn];
    }
    return self;
}

#pragma mark public methods
- (void)showComparePriceButton
{
//    _comparePriceBtn.hidden = NO;
}

#pragma mark - private methods
- (void)checkServiceDescEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(checkServiceDesc)])
    {
        [self.delegate checkServiceDesc];
    }
}
/*
 * 播放动画
 */
- (void)cameraPlay
{
    NSString *trimmedString = [self.goodsDetail.productVideoUrl stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:trimmedString];
    if ([self.delegate respondsToSelector:@selector(playVideoWithUrl:)] && url)
    {
        [self.delegate playVideoWithUrl:url];
    }
}

- (void)praiseEvent:(id)sender
{
    //喜欢
    if (self.goodsDetail.productId)
    {
        NSDictionary *dict = @{@"ProudctID":self.goodsDetail.productId};
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_xihuan_jishu" attributes:dict];
    }
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    if (user.userId)
    {
        [HYLoadHubView show];
        
        if (!_isLoading)
        {
            _isLoading = YES;
            
            _applaudReq = [[HYMallApplaudRequest alloc] init];
            _applaudReq.goodsId = self.goodsDetail.productId;
            _applaudReq.productName = self.goodsDetail.productName;
            _applaudReq.userid = [HYUserInfo getUserInfo].userId;
            
            __weak typeof(self) b_self = self;
            [_applaudReq sendReuqest:^(id result, NSError *error) {
                BOOL succ = NO;
                NSString *desc = nil;
                if ([result isKindOfClass:[HYMallApplaudResponse class]])
                {
                    HYMallApplaudResponse *response = (HYMallApplaudResponse *)result;
                    succ = response.status == 200;
                    
                    if (response.status != 200 && response.code == 100)
                    {
                        desc = response.rspDesc;
                        succ = YES;
                    }
                }
                
                [b_self updatePraiseResult:succ error:error desc:desc];
            }];
            
            //统计
            HYFeedbackItemInfo *item = [[HYFeedbackItemInfo alloc] init];
            item.item_code = self.goodsDetail.productId;
            item.category_code = self.goodsDetail.categoryId;
            item.brand_code = self.goodsDetail.brandId;
            item.tsh_price = self.goodsDetail.currentsSUK.price;
            
            [[[HYAnalyticsManager alloc] init] feedbackEventWith:[NSArray arrayWithObject:item]
                                                            type:@"4"
                                                           stgid:self.stgId];
        }
    }
    else
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
}

- (void)updatePraiseResult:(BOOL)result
                     error:(NSError *)error
                      desc:(NSString *)desc
{
    _isLoading = NO;
    
    [HYLoadHubView dismiss];
    [_praiseBtn setEnabled:!result];
    
    self.goodsDetail.isPraise = result;
    
    if (result)
    {
        //本地点赞+1
        self.goodsDetail.favorCount = [NSString stringWithFormat:@"%d",
                                       (int)_goodsDetail.favorCount.integerValue+1];
        NSString *praiseCount = [NSString stringWithFormat:@"%@",_goodsDetail.favorCount];
        [_praiseBtn setTitle:praiseCount forState:UIControlStateNormal];
        
        if (!desc)
        {
            [HYProductPraiseAnimation showAnimationWithPoints:1 callback:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:desc
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"升级",
                                      nil];
            [alertView show];
        }
    }
    else
    {
        if (error && !desc)
        {
            [METoast toastWithMessage:error.domain];
        }
    }
}

- (void)setPlayAnimations:(BOOL)play
{
    if (![_cameraView isHidden])
    {
        [_cameraView startAnimating];
    }
}

- (void)beginComparing
{
    if ([self.delegate respondsToSelector:@selector(comparePrice)])
    {
        [self.delegate comparePrice];
    }
}

- (void)quantityChangeEvent:(id)sender
{
    HYQuantityControl *ctr = (HYQuantityControl *)sender;
    
    //    NSInteger quantity = [(HYQuantityControl *)sender quantity];
    
    //    if (quantity > self.goodsDetail.currentsSUK.stock.integerValue)
    //    {
    //        quantity = self.goodsDetail.currentsSUK.stock.integerValue;
    //        [(HYQuantityControl *)sender setQuantity:quantity];
    //
    //        [METoast toastWithMessage:@"商品库存不足！"];
    //    }
    //    else
    //    {
    if ([self.delegate respondsToSelector:@selector(quantityChange:callBack:)])
    {
        //商品数量+、-
        [MobClick event:@"v430_shangcheng_shangpinxiangqing_shangpinjiajian_jishu"];
        
        [ctr setEnabledAdd:NO];
        [ctr setEnabledMinus:NO];
        
        __weak typeof(_quantityControl) b_q = _quantityControl;
        [self.delegate quantityChange:ctr.quantity
                             callBack:^(BOOL finished) {
                                 if (finished)
                                 {
                                     [b_q setEnabledAdd:YES];
                                     [b_q setEnabledMinus:YES];
                                 }
                             }];
    }
    //    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(memberUpgrad)])
            {
                [self.delegate memberUpgrad];
            }
        });
        
    }
}

#pragma mark setter/getter
/*
- (UIImageView *)cameraView
{
    if (!_cameraView)
    {
        CGRect frame = CGRectMake(CGRectGetMidX(_comparePriceBtn.frame)-4, CGRectGetMidY(_comparePriceBtn.frame)-46 ,40,32) ;
        _cameraView = [[UIImageView alloc]initWithFrame:frame];
        _cameraView.image = [UIImage imageNamed:@"productDetail_camera1"];
        NSArray *gitArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"productDetail_camera1"],
                             [UIImage imageNamed:@"productDetail_camera2"],nil];
        _cameraView.animationImages = gitArray;
        _cameraView.animationDuration = 0.5;
        _cameraView.animationRepeatCount = MAX_INPUT;
        _cameraView.userInteractionEnabled = YES;
        [_cameraView startAnimating];
        [self.contentView addSubview:_cameraView];
        
        //视频点击事件
        UITapGestureRecognizer *camera = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(cameraPlay)];
        [_cameraView addGestureRecognizer:camera];
    }
    
    return _cameraView;
}
*/

- (void)setGoodsDetail:(HYMallGoodsDetail *)goodsDetail
{
    if (goodsDetail != _goodsDetail)
    {
        _goodsDetail = goodsDetail;
        _descLab.text = goodsDetail.productName;
    }
    
    _quantityControl.quantity = self.goodsDetail.currentsSUK.quantity;
    
    _marketPriceLab.text = goodsDetail.currentsSUK.marketPrice;
    if (goodsDetail.currentsSUK.price)
    {
        _payAmountLab.text = [NSString stringWithFormat:@"会员实付：%@元", goodsDetail.currentsSUK.price];
    }
    
    NSString *price = [NSString stringWithFormat:@"¥%0.2f", [goodsDetail.currentsSUK.marketPrice floatValue]];
    CGSize size = [price sizeWithFont:_priceLab.font
                    constrainedToSize:CGSizeMake(ScreenRect.size.width/2-15, _priceLab.font.lineHeight)];
    _priceLab.frame = CGRectMake(0,
                                 40,
                                 size.width+4,
                                 size.height);
    _priceLab.text = price;
    
    
    _pointLab.text = [NSString stringWithFormat:@"现金券可抵%@元", @([goodsDetail.currentsSUK.points intValue])];
    size = [_pointLab sizeThatFits:CGSizeMake(ScreenRect.size.width/2, _pointLab.font.lineHeight)];
    _pointLab.frame = CGRectMake(CGRectGetMaxX(_priceLab.frame)+5,
                                 CGRectGetMaxY(_priceLab.frame)-size.height-5,
                                 size.width+4,
                                 size.height);
    
    CGFloat width = _pointLab.frame.size.width+40;
    CGRect frame = _saveBgView.frame;
    frame.size.width = width;
    frame.origin.x = ScreenRect.size.width-40-width;
    _saveBgView.frame = frame;
    
    [_praiseBtn setEnabled:!self.goodsDetail.isPraise];
    NSString *praiseCount = @"0";
    if (goodsDetail.favorCount)
    {
        praiseCount = [NSString stringWithFormat:@"%@",goodsDetail.favorCount];
    }
    
    [_praiseBtn setTitle:praiseCount forState:UIControlStateNormal];
    
    if (self.goodsDetail.isSupportExpensive.intValue == 1)
    {
        
    }
    /*
    if ([goodsDetail.productVideoUrl length] > 0)
    {
        [self.cameraView startAnimating];
        self.cameraView.hidden = NO;
    }
    else
    {
        [_cameraView setHidden:YES];
    }
    */
}

@end
