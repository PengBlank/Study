//
//  PhotoBrowserDelegate.m
//  NewMom
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "PhotoBrowserDelegate.h"

@implementation PhotoBrowserDelegate

- (instancetype)init
{
    if (self = [super init])
    {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (MWPhotoBrowser *)createBrowser
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
//    if (IOS_VERSION < 7)
//    {
//        browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
//    }

    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:1];
    
    return browser;
}

- (void)setPhotoURLs:(NSArray *)photoURLs
{
    if (_photoURLs != photoURLs)
    {
        _photoURLs = photoURLs;
        [_photos removeAllObjects];
        
        for (NSString *photoStr in photoURLs)
        {
            NSURL *url = [NSURL URLWithString:photoStr];
            MWPhoto *photo = [MWPhoto photoWithURL:url];
            [_photos addObject:photo];
        }
    }
}

- (void)setImages:(NSArray *)images
{
    if (_images != images)
    {
        _images = images;
        [_photos removeAllObjects];
        
        for (id imgobj in images)
        {
            MWPhoto *photo;
            if ([imgobj isKindOfClass:[UIImage class]])
            {
                photo = [MWPhoto photoWithImage:imgobj];
            }
            if (photo)
            {
                [_photos addObject:photo];
            }
        }
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [_photos objectAtIndex:index];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deleteButtonPressedForPhotoAtIndex:(NSUInteger)index
{
    if (_photos.count == 1)
    {
        [photoBrowser.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSInteger target = index;
        if (target > 0)
        {
            target = target - 1;
        }
        [photoBrowser setCurrentPhotoIndex:target];
    }
    
    [_photos removeObjectAtIndex:index];
    [photoBrowser reloadData];
    
    if (self.deleteCallback)
    {
        self.deleteCallback(index);
    }
}

@end
