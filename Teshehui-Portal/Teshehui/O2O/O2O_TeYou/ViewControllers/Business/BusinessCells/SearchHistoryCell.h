//
//  SearchHistoryCell.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"

@interface SearchHistoryCell : BaseCell
@property (nonatomic,strong) UIImageView    *mainImageV;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UIButton       *clearBtn;
@property (nonatomic,strong) NSString       *currentkey;
@property (nonatomic,copy)void (^clearBtnClick)(NSString *key);
- (void)bindData:(NSString  *)keyword;

@end
