//
//  SceneBookDetailTabController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneBookDetailTabController.h"
#import "DefineConfig.h"

@interface SceneBookDetailTabController ()
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSavePrice;

@end

@implementation SceneBookDetailTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblPrice.text    = [NSString stringWithFormat:@"￥%@+%@现金券",_detailInfo.thsPrice,_detailInfo.coupon];
//    _lblPrice.font    = [UIFont systemFontOfSize:g_fitFloat(@[@15,@17])];
    [_lblPrice setAdjustsFontSizeToFitWidth:YES];
    
//    CGFloat priceDiff = _detailInfo.originalPrice.floatValue - _detailInfo.thsPrice.floatValue;
//    NSString *diff    = @" 0";
//    if (priceDiff > 0) {
//        diff = [NSString stringWithFormat:@" %.2f",priceDiff];
//        if ([diff rangeOfString:@".00"].location != NSNotFound) {
//           diff = [diff stringByReplacingOccurrencesOfString:@".00" withString:@""];
//        }
//    }
//    [_btnSavePrice setTitle:diff forState:UIControlStateNormal];
    
    [_btnSavePrice setTitle:_detailInfo.coupon forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPayClick:(id)sender {
    self.btnPay.enabled = NO;
    [self.buttonDelegate SceneBookDetailTabControllerPayButtonClick];
}

- (void)dealloc{
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
