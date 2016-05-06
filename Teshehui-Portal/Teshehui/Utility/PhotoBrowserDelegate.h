//
//  PhotoBrowserDelegate.h
//  NewMom
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"

@interface PhotoBrowserDelegate : NSObject
<MWPhotoBrowserDelegate>
{
    NSMutableArray *_photos;
}
@property (nonatomic, strong) NSArray *photoURLs;
@property (nonatomic, strong) NSArray *images;

- (MWPhotoBrowser *)createBrowser;

@property (nonatomic, copy) void (^deleteCallback)(NSInteger idx);

@end
