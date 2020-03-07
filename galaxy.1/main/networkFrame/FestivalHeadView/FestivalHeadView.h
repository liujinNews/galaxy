//
//  FestivalHeadView.h
//  galaxy
//
//  Created by hfk on 2016/12/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FestivalHeadView : NSObject
@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UIView* BgView;
@property (nonatomic,retain) UIImageView* BgimgView;

@property (nonatomic,retain) UIImageView* LeftCloudimg;
@property (nonatomic,retain) UIImageView* RightCloudimg;
//定时器相关
@property (nonatomic,retain) UILabel* showTimeLab;
@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)NSDate *fireDate;
@property (assign, nonatomic) NSUInteger unitFlags;
@property (strong, nonatomic)NSCalendar *calender;
- (void)stretchHeaderForTableView:(UITableView*)tableView;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
@end
