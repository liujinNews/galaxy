//
//  TravelCarDetailView.h
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelCarDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelCarDetailView : UIView

-(void)updateTravelCarDetailViewWithData:(NSMutableArray *)formData WithEditType:(NSInteger)editType;

@property (nonatomic, copy) void(^TravelCarDetailBackClickedBlock)(NSInteger type, NSInteger index, TravelCarDetail *model);

-(void)updateTableView;

@end

NS_ASSUME_NONNULL_END
