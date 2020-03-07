//
//  MyImageViewController.h
//  MyDemo
//
//  Created by wilderliao on 15/8/24.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol MyImageViewDelegate <NSObject>

- (void)sendImageAction:(UIImage*)image isSendOriPic:(BOOL)bIsOriPic;
- (void)releasePicker;
@end

@interface MyImageViewController : UIViewController{
    UIImage *willShowImage;
    UIImageView *imageView;
    BOOL bIsSendOriPic;
}
@property (nonatomic, weak)id<MyImageViewDelegate> delegate;

- (id)initViewController:(UIImage*)image;

- (UIButton  *)createOriPicRadioBtn;

- (UIButton  *)createSendBtn;

- (IBAction)OnOriPicClick:(id)sender;

- (IBAction)OnSendBtnClick:(id)sender;

- (NSString *)calImageSize;
@end