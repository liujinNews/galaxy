//
//  DiDiImportCell.h
//  galaxy
//
//  Created by hfk on 2018/8/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteDidiModel.h"

@interface DiDiImportCell : UITableViewCell

@property (nonatomic, strong) NSString *choosed;

-(void)configCellWithModel:(RouteDidiModel *)model isEdit:(BOOL)isEdit isChoosed:(NSString *)choosed;

@end
