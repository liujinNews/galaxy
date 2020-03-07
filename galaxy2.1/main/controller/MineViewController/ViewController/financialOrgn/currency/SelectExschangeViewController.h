//
//  SelectExschangeViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@protocol SelectExschangeViewControllerDelegate <NSObject>

-(void)SelectExschangeViewControllerCellClick:(NSDictionary *)dic;

@end

@interface SelectExschangeViewController : FlowBaseViewController

@property (nonatomic, strong) NSString *ids;

@property (nonatomic, weak) id<SelectExschangeViewControllerDelegate> delegate;

@end
    
