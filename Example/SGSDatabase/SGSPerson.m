//
//  SGSPerson.m
//  SGSDatabase
//
//  Created by Lee on 16/8/30.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "SGSPerson.h"

static NSString * const kIdNum = @"idNum";
static NSString * const kName  = @"name";
static NSString * const kAge   = @"age";

@implementation SGSPerson

- (instancetype)initWithIdNum:(NSString *)idNum name:(NSString *)name age:(NSNumber *)age {
    self = [super init];
    if (self) {
        _idNum = idNum.copy;
        _name  = name.copy;
        _age   = age;
    }
    return self;
}

- (instancetype)initWithJSON:(id)json {
    if (![NSJSONSerialization isValidJSONObject:json]) return nil;
    
    NSDictionary *dict = (NSDictionary *)json;
    id idNum = dict[kIdNum];
    id name  = dict[kName];
    id age   = dict[kAge];
    
    return [self initWithIdNum:idNum name:name age:age];
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    if (_idNum) result[kIdNum] = _idNum;
    if (_name)  result[kName]  = _name;
    if (_age)   result[kAge]   = _age;
    
    return result.copy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<SGSPerson: %p> idNum = %@, name = %@, age = %@", self, _idNum, _name, _age];
}

@end
