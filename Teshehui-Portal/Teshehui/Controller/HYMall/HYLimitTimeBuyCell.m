//
//  HYLimitTimeBuyCell.m
//  Teshehui
//
//  Created by HYZB on 15/12/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYLimitTimeBuyCell.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"
#import "HYSeckillGoodsListModel.h"


typedef NS_ENUM(NSUInteger, ActionBtnType)
{ // 按钮显示状态
    kActionBtnTypeEmpty = 1, // 原价购买
    kActionBtnTypeStock = 2, // 立即抢购
    kActionBtnTypeRemind = 3, // 提醒我
    kActionBtnTypeCancelRemind = 4, // 取消提醒
};

@interface HYLimitTimeBuyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *limitTimeBuyIcon;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrimeRatePrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsPoints;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (nonatomic, strong) UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsStore;
@property (weak, nonatomic) IBOutlet UILabel *alreadeMarkNumber;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) UIProgressView *progress;

@property (nonatomic, strong) UIImageView *emptyImg;

@property (nonatomic, assign) ActionBtnType btnType;

@end

@implementation HYLimitTimeBuyCell

- (void)awakeFromNib {
    
    self.goodsImageView.frame = CGRectMake(10, 10, 100, 100);
    
    UIImageView *emptyImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    emptyImg.image = [UIImage imageNamed:@"icon_secondkill_stockenpty"];
    emptyImg.hidden = YES;
    _emptyImg = emptyImg;
    [self.goodsImageView addSubview:emptyImg];
    
    self.goodsName.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 0, TFScalePoint(200), 40);
    self.goodsPrimeRatePrice.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 40, TFScalePoint(50), 20);
    self.goodsPoints.frame = CGRectMake(CGRectGetMaxX(self.goodsPrimeRatePrice.frame), 40, TFScalePoint(100), 20);
    self.goodsPrice.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 60, TFScalePoint(50), 20);
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 70, TFScalePoint(50), 1);
//    self.goodsStore.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 90, TFScalePoint(100), 20);
    
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.actionBtn];
    [self.actionBtn addTarget:self action:@selector(actionBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.actionBtn.titleLabel.textColor = [UIColor whiteColor];
    self.actionBtn.frame = CGRectMake(TFScalePoint(230), 50, TFScalePoint(80), 35);
//    [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"btn3"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.actionBtn.frame), CGRectGetMaxY(self.actionBtn.frame)+15, CGRectGetWidth(self.actionBtn.frame), 20)];
    _progress = progress;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    progress.transform = transform;
    progress.progressViewStyle = UIProgressViewStyleBar;
    progress.progressImage = [[UIImage imageNamed:@"icon_progress_content"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    progress.trackImage = [[UIImage imageNamed:@"icon_progress_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [self addSubview:progress];
    
//    self.alreadeMarkNumber.frame = CGRectMake(CGRectGetMinX(progress.frame)-TFScalePoint(120), CGRectGetMinY(progress.frame)-3, TFScalePoint(130), 20);
    self.alreadeMarkNumber.textAlignment = NSTextAlignmentRight;
    
    self.limitTimeBuyIcon.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfoWithModel:(HYSeckillGoodsListModel *)model andActivityStatus:(NSString *)status
{
    _model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.productPicUrl] placeholderImage:[UIImage imageNamed:@"loadingpic"]];
    self.goodsName.text = model.productName;
    
    CGSize goodsPrimeRatePriceSize = [model.seckillPrice sizeWithFont:[UIFont systemFontOfSize:15]];
    self.goodsPrimeRatePrice.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 35, goodsPrimeRatePriceSize.width + 15, 20);
    self.goodsPoints.frame = CGRectMake(CGRectGetMaxX(self.goodsPrimeRatePrice.frame), 35, TFScalePoint(100), 20);
    self.goodsPrimeRatePrice.text = [NSString stringWithFormat:@"￥%@", model.seckillPrice];
    self.goodsPoints.text = [NSString stringWithFormat:@"+%ld现金券", (long)model.point];
    
    CGSize goodsPriceSize = [model.marketPrice sizeWithFont:[UIFont systemFontOfSize:14]];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@", model.marketPrice];
    self.goodsPrice.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 10, 60, goodsPriceSize.width + 15, 20);
    
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.goodsImageView.frame) + 15, 70, goodsPriceSize.width + 15, 1);
    
//    self.goodsStore.text = [NSString stringWithFormat:@"抢购库存: %ld件", model.totalStock];
    
    if ([model.isShowSeckillIcon integerValue] == 0) {
        
        self.limitTimeBuyIcon.hidden = YES;
    } else if ([model.isShowSeckillIcon integerValue] == 1) {
        
        self.limitTimeBuyIcon.hidden = NO;
    }
    
    // 活动状态活动状态 10:待审核；20：即将开始；21：审核不通过；30：抢购中；40：已结束；99：活动已删除；
    
    // 假数据
    // status = @"30";
   // status = @"40";
    ActivityStatus Astatus = [status integerValue];
    if (Astatus == ActivityBegin) {
        
        long int num = model.totalStock - model.stock;
        CGFloat goodsPercent = num / (CGFloat)model.totalStock;
        
        if (goodsPercent == 1)
        {
            self.alreadeMarkNumber.text = @"秒杀已完，现在只能原价购买";
        }
        else
        {
            self.alreadeMarkNumber.text = [NSString stringWithFormat:@"已秒%.0f%%", goodsPercent*100];
        }
        [_progress setProgress:goodsPercent];
        if (model.stock == 0) {
            
            // stock":"剩余库存数 stock = 0
            _btnType = kActionBtnTypeEmpty;
            _emptyImg.hidden = NO;
//            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"btn4"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            // 215 19 19
            self.actionBtn.backgroundColor = [UIColor whiteColor];
            self.actionBtn.layer.borderColor = [UIColor redColor].CGColor;
            self.actionBtn.layer.borderWidth = 1.0f;
            [self.actionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"原价也要买" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _alreadeMarkNumber.frame = CGRectMake(TFScalePoint(160), CGRectGetMinY(_progress.frame)-3, TFScalePoint(150), 20);
            _progress.hidden = YES;
        } else {
            
            // stock != 0
            _btnType = kActionBtnTypeStock;
            _emptyImg.hidden = YES;
//            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"btn3"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            self.actionBtn.backgroundColor = [UIColor colorWithRed:215/255.0f green:19/255.0f blue:19/255.0f alpha:1.0f];
            [self.actionBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _alreadeMarkNumber.frame = CGRectMake(CGRectGetMinX(_progress.frame)-TFScalePoint(120), CGRectGetMinY(_progress.frame)-3, TFScalePoint(110), 20);
            _progress.hidden = NO;
        }
    } else if (Astatus == ActivityWaitBegin) {
        
        _progress.hidden = YES;
        self.alreadeMarkNumber.text = [NSString stringWithFormat:@"已有%@人设置提醒", model.totalRemindNum];
        _alreadeMarkNumber.frame = CGRectMake(TFScalePoint(160), CGRectGetMinY(_progress.frame)-3, TFScalePoint(150), 20);
        // isHaveReminded":"是否已提醒0：未提醒；1：已提醒  isHaveReminded = 0
        
        // 假数据
        // model.isHaveReminded = 1;
        if (model.isHaveReminded == 0)
        {
            _btnType = kActionBtnTypeRemind;
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                            resizingMode:UIImageResizingModeStretch]
                                      forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"提醒我" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            
            // isHaveReminded = 1
            _btnType = kActionBtnTypeCancelRemind;
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"取消提醒" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor colorWithRed:46/255.0f green:148/255.0f blue:45/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 点击事件
- (void)actionBtnDidClicked:(UIButton *)btn
{
    if (_btnType == kActionBtnTypeEmpty || _btnType == kActionBtnTypeStock)
    {
        if ([self.delegate respondsToSelector:@selector(actionWithModel:)])
        {
           [self.delegate actionWithModel:_model];
        }
    }
    else if (_btnType == kActionBtnTypeRemind)
    {
        if ([self.delegate respondsToSelector:@selector(addRemindWithBtn:)])
        {
            [self.delegate addRemindWithBtn:btn];
        };
    }
    else if (_btnType == kActionBtnTypeCancelRemind)
    {
        if ([self.delegate respondsToSelector:@selector(cancelRemindWithBtn:)])
        {
            [self.delegate cancelRemindWithBtn:btn];
        }
    }
}

@end
