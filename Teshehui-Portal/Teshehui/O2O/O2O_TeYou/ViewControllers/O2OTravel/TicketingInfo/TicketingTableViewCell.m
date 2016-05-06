//
//  TicketingTableViewCell.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TicketingTableViewCell.h"
#import "TYTicketCountModel.h"

#define CellCSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation TicketingTableViewCell

- (void)awakeFromNib {
    // 背景图
    _viewBackground.layer.borderColor = CellCSS_ColorFromRGB(0xc7c7c7).CGColor;
    _viewBackground.layer.borderWidth = .6f;
//    self.viewBackground.layer.cornerRadius = 5.0;

    /*********这里是cell重用时，赋值************/
    // 成人票
    [self setStepperStyle:_stepperAdult];
    _stepperAdult.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
   
    // 儿童票
    [self setStepperStyle:_stepperChild];
    _stepperChild.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    
    /*********这里是点击加减时，调用父页面的方法进行总额计算************/
    TicketingTableViewCell * __weak weakSelf = self;
    // 成人票增減
    _stepperAdult.incrementCallback = ^(PKYStepper *stepper, float count) {
        [weakSelf TicketCellStepperValueChangedCallBack];
    };
    _stepperAdult.decrementCallback = ^(PKYStepper *stepper, float count) {
        [weakSelf TicketCellStepperValueChangedCallBack];
    };
    // 儿童票增減
    _stepperChild.incrementCallback = ^(PKYStepper *stepper, float count) {
        [weakSelf TicketCellStepperValueChangedCallBack];
    };
    _stepperChild.decrementCallback = ^(PKYStepper *stepper, float count) {
        [weakSelf TicketCellStepperValueChangedCallBack];
    };
}

// 选中的时候边框红色
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.viewBackground.layer.borderColor = CellCSS_ColorFromRGB(0xc7c7c7).CGColor;
        self.viewBackground.layer.borderWidth = .6f;
    }else{
        self.viewBackground.layer.borderColor = CellCSS_ColorFromRGB(0xff7200).CGColor;
        self.viewBackground.layer.borderWidth = 2.0f;
    }
}

// 设置两个增减器样式
- (void) setStepperStyle:(PKYStepper *)stepper {
    stepper.buttonWidth = 25.0f;
    [stepper setBorderColor:CellCSS_ColorFromRGB(0xa7a7a7)];
    [stepper setBorderWidth:.5f];
    [stepper setLabelColor:CellCSS_ColorFromRGB(0xa7a7a7)];
    [stepper setLabelTextColor:CellCSS_ColorFromRGB(0x343434)];
    [stepper setLabelFont:[UIFont systemFontOfSize:12.0f]];
    [stepper setButtonTextColor:[UIColor colorWithRed:167/255.0 green:0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
    [stepper setButtonFont:[UIFont systemFontOfSize:22.0]];
    [stepper.incrementButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)]; // 调整加减符号位置
    [stepper.decrementButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
}

//　增减门票后回调
- (void) TicketCellStepperValueChangedCallBack {
    [self setTicketCountSelectedImageHidden];
   if (_stepperChanged) {
        self.stepperChanged(_stepperAdult.value,_stepperChild.value,_indexPath);
    }
}

// 设置右上角已选标记显示与否
- (void) setTicketCountSelectedImageHidden{
    if (_stepperAdult.value > .0f || _stepperChild.value > .0f) {
        self.imgSelected.hidden = NO;
    }else{
        self.imgSelected.hidden = YES;
    }
}
- (NSString *)getStringWithFloatCount:(float)fCount{
   return [NSString stringWithFormat:@"%@",@(fCount)];
}
// 绑定数据
- (void) configureCell:(TravelSightInfo *)sInfo TicketCount:(NSDictionary *)dicCount atIndexPath:(NSIndexPath *)indexPath{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _indexPath          = indexPath;
    _lblTicketName.text = sInfo.ticketName;
    _lblDays.text       = [NSString stringWithFormat:@"使用天数:%@天",sInfo.days];
    _lblPriceAdult.text = [NSString stringWithFormat:@"￥%@+%@现金券/张",sInfo.tshAdultPrice,sInfo.tshAdultCoupon];
    _lblPriceChild.text = [NSString stringWithFormat:@"￥%@+%@现金券/张",sInfo.tshChildPrice,sInfo.tshChildCoupon];
    [self setPriceLabel:_lblPriceAdultOriginal AttributedString:sInfo.adultPrice];
    [self setPriceLabel:_lblPriceChildOriginal AttributedString:sInfo.childPrice];

    NSString *key = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    if (dicCount[key] && (![dicCount[key] isKindOfClass:[NSNull class]])) {
        TYTicketCountModel *tModel = dicCount[key];
        _stepperAdult.countLabel.text = [self getStringWithFloatCount:tModel.countAdilt];
        _stepperChild.countLabel.text = [self getStringWithFloatCount:tModel.countChild];
        _stepperAdult.value = tModel.countAdilt;
        _stepperChild.value = tModel.countChild;
    }else{
        _stepperAdult.countLabel.text = @"0";
        _stepperChild.countLabel.text = @"0";
        _stepperAdult.value = 0.0f;
        _stepperChild.value = 0.0f;
    }
    [self setTicketCountSelectedImageHidden];
}
// 加删除线
- (void) setPriceLabel:(UILabel *)lbl AttributedString:(NSString *)attri {
    attri = [NSString stringWithFormat:@"原价:￥%@/张",attri];
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:attri
                                  attributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],
    NSForegroundColorAttributeName:[UIColor lightGrayColor],
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:[UIColor lightGrayColor]}];
    
    lbl.attributedText = attrStr;
}
@end
