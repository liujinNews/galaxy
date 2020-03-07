//
//  FestivalNavView.h
//  galaxy
//
//  Created by hfk on 2016/12/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FestivalNavView <NSObject>
@optional
- (void)NaLeft;
- (void)NaRight;
@end
@interface FestivalNavView : UIView
@property(nonatomic,weak)id<FestivalNavView>delegate;
@property(nonatomic,strong)UIImageView * headBackView;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)UIColor * color;
@property(nonatomic,strong)NSString * left_bt_Image;
@property(nonatomic,strong)NSString * right_bt_Image;
@property(nonatomic,strong)NSString * head_bg_Image;
@property(nonatomic,assign)BOOL hasRinght;
@property(nonatomic,assign)BOOL hasLeft;
@end
