//
//  KiiClause.h
//  KiiSDK-Private
//
//  Created by Chris Beauchamp on 7/23/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Build a query using one or more KiiClause methods
 */
@interface KiiClause : NSObject 

/** Create a KiiClause with the AND operator concatenating multiple KiiClause objects
 @param clause A nil-terminated list of KiiClause objects to concatenate
 */
+ (KiiClause*) and:(KiiClause*)clause, ...;

/** Create a KiiClause with the OR operator concatenating multiple KiiClause objects
 @param clause A nil-terminated list of KiiClause objects to concatenate
 */
+ (KiiClause*) or:(KiiClause*)clause, ...;

/** Create an expression of the form key = value
 @param key The key to compare
 @param value The value to compare
 */
+ (KiiClause*)equals:(NSString*)key value:(id)value; 

/** Create an expression of the form key > value
 @param key The key to compare
 @param value The value to compare
 */
+ (KiiClause*)greaterThan:(NSString*)key value:(id)value; 

/** Create an expression of the form key >= value
 @param key The key to compare
 @param value The value to compare
 */
+ (KiiClause*)greaterThanOrEqual:(NSString*)key value:(id)value; 

/** Create an expression of the form key < value
 @param key The key to compare
 @param value The value to compare
 */
+ (KiiClause*)lessThan:(NSString*)key value:(id)value; 

/** Create an expression of the form key <= value
 @param key The key to compare
 @param value The value to compare
 */
+ (KiiClause*)lessThanOrEqual:(NSString*)key value:(id)value; 

/** Create an expression of the form key in [ values[0], values[1], ... ]
 @param key The key to compare
 @param values The values to compare
 */
+ (KiiClause*)in:(NSString*)key value:(NSArray*)values; 

/** Create an expression of the form key != value
 @param key The key to compare
 @param value The value to compare
 */
+ (KiiClause*)notEquals:(NSString*)key value:(id)value; 

/** Create an expression of the form key STARTS WITH value
 @param key The key to compare
 @param value The value to check for
 */
+ (KiiClause*)startsWith:(NSString*)key value:(NSString*)value;

/** Create a KiiClause with the AND operator concatenating multiple KiiClause objects
 @param clauses An array KiiClause objects to concatenate
 @return KiiClause instance with concatenated AND operator,or nil if array contains any non KiiClause instance
 */
+(KiiClause*) andClauses:(NSArray*) clauses;

/** Create a KiiClause with the OR operator concatenating multiple KiiClause objects
 @param clauses An array KiiClause objects to concatenate
 
 @return KiiClause instance with concatenated OR operator,or nil if array contains any non KiiClause instance
 */
+(KiiClause*) orClauses:(NSArray*) clauses;
@end
