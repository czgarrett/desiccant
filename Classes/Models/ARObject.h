////
////  ARObject.h
////  ZWorkbench
////
////  Created by Christopher Garrett on 6/1/08.
////  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "SQLiteConnectionAdapter.h"
//#import "SQLitePreparedStatement.h"
//
//#define kPrimaryKeyName @"PrimaryKey"
//#define kCreatedAt @"created_at"
//#define kUpdatedAt @"updated_at"
//
//
//// Here's a failed experiment in preprocessor magic.  I'd like to be able to generate getters and setters for active record fields,
//// but it gives compiler warnings.  If you're reading this, and you know how to do it, please let me know!
//
//#define Tokenize(token1, token2) token1 ## token2
//
//#define ARObjectField(camelCaseName, capitalizedName, type) \
//   + (type) camelCaseName; \
//   + (void) Tokenize(set, capitalizedName): (type) value;
//
//#define ARObjectSynthesize(camelCaseName, capitalizedName, columnName, type) \
//   + (type) camelCaseName { return (type) [self getAttributeNamed: [NSString stringWithUTF8String: #columnName]]; } \
//   + (void) Tokenize(set, capitalizedName): (type) value { [self setAttributeNamed: [NSString stringWithUTF8String: #columnName] value: value]; }
//
//@interface ARObject : NSObject {
//	NSMutableDictionary *attributes;
//   NSMutableArray *dateFormatters;
//	BOOL newRecord;
//}
//
//@property(nonatomic, retain) NSMutableDictionary *attributes;
//@property(nonatomic) BOOL newRecord;
//@property(readonly) NSInteger primaryKey;
//
//+ (void) deleteAll;
//+ (NSString *)tableName;
//+ (SQLiteTable *)table;
//+ (SQLiteConnectionAdapter *)connection;
//+ (NSMutableArray *)buildObjectsFromQueryResult: (QueryResult *)queryResult;
//+ (NSString *) primaryKeyName;
//
//+ (NSString *) concatenatedColumnNames;
//- (NSString *) concatenatedColumnNames;
//
//// Finders
//// First parameter is the SQL for a WHERE clause, and subsequent params are bindings to that clause
//+ (NSString *) sqlForFindByCondition: (NSString *)condition;
//+ (NSMutableArray *) usingOperation: (NSOperation *) operation 
//             findByCondition: (NSString *)condition, ...;
//+ (NSMutableArray *) findByCondition: (NSString *)condition, ...;
//+ (ARObject *) findFirstByCondition: (NSString *)condition, ...;
//+ (ARObject *)findByPrimaryKey:(NSInteger)key;
//// First parameter is the SQL for a WHERE clause, and subsequent params are bindings to that clause
//+ (NSMutableArray *) findBySQL: (NSString *)sql, ...;
//+ (NSMutableArray *) findBySQL: (NSString *)sql 
//              variables: (va_list) bindings
//              operation: (NSOperation *)operation;
//+ (NSMutableArray *) findAll;
//+ (void) deleteAllWithCondition: (NSString *)condition, ...;
//+ (ARObject *) findByAttributeNamed: (NSString *)attributeName value: (NSString *) value;
//
//// Column-focused
//+ (NSMutableArray *) usingOperation: (NSOperation *) operation findValuesForColumn: (NSString *)column withCondition: (NSString *)condition, ...;
//
//// Counters
//+ (NSInteger) count;
//+ (NSInteger) countBySQL: (NSString *)sql, ...;
//+ (NSInteger) countBySQL: (NSString *)sql variables: (va_list) bindings;
//+ (NSInteger) countColumn: (NSString *)columnName withFilter: (NSString *)columnFilter;
//
//- (id)initWithAttributes: (NSDictionary *)attributes newRecord:(BOOL)newRecord;
//
//- (SQLiteConnectionAdapter *)connection;
//- (void)create;
//- (void)save;
//- (void)refresh;
//// Deletes all attributes and marks the object as a new record
//- (void)clean;
//- (void)destroy;
//
//- (NSTimeInterval)timeIntervalFromString:(NSString *)xmlString;
//- (NSString *) toXML;
//
//
//- (void)setAttributeNamed:(NSString *)attributeName value:(id)value;
//- (void)setAttributeNamed:(NSString *)attributeName integerValue: (NSInteger) value;
//
//- (NSString *) createdAtAttributeName;
//- (NSString *) updatedAtAttributeName;
//
//- (id)getAttributeNamed:(NSString *)attributeName;
//- (NSInteger)getIntegerAttributeNamed:(NSString *)attributeName;
//- (NSValue *)getValueAttributeNamed:(NSString *)attributeName;
//- (NSNumber *)getNumberAttributeNamed:(NSString *)attributeName;
//- (BOOL)getBooleanAttributeNamed:(NSString *)attributeName;
//- (NSDate *)getDateAttributeNamed:(NSString *)attributeName;
//- (double)getFloatAttributeNamed:(NSString *)attributeName;
//
//- (NSInteger)primaryKey;
//- (NSString *)findByPrimaryKeyStatement;
//- (void)bindAttributesToStatement: (SQLitePreparedStatement *)statement;
//- (NSString *)textFromDatetimeAttribute:(NSString *)attributeName;
//
//// Callbacks
//- (void) beforeCreate;
//- (void) afterCreate;
//- (void) beforeDestroy;
//- (void) afterDestroy;
//
//@end
