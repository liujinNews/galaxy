//
//  MulChooseShowCell.h
//  galaxy
//
//  Created by hfk on 2018/8/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProcurementModel.h"

@interface MulChooseShowCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_title;
@property (nonatomic, strong) UITextField *txf_content;
@property (nonatomic, strong) UIImageView *img_select;

-(void)configCellWithModel:(MyProcurementModel *)model WithValue:(NSString *)value WithIndex:(NSIndexPath *)index withStatus:(NSInteger)status;

@end
