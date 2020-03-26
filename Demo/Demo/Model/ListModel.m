//
//  ListModel.m
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc": @"description"};
}

@end
