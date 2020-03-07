//
//  approvalNoteCell.h
//  galaxy
//
//  Created by hfk on 15/10/30.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "approvalNoteModel.h"
@interface approvalNoteCell : UITableViewCell
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  * resultLabel;
@property (nonatomic,strong)UILabel  * approvalNameLabel;
@property (nonatomic,strong)UILabel  * dataLabel;
@property (nonatomic,strong)UILabel  * opinionLabel;
@property (nonatomic,strong)UIImageView *stateImgView;
@property (nonatomic,strong)UIImageView *stepImgView;
@property (nonatomic,strong)UIImageView *opinionImgView;
@property (nonatomic,strong)UIView *lineView;
-(void)configViewWithModel:(approvalNoteModel *)model withCount:(NSInteger )count withIndex:(NSInteger)index;
+(CGFloat)NoteHeight:(id)object;
@end
