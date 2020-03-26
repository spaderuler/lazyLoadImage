//
//  ListCell.m
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import "ListCell.h"
#import "DemoConst.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img.layer.cornerRadius = 8;
    self.img.layer.masksToBounds = YES;
    self.img.contentMode = UIViewContentModeScaleAspectFit;
    self.img.backgroundColor = [UIColor lightGrayColor];
    
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.desLabel.textColor = [UIColor grayColor];
    self.desLabel.font = [UIFont systemFontOfSize:13];
    self.desLabel.textAlignment = NSTextAlignmentLeft;
    
    self.priceLabel.textColor = [UIColor blackColor];
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat width = (kWidth - 2*outerMargin - innerMargin)/2;
    self.bgHeightConstranit.constant =  width * 4/3;
    self.imgHeightConstraint.constant = self.bgHeightConstranit.constant - 50;
}


@end
