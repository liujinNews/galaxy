//
//  FormSignInfoCell.m
//  galaxy
//
//  Created by hfk on 2019/2/22.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FormSignInfoCell.h"

@implementation FormSignInfoCell

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configCellWithDict:(NSDictionary *)dict{
    
    NSMutableArray *array = [NSMutableArray array];
    if ([NSString isEqualToNull:dict[@"receiptUserName"]]) {
        [array addObject:dict[@"receiptUserName"]];
    }
    if ([NSString isEqualToNull:dict[@"requestorDept"]]) {
        [array addObject:[NSString stringWithFormat:@"(%@)",dict[@"requestorDept"]]];
    }
    self.name.text = [array componentsJoinedByString:@" "];
    self.time.text = [NSString stringIsExist:dict[@"receiptDate"]];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
