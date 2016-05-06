//
//  CommonPayController.h
//  Teshehui
//
//  Created by apple_administrator on 16/3/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "BusinessdetailInfo.h"
@interface CommonPayController : HYMallViewBaseController{

}
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong) NSMutableArray *disCount;
@property (nonatomic,strong) NSMutableArray *disCountTitle;
@property (nonatomic,strong) BusinessdetailInfo *bdInfo;
@end
