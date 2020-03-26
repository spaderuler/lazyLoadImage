//
//  UICollectionViewCell+Register.m
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import "UICollectionViewCell+Register.h"

@implementation UICollectionViewCell (Register)

+(void)registeredByCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:[self identifier] bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[self identifier]];
}

+(NSString *)identifier {
    return NSStringFromClass([self class]);
}

@end
