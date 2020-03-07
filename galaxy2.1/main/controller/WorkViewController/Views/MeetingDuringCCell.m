
//
//  MeetingDuringCCell.m
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MeetingDuringCCell.h"

@implementation MeetingDuringCCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpContentView];
    }
    return self;
}
-(void)setUpContentView{
    UIView *superView = self.contentView;
    
    if (!self.DuringTimeLabel) {
        self.DuringTimeLabel=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        [superView addSubview:self.DuringTimeLabel];
    }
}

-(void)configCcellWithModel:(MeetingRoomSubModel *)model{
    self.DuringTimeLabel.frame=CGRectMake(0, 0, Main_Screen_Width/3, 26);
    self.DuringTimeLabel.text=[NSString stringWithFormat:@"%@ ~ %@",model.startTimeStr,model.endTimeStr];
}

@end
