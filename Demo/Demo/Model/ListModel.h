//
//  ListModel.h
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListModel : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *rowImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) double price;


@end

NS_ASSUME_NONNULL_END
