//
//  BaseFormSumView.h
//  galaxy
//
//  Created by hfk on 2019/6/28.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseFormSumView : UIView

/**
 更新表单数据汇总
 
 @param formModel 表单数据
 @param type 汇总来源 1:币种汇总 2:费用类别汇总 3:费用分摊v部门汇总
 */
-(void)updateBaseFormSumViewWithData:(FormBaseModel *)formModel WithType:(NSInteger)type;


@end

NS_ASSUME_NONNULL_END
