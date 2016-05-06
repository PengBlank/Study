//
//  HYImageUtilGetter.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYImageUtilGetter.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HYImageUtilGetter ()
<UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@end

@implementation HYImageUtilGetter

+ (instancetype)sharedImageGetter
{
    static HYImageUtilGetter *__getter = nil;
    if (!__getter)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __getter = [[HYImageUtilGetter alloc] init];
        });
    }
    return __getter;
}

- (void)getImageInView:(UIView *)view callback:(void (^)(UIImage *))callback
{
    if (callback)
    {
        self.callback = callback;
    }
    UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"选取照片", @"拍照", nil];
    act.tag = 200;
    [act showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        if (buttonIndex == 1)
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请在“设置-隐私-照片”选项中允许特奢汇访问你的相机。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"相机不可用"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else if (buttonIndex == 2)
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:picker animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (self.callback)
        {
            self.callback(image);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
