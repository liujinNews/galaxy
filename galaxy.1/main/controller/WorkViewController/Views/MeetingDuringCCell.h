//
//  MeetingDuringCCell.h
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoomModel.h"
@interface MeetingDuringCCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *DuringTimeLabel;

-(void)configCcellWithModel:(MeetingRoomSubModel *)model;

@end
