//
//  CQSegmentItem.h
//  Teshehui
//
//  Created by ChengQian on 13-10-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ContentDirection
{
    Vertical = 1,
    Horizontal,
}ContentDirection;

/**
 *  segment项目对象，用于存储标题、图象等数据
 */
@interface CQSegmentItem : NSObject

//方向，默认Vertical
@property (nonatomic, assign) ContentDirection dicection;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *hightlightImage;
@property (nonatomic, strong) UIImage *doubleImage;

@end
