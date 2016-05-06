//
//  PBItemViewCell.h
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargePackagesInfo.h"

@interface PBItemViewCell : UICollectionViewCell

@property (nonatomic, strong) RechargePackagesInfo *rpInfo;

/**Cell刷新UI数据*/
- (void)refreshUIDataWithModel:(RechargePackagesInfo *)rpInfo Index:(NSInteger)index HavePoint:(BOOL)havePoint Type:(NSInteger)type;
/**选中cell 显示勾*/
- (void)pickTheCell:(BOOL)isPick HavePoint:(BOOL)havePoint;

@end
