//
//  MeetingDuringView.h
//  galaxy
//
//  Created by hfk on 2017/12/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MeetingDuringView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger type;

-(void)configMeetingDuringViewData:(NSMutableArray *)dataArray WithType:(NSInteger)type;
@end
