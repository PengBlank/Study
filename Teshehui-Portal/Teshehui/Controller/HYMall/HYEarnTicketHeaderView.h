//
//  HYEarnTicketHeaderView.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"

@interface HYEarnTicketHeaderView : UIView
<MDHTMLLabelDelegate>
{
    MDHTMLLabel *_content;
}

@property (nonatomic, copy) void (^didClickUpdate)(void);

@end
