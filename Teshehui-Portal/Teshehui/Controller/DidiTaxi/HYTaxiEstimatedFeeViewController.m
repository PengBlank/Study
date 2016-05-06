//
//  HYTaxiEstimatedFeeViewController.m
//  Teshehui
//
//  Created by Kris on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiEstimatedFeeViewController.h"

@interface HYTaxiEstimatedFeeViewController ()
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *startPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *milesPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLab;

@end

@implementation HYTaxiEstimatedFeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"价格预估";
    
    _containView.layer.cornerRadius = 10;
    _containView.layer.borderColor = [UIColor colorWithWhite:.93 alpha:1.0].CGColor;
    _containView.layer.borderWidth = 2;
    
    if (_taxiFeeModel)
    {
        _startPriceLab.text = [NSString stringWithFormat:@"%@元", _taxiFeeModel.startPrice];
        _totalFeeLab.text = [NSString stringWithFormat:@"%@元", _taxiFeeModel.carTypeFee];
        _milesPriceLab.text = [NSString stringWithFormat:@"%@元", _taxiFeeModel.normalPrice];
        _totalFeeLab.textColor = [UIColor redColor];
    }
}


@end
