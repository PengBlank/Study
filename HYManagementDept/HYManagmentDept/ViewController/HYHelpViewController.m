//
//  HYHelpViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYHelpViewController.h"

@interface HYHelpViewController ()
<MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imgNames;
@property (nonatomic, strong) MWPhoto *curPhoto;
@property (nonatomic, strong) MWPhoto *prePhoto;
@property (nonatomic, strong) MWPhoto *nextPhoto;

@end

@implementation HYHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.delegate = self;
        [self configure];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
    [self loadImage];
    [self reloadData];
}

- (void)configure
{
    self.displayActionButton = NO;
    self.displayNavArrows = YES;
    self.displaySelectionButtons = NO;
    self.alwaysShowControls = NO;
    self.wantsFullScreenLayout = YES;
    self.zoomPhotosToFill = NO;
    self.enableGrid = NO;
    self.startOnGrid = NO;
    self.enableSwipeToDismiss = NO;
}

- (void)loadImage
{
    if (_type >= 0 && _type < 4)
    {
        NSInteger imgCount = 0;
        switch (_type) {
            case 0:
                imgCount = 16;
                break;
            case 1:
                imgCount = 6;
                break;
            case 2:
                imgCount = 3;
                break;
            case 3:
                imgCount = 4;
                break;
            default:
                break;
        }
        if (imgCount > 0)
        {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < imgCount; i++)
            {
                NSString *imgName = [NSString stringWithFormat:@"help_%ld_%ld", (long)_type, (long)i];
                [array addObject:imgName];
            }
            self.imgNames = [NSArray arrayWithArray:array];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _imgNames.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _imgNames.count)
    {
        NSString *imgName = [_imgNames objectAtIndex:index];
        NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgPath];
        MWPhoto *photo = [[MWPhoto alloc] initWithImage:img];
        return photo;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
