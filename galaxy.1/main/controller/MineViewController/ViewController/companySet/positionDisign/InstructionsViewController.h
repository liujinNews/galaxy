//
//  InstructionsViewController.h
//  galaxy
//
//  Created by hfk on 2017/2/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewCell.h"
@interface InstructionsViewController : RootViewController
@property(nonatomic,strong)InfoViewCell *cell;
-(id)initWithType:(NSString *)type;
@end
