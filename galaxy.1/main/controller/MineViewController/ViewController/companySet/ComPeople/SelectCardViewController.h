//
//  SelectCardViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/7/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"


typedef void(^SelectCardViewBlock)(NSDictionary *dic);

@interface SelectCardViewController : FlowBaseViewController

-(void)block:(SelectCardViewBlock)block;

@end
