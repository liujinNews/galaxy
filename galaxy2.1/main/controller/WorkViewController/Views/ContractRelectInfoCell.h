//
//  ContractRelectInfoCell.h
//  galaxy
//
//  Created by hfk on 2018/6/4.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractRelectInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab_No;
@property (nonatomic, strong) UILabel *lab_Date;
@property (nonatomic, strong) UILabel *lab_Amount;
@property (nonatomic, strong) UIView *line_View;


-(void)configCellWithDict:(NSDictionary *)dict withIndex:(NSInteger)index withTipDict:(NSDictionary *)tipDict;


@end
