//
//  SGSPerson.h
//  SGSDatabase
//
//  Created by Lee on 16/8/30.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGSPerson : NSObject

@property (nonatomic, copy  ) NSString *idNum;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, strong) NSNumber *age;

- (NSDictionary *)toJSON;

- (instancetype)initWithIdNum:(NSString *)idNum name:(NSString *)name age:(NSNumber *)age;
- (instancetype)initWithJSON:(id)json;

@end
