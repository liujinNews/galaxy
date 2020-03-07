//
//  BorrowFormCell.h
//  galaxy
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCategoryModel.h"
@interface BorrowFormCell : UITableViewCell

@property (nonatomic,strong)UIView   *mainView;
@property(nonatomic,strong)UIImageView *img_select;
@property(nonatomic,strong)UILabel *lab_title;
@property(nonatomic,strong)UILabel *lab_amount;
@property (nonatomic,strong)UIView *view_line;

- (void)configViewWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray hideLine:(BOOL)hideLine;

@end
