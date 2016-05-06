//
//  DrinksListCell.m
//  zuoqiu
//
//  Created by wujianming on 15/11/5.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#define kSreenH [UIScreen mainScreen].bounds.size.height
#define IS_IPHONE_6  (kSreenH == 667.0)
#define IS_IPHONE_6S  (kSreenH > 667.0)

#import "DrinksListCell.h"
#import "PKYStepper.h"
#import "Masonry.h"
#import "TYDrinksListInfo.h"

@implementation DrinksListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"DrinksListCell";
    DrinksListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (!cell) {
        cell = [[DrinksListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        
        // 商品名称
        _CommodityName = [[UILabel alloc] init];
      //  _CommodityName.backgroundColor = [UIColor orangeColor];
        [self addSubview:_CommodityName];
        _CommodityName.numberOfLines = 0;
        _CommodityName.font = [UIFont systemFontOfSize:13];
        
        [_CommodityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(10);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(IS_IPHONE_6? @100 : IS_IPHONE_6S ? @120 : @70);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        }];
        
        // 原价
        _OriginalPrice = [[UILabel alloc] init];
        [self addSubview:_OriginalPrice];
        _OriginalPrice.numberOfLines = 0;
        _OriginalPrice.textAlignment = NSTextAlignmentCenter;
        _OriginalPrice.font = [UIFont systemFontOfSize:13];
        
        [_OriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.CommodityName.mas_right);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(@40);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        }];
        
//        // 数量
        _countSteper = [[PKYStepper alloc] init];
        _countSteper.buttonWidth = IS_IPHONE_6 ? 30 : 25;
        [_countSteper setBorderWidth:0.5];
        [_countSteper setBorderColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1]];
        [_countSteper setLabelColor:[UIColor lightGrayColor]];
        [_countSteper setLabelTextColor:[UIColor grayColor]];
        [_countSteper setButtonTextColor:[UIColor colorWithRed:167/255.0 green:0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
        [_countSteper setButtonFont:[UIFont systemFontOfSize:25.0]];
        _countSteper.incrementButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_countSteper.incrementButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
        _countSteper.decrementButton.titleEdgeInsets = UIEdgeInsetsMake(-4, 0, 0, 0);
        [_countSteper.decrementButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
        
        _countSteper.valueChangedCallback = ^(PKYStepper *stepper, float count) { // 加减按钮点击回调
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
            if (weakSelf.steperClick) {
                weakSelf.steperClick(weakSelf.indexpath,count);
            }
        };
        [_countSteper setup];
        [self addSubview:_countSteper];
        
        [_countSteper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(IS_IPHONE_6 ? @90 : @80);
            make.top.mas_equalTo(weakSelf.mas_top).offset(10);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-10);
        }];
        
        // 特奢汇价
        _TSHPrice = [[UILabel alloc] init];
        [self addSubview:_TSHPrice];
        _TSHPrice.numberOfLines = 0;
        _TSHPrice.textAlignment = NSTextAlignmentCenter;
        _TSHPrice.font = [UIFont systemFontOfSize:13];
        
        [_TSHPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.OriginalPrice.mas_right).offset(IS_IPHONE_6S ? 20 : 0);
            make.right.mas_equalTo(weakSelf.countSteper.mas_left).offset(IS_IPHONE_6 ? -10 : 0);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        }];

    }
    
    return self;
}

- (void)binddata:(NSIndexPath *)indexPath goodsInfo:(goodsInfo *)info {
    
    if (info == nil) {
        return;
    }
    
    _indexpath = indexPath; // 当前cell的位置
    _CommodityName.text = info.productName; // 商品名称
    _countSteper.value = info.buyAmount ; // 商品数量
    
    
    NSString *tmpString = [self formatFloatString:info.salePrice];
    _OriginalPrice.text = [NSString stringWithFormat:@"￥%@",tmpString];
    
    
     NSString *tmpProductString = [self formatFloatString:info.productCash];
    if (info.productCoupon.length > 0) {
        _TSHPrice.text = [NSString stringWithFormat:@"￥%@+%@现金券", tmpProductString, info.productCoupon];
    } else {
        _TSHPrice.text = [NSString stringWithFormat:@"￥%@", tmpProductString];
    }
}

- (NSString *)formatFloatString:(NSString *)string{

    NSRange tmpRange = [string rangeOfString:@"."];
    NSString *tmpString = @"";
    
    if(tmpRange.location != NSNotFound){
        
        tmpString = [string substringWithRange:NSMakeRange(tmpRange.location + 1, string.length - tmpRange.location - 1)];
        DebugNSLog(@"tmpString == %@",tmpString);
        
        if (tmpString.floatValue == 0) {
            tmpString = [NSString stringWithFormat:@"%.0f",string.floatValue];
        }else{
            tmpString = [NSString stringWithFormat:@"%.1f",string.floatValue];
        }
        
    }else{
        tmpString = string;
    }
    
    return tmpString;
}

@end
