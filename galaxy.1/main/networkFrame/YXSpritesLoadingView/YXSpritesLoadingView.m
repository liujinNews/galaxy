//
//  YXSpritesLoadingView.h
//  Gogobot-iOS
//
//  Created by Yin Xu on 05/14/14.
//  Copyright (c) 2014 Yin Xu. All rights reserved.
//

#import "YXSpritesLoadingView.h"
#import "FBShimmering/FBShimmeringView.h"

@implementation YXSpritesLoadingView
{
    UIView *loaderView;
    UIImageView *loadingImageView;
    FBShimmeringView *shimmeringView;
    UILabel *loadingLabel;
    UIWindow *window;
    int adjustHeightForLoader; //when we set shouldBlockCurrentViewUserIntercation to YES
                               //we leave 64 pixel on the top of the screen for the nav bar
                               //so we need adjust the center point of loader
    
}

#pragma mark - Class Methods
+ (YXSpritesLoadingView *)sharedInstance
{
	static dispatch_once_t once = 0;
	static YXSpritesLoadingView *sharedInstance;
	dispatch_once(&once, ^{
        sharedInstance = [[YXSpritesLoadingView alloc] init];
    });
	return sharedInstance;
}

+ (void)show
{
	[[self sharedInstance] loadingViewSetupWithText:nil andShimmering:YES andBlur:YES];
}

+ (void)showWithText:(NSString *)text
{
    [[self sharedInstance] loadingViewSetupWithText:text andShimmering:YES andBlur:YES];

}

+ (void)showWithText:(NSString *)text andShimmering:(BOOL)shimmering andBlurEffect:(BOOL)blur
{
    [[self sharedInstance] loadingViewSetupWithText:text andShimmering:shimmering andBlur:blur];
}

+ (void)dismiss
{
    [[self sharedInstance] loadingViewHide];
}


#pragma mark - Initialization Methods
- (id)init{
    self = [super initWithFrame: [UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor clearColor];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    window = [delegate respondsToSelector:@selector(window)] ? [delegate performSelector:@selector(window)] : [[UIApplication sharedApplication] keyWindow];
    self.alpha = 0;
    return self;
}

#pragma mark - Helper Methods
- (void)loadingViewSetupWithText:(NSString *)text andShimmering:(BOOL)shimmering andBlur:(BOOL)blur
{
    if (!loadingImageView)
    {
        loaderView = [[UIView alloc]init];
        int height = 0;
        if (text && ![text isEqualToString:@""]) {
            height = [self getTextHeight:text andFont:[UIFont fontWithName:loadingTextFontName size:loadingTextFontSize] andWidth:loaderBackgroundWidth - (loadingTextLabelSideMargin * 2)] + 1;
            if ([text isEqualToString:@"手指上滑，取消发送"]||[text isEqualToString:@"松开手指，取消发送"]) {
                loaderView.frame = CGRectMake(Main_Screen_Width/2-90, Main_Screen_Height/2-90,180,180);
                loaderView.layer.cornerRadius = 20;
                loaderView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
            }else{
                loaderView.frame = CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height);
                loaderView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 135, 120)];
                view.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2);
                view.layer.cornerRadius =10.0f;
                view.backgroundColor=[UIColor whiteColor];
                [loaderView addSubview:view];
            }
            if (shimmering) {
                shimmeringView = [[FBShimmeringView alloc] init];
                shimmeringView.frame = CGRectMake(0,0,100,20);
                shimmeringView.center=CGPointMake(Main_Screen_Width/2+5, Main_Screen_Height/2+50);
                shimmeringView.shimmeringOpacity = 0.1;
                shimmeringView.shimmeringSpeed = 90;
                shimmeringView.shimmeringHighlightWidth = 1.2;
                loadingLabel = [[UILabel alloc]initWithFrame:shimmeringView.bounds];
                shimmeringView.contentView = loadingLabel;
                [loaderView addSubview:shimmeringView];
                shimmeringView.shimmering = YES;
            }else{
                if ([text isEqualToString:@"手指上滑，取消发送"]||[text isEqualToString:@"松开手指，取消发送"]) {
                    loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,150,140,20)];
                    loadingLabel.font = Font_Important_15_20;
                    loadingLabel.textAlignment = NSTextAlignmentCenter;
                    loadingLabel.text = text;
                    loadingLabel.textColor = Color_form_TextFieldBackgroundColor;
                    loadingLabel.numberOfLines = 0;
                }else{
//                    loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
//                    loadingLabel.center=CGPointMake(Main_Screen_Width/2+5, Main_Screen_Height/2+50);
//                    loadingLabel.font = [UIFont systemFontOfSize:loadingTextFontSize];
//                    loadingLabel.textAlignment = NSTextAlignmentCenter;
//                    loadingLabel.text = text;
//                    loadingLabel.textColor =Color_WhiteWeak_Same_20;
//                    loadingLabel.numberOfLines = 0;
                    loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                }
                [loaderView addSubview:loadingLabel];
            }
        }else{
            loaderView.frame = CGRectMake((self.frame.size.width - loaderBackgroundWidth) / 2, (self.frame.size.height - loaderBackgroundWidth) / 2 - adjustHeightForLoader, loaderBackgroundWidth, loaderBackgroundWidth);
        }
        
        
        
        loadingImageView = [[UIImageView alloc] init];
        CGRect frame = loadingImageView.frame;
        frame.size.width = animationImageWidth;
        frame.size.height = animationImageHeight;
        frame.origin.x = (loaderView.frame.size.width - animationImageWidth) / 2;
        frame.origin.y = (loaderView.frame.size.height - animationImageHeight - height) / 2;
        
        loadingImageView.frame = frame;
        if ([text isEqualToString:Custing(@"光速加载中...",nil) ]) {
             loadingImageView.contentMode = UIViewContentModeScaleAspectFit;
            frame.size.width = 100;
            frame.size.height = 94;
            frame.origin.x = (loaderView.frame.size.width - 100) / 2;
            frame.origin.y = (loaderView.frame.size.height - 94) / 2;
            loadingImageView.frame = frame;
        }else{
            loadingImageView.contentMode=UIViewContentModeCenter;
        }
       
        
        loadingImageView.layer.zPosition = MAXFLOAT;
        
        if ([text isEqualToString:@"手指上滑，取消发送"]||[text isEqualToString:@"松开手指，取消发送"]) {
            if ([text isEqualToString:@"手指上滑，取消发送"]) {
                NSMutableArray *retVal = [[NSMutableArray alloc]initWithCapacity:3];
                [retVal addObject:[UIImage imageNamed:@"Message_Audio_01"]];
                [retVal addObject:[UIImage imageNamed:@"Message_Audio_02"]];
                [retVal addObject:[UIImage imageNamed:@"Message_Audio_03"]];
                loadingImageView.animationImages = retVal;
                loadingImageView.animationDuration = cycleAnimationDuration;
            }else{
                loadingImageView.image = [UIImage imageNamed:@"Message_Cancel"];
            }
        }else{
            loadingImageView.animationImages = [self imagesForAnimating];
            loadingImageView.animationDuration = cycleAnimationDuration;
        }
        [loaderView addSubview:loadingImageView];
        
        if (blur) {
            UIToolbar *blurView = [[UIToolbar alloc]initWithFrame:loaderView.bounds];
            [blurView setTintColor:[UIColor clearColor]];
            [loaderView insertSubview:blurView atIndex:0];
            blurView.translucent = YES;
            blurView.layer.cornerRadius = loaderCornerRadius;
            blurView.layer.masksToBounds = YES;
        }
        [loadingImageView startAnimating];
    }else{
        if ([text isEqualToString:@"手指上滑，取消发送"]||[text isEqualToString:@"松开手指，取消发送"]) {
            if ([text isEqualToString:@"手指上滑，取消发送"]) {
                NSMutableArray *retVal = [NSMutableArray array];
                for(int i = 1; i < 4; i++)
                {
                    [retVal addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Message_Audio_0%d", i]]];
                }
                loadingLabel.text = text;
                loadingImageView.animationImages = retVal;
                loadingImageView.animationDuration = cycleAnimationDuration;
                [loadingImageView startAnimating];
            }else{
                NSMutableArray *retVal = [NSMutableArray array];
                for(int i = 1; i < 4; i++)
                {
                    [retVal addObject:[UIImage imageNamed:@"Message_Cancel"]];
                }
//                loadingLabel.text = @"";
                loadingImageView.animationImages = retVal;
                loadingImageView.animationDuration = cycleAnimationDuration;
                [loadingImageView startAnimating];
            }
        }
    }
    
    if (loaderView.superview == nil)
    {
        [window addSubview:loaderView];
    }
    
    loaderView.alpha = 0;
    loaderView.transform = CGAffineTransformScale(loaderView.transform, 1.5, 1.5);
    
    if ([text isEqualToString:@"手指上滑，取消发送"]||[text isEqualToString:@"松开手指，取消发送"]) {
        loaderView.alpha = 1;
        loaderView.transform = CGAffineTransformIdentity;
        self.alpha=1;
    }else{
            loaderView.alpha = 1;
            loaderView.transform = CGAffineTransformIdentity;
            self.alpha=1;
    }
}

- (void)loadingViewHide
{
    if (self.alpha == 1)
	{
//        [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
////            loaderView.transform = CGAffineTransformScale(loaderView.transform, 1.5, 1.5);
//            loaderView.alpha = 0;
//        } completion:^(BOOL finished) {
//             self.alpha = 0;
//            [loadingImageView removeFromSuperview];
//            [loadingImageView stopAnimating];
//            loadingImageView = nil;
//
//            [loadingLabel removeFromSuperview];
//            loadingLabel = nil;
//
//            [shimmeringView removeFromSuperview];
//            shimmeringView = nil;
//
//            [loaderView removeFromSuperview];
//            loaderView = nil;
//
//            self.alpha = 0;
//        }];
        [loadingImageView removeFromSuperview];
        [loadingImageView stopAnimating];
        loadingImageView = nil;
        [loadingLabel removeFromSuperview];
        loadingLabel = nil;
        [shimmeringView removeFromSuperview];
        shimmeringView = nil;
        [loaderView removeFromSuperview];
        loaderView = nil;
        self.alpha = 0;
	}
}

- (NSArray *)imagesForAnimating
{
    NSMutableArray *retVal = [NSMutableArray array];

    for(int i = 0; i <numberOfFramesInAnimation; i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",spriteNameString,i]];
        [retVal addObject:image];
    }
    return retVal;
}

- (int)getTextHeight:(NSString*)text andFont: (UIFont *)font andWidth:(float)width {
    CGSize constrain = CGSizeMake(width, 1000000);
    return [text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:Nil].size.height;
}


@end
