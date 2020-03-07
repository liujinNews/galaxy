//
//  borrowViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "borrowModel.h"

@interface borrowViewCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;

-(void)configBorrowRecordCellInfo:(borrowModel *)cellInfo;

- (void)configEditBorrowRecordCellInfo:(borrowModel*)cellInfo withStatus:(NSString *)status;

-(void)configItsEmployeeRecordsCellInfo:(borrowModel *)cellInfo;

-(void)configBorrowInfoListCellInfo:(borrowModel *)cellInfo;

@end
