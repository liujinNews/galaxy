//
//  InfoViewCell.h
//  galaxy
//
//  Created by hfk on 2017/2/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *NoImageView;
@property (nonatomic,strong)UILabel  * titleLabel;
@property (nonatomic,strong)UILabel  * InfoLabel;
-(void)configViewInfoWithDict:(NSDictionary *)dict withIndex:(NSIndexPath*)index;
@end
