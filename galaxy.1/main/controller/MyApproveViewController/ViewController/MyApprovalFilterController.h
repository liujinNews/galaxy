//
//  MyApprovalFilterController.h
//  galaxy
//
//  Created by hfk on 16/8/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "MyApproveViewCell.h"
#import "PayMentProModel.h"
#import "PayMentProCell.h"
@interface MyApprovalFilterController : FlowBaseViewController

@property(nonatomic,strong)NSDictionary *dict_Parameters;


-(id)initWithType:(NSInteger)type;
@end
