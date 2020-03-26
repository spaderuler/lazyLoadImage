//
//  HttpClient.m
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodPost = 0,
    RequestMethodGet = 1
};

typedef void (^AFSuccess)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void (^AFFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@implementation HttpClient

+ (instancetype)defaultClient {
    static dispatch_once_t onceToken;
    static HttpClient *instance;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)post:(NSString *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers success:(HttpClientRequestSuccess)success failure:(HttpClientRequestFailure)failure {
    [self request:RequestMethodPost
                 url:url
          parameters:parameters
             headers:headers
             success:success
             failure:failure];
}

- (void)request:(RequestMethod)method
            url:(NSString *)url
     parameters:(NSDictionary *)parameters
        headers:(NSDictionary *)headers
        success:(HttpClientRequestSuccess)success
        failure:(HttpClientRequestFailure)failure {
       
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    AFSuccess afSuccess = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    };
    AFFailure afFailure= ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([NSString stringWithFormat:@"%@", @(error.code)], @"网络请求错误");
    };
    
    NSURLSessionDataTask *sessionDataTask;
    if (RequestMethodPost == method) {
        sessionDataTask = [manager POST:url parameters:parameters progress:nil success:afSuccess failure:afFailure];
    }else {
        sessionDataTask = [manager GET:url parameters:parameters progress:nil success:afSuccess failure:afFailure];
    }
}

@end
