//
//  HttpClient.h
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HttpClientRequestFailure)(NSString *error, NSString *errorMessage);
typedef void(^HttpClientRequestSuccess)(id responseObject);

@interface HttpClient : NSObject

+ (instancetype)defaultClient;

//post
- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     headers:(NSDictionary *)headers
     success:(HttpClientRequestSuccess)success
     failure:(HttpClientRequestFailure)failure;

@end

NS_ASSUME_NONNULL_END
