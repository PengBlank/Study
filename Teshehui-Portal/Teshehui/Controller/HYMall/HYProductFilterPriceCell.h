//
//  HYProductFilterPriceCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYProductFilterPriceCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *minField;
@property (nonatomic, weak) IBOutlet UITextField *maxField;

@property (nonatomic, assign) CGFloat miniPrice;
@property (nonatomic, assign) CGFloat maxPrice;

@end
