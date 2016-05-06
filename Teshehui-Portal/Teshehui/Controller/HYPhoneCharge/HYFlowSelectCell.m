//
//  HYFlowSelectCell.m
//  Teshehui
//
//  Created by Kris on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYFlowSelectCell.h"
#import "Masonry.h"
#import "UIView+GetImage.h"
#import "UIControl+BlocksKit.h"

@interface HYFlowSelectCell ()

@property (nonatomic, strong) UILabel *flowLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIButton *priceBtn;

@end

@implementation HYFlowSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf);
        _flowLab = [[UILabel alloc]init];
        _flowLab.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:_flowLab];
        [_flowLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIView *framev = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        framev.layer.borderColor = [UIColor redColor].CGColor;
        framev.layer.borderWidth = 1.0;
        framev.layer.cornerRadius = 4.0;
        UIImage *frameimage = [framev getImage];
        frameimage = [frameimage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
        framev.layer.borderColor = [UIColor colorWithWhite:.7 alpha:1].CGColor;
        UIImage *frameimagenormale = [[framev getImage] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
        
        
        UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [priceBtn setBackgroundImage:frameimage forState:UIControlStateSelected];
        [priceBtn setBackgroundImage:frameimagenormale forState:UIControlStateNormal];
        [priceBtn setBackgroundImage:frameimage forState:UIControlStateHighlighted];
        [priceBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [priceBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [priceBtn setTitleColor:[UIColor colorWithWhite:.7 alpha:1] forState:UIControlStateNormal];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:priceBtn];
        self.priceBtn = priceBtn;
        [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(70);
        }];
        [priceBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.chargeCallback) {
                weakSelf.chargeCallback(weakSelf.chargeModel);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
//        _priceLab = [[UILabel alloc]init];
//        [self.contentView addSubview:_priceLab];
//        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(weakSelf.contentView).with.offset(-10);
//            make.top.equalTo(weakSelf.contentView).with.offset(10);
//            make.size.mas_equalTo(CGSizeMake(40, 30));
//        }];
        
    }
    return self;
}

#pragma mark setter & getter
- (void)setData
{
    _flowLab.text = @"2M";
    [_priceBtn setTitle:@"3.00元" forState:UIControlStateNormal];
}

- (void)setChargeModel:(HYPhoneChargeModel *)chargeModel
{
    if (_chargeModel != chargeModel)
    {
        _chargeModel = chargeModel;
        self.flowLab.text = chargeModel.name;
        NSString *price = [NSString stringWithFormat:@"%.2f元", chargeModel.price.floatValue];
        [self.priceBtn setTitle:price forState:UIControlStateNormal];
    }
}

@end
