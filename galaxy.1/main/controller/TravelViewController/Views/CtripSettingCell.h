//
//  CtripSettingCell.h
//  galaxy
//
//  Created by hfk on 2017/10/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CtripSettingCell : UITableViewCell
@property (nonatomic,strong)UIView   *mainView;
@property (nonatomic,strong)UIButton *deletBtn;

-(void)configItemWithDict:(NSDictionary *)dict;

@end
