//
//  PBCollectionHeaderView.h
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrepayPBInfo.h"

@interface PBCollectionHeaderView : UICollectionReusableView

/**HeaderView刷新UI数据*/
- (void)refreshUIDataWithModel:(PrepayPBInfo *)Info;

@end
