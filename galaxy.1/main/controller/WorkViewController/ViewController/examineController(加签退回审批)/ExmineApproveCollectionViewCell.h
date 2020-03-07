//
//  ExmineApproveCollectionViewCell.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExmineApproveModel.h"

typedef void(^ExmineApproveBlock)(void);

@interface ExmineApproveCollectionViewCell : UICollectionViewCell

-(void)initWithModel:(ExmineApproveModel *)model block:(ExmineApproveBlock)block;

@end
