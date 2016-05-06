//
//  TextCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "BusinessdetailInfo.h"
@interface TextCell : BaseCell
{
    NSString *tmpString;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)bindata:(BusinessdetailInfo *)baseInfo;
- (CGFloat)cellHeight;
@end
