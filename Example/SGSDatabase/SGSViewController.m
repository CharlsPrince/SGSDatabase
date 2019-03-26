//
//  SGSViewController.m
//  SGSDatabase
//
//  Created by Lee on 08/30/2016.
//  Copyright (c) 2016 Lee. All rights reserved.
//

#import "SGSViewController.h"
#import "SGSPerson.h"
#import "SGSDatabaseManager.h"

/// 键值对存储数据库表
static NSString *const kPersonKVTable = @"PersonKVTable";

/// 张三的id
static NSString *const kZSId = @"1001";

/// 李四的id
static NSString *const kLSId = @"1002";

/// 普通的关系型表
static NSString *const kPersonTable = @"PersonTable";


static NSString *const kCreatePersonTableSQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
name TEXT NOT NULL, \
age INTEGER NOT NULL, \
PRIMARY KEY(id)) \
";

static NSString *const kUpdatePersonSQL = @"REPLACE INTO %@ (id, name, age) values (?, ?, ?)";

static NSString *const kSelectPersonSQL = @"SELECT * from %@ where id = ? Limit 1";

@interface SGSViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) SGSDatabaseManager *dbManager;
@property (assign, nonatomic) int zsAge;
@property (assign, nonatomic) int lsAge;
@end

@implementation SGSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
	
    NSString *path = @"~/MyDatabase.sqlite".stringByExpandingTildeInPath;
    _dbManager = [[SGSDatabaseManager alloc] initWithDBWithPath:path];
    
    // 创建键值存储的表
    if (![_dbManager isTableExists:kPersonKVTable]) {
        [_dbManager createTableWithName:kPersonKVTable];
    }

    // 创建关系型的表
    if (![_dbManager isTableExists:kPersonTable]) {
        NSString *sql = [NSString stringWithFormat:kCreatePersonTableSQL, kPersonTable];
        [_dbManager.dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sql];
        }];
    }
}

#pragma mark - 使用键值对存储的功能

// 将对象转为JSON保存到数据库中
- (IBAction)saveJSONObject:(UIButton *)sender {
    SGSPerson *p = [[SGSPerson alloc] initWithIdNum:kZSId name:@"张三" age:@(self.zsAge)];
    id json = p.toJSON;
    
    // 重复存储将会替换原来数据库中的记录
    [_dbManager putObject:json withId:kZSId intoTable:kPersonKVTable];
    
    _textView.text = @"键值对存储完毕";
}

// 从数据库中获取JSON数据
- (IBAction)fetchJSONObject:(UIButton *)sender {
    id json = [_dbManager getObjectById:kZSId fromTable:kPersonKVTable];
    if (json) {
        SGSPerson *p = [[SGSPerson alloc] initWithJSON:json];
        _textView.text = p.description;
    } else {
        _textView.text = @"获取键值对数据失败";
    }
}


#pragma mark - 使用FMDB的功能

// 将对象存入关系型表
- (IBAction)saveObject:(UIButton *)sender {
    SGSPerson *p = [[SGSPerson alloc] initWithIdNum:kLSId name:@"李四" age:@(self.lsAge)];
    
    NSString *sql = [NSString stringWithFormat:kUpdatePersonSQL, kPersonTable];
    __block BOOL success;
    [_dbManager.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql, p.idNum, p.name, p.age];
    }];
    
    if (success) {
        _textView.text = @"关系型存储完毕";
    } else {
        _textView.text = @"关系型存储失败";
    }
}

// 从关系型表中获取数据
- (IBAction)fetchObject:(UIButton *)sender {
    NSString * sql = [NSString stringWithFormat:kSelectPersonSQL, kPersonTable];
    
    __block NSString *idNum = nil;
    __block NSString *name  = nil;
    __block int age         = 0;
    
    [_dbManager.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, kLSId];
        if ([rs next]) {
            idNum = [rs stringForColumn:@"id"];
            name = [rs stringForColumn:@"name"];
            age = [rs intForColumn:@"age"];
        }
        [rs close];
    }];
    
    if (idNum) {
        SGSPerson *p = [[SGSPerson alloc] initWithIdNum:idNum name:name age:@(age)];
        _textView.text = p.description;
    } else {
        _textView.text = @"从关系型表获取记录失败";
    }
}

- (int)zsAge {
    _zsAge++;
    return _zsAge;
}

- (int)lsAge {
    _lsAge++;
    return _lsAge;
}

@end
