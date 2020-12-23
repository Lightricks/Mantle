// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

#import <Mantle/Mantle.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "MTLModel+Difference.h"
#import "MTLTestModel.h"

QuickSpecBegin(MTLModelDifferenceSpec)

it(@"should raise on mismatching argument type", ^{
  MTLTestModel *model = [[MTLTestModel alloc] init];
  NSAssert(model, @"model must be non nil");
  expect([model differenceFrom:@1]).to(raiseException());
});

it(@"should compute different fields", ^{
  NSDictionary *values1 = @{
    @"name": @"foo",
    @"count": @(4),
  };

  NSError *error = nil;
  MTLTestModel *model1 = [[MTLTestModel alloc] initWithDictionary:values1 error:&error];
  NSAssert(model1, @"model1 must be non nil");

  NSDictionary *values2 = @{
    @"count": @(5),
    @"nestedName": @"moo",
  };

  MTLTestModel *model2 = [[MTLTestModel alloc] initWithDictionary:values2 error:&error];
  NSArray *difference = [model1 differenceFrom:model2];
  expect(difference).to(equal(@[
    @"count:",
    @"|\tExpected: 4",
    @"|\tActual\t: 5",
    @"name:",
    @"|\tExpected: foo",
    @"|\tActual\t: (null)",
    @"nestedName:",
    @"|\tExpected: (null)",
    @"|\tActual\t: moo"
  ]));
});

it(@"should compute different fields of sub-object", ^{
  NSError *error = nil;
  MTLTestModel *submodel1 = [[MTLTestModel alloc] initWithDictionary:@{ @"name": @"foo" }
                                                               error:&error];
  NSAssert(!error, @"error must be nil");
  MTLTestModel *submodel2 = [[MTLTestModel alloc] initWithDictionary:@{ @"name": @"moo" }
                                                               error:&error];
  NSAssert(!error, @"error must be nil");

  MTLTestModel *model1 = [[MTLTestModel alloc] initWithDictionary:@{ @"weakModel": submodel1 }
                                                            error:&error];
  NSAssert(!error, @"error must be nil");

  MTLTestModel *model2 = [[MTLTestModel alloc] initWithDictionary:@{ @"weakModel": submodel2 }
                                                            error:&error];
  NSAssert(!error, @"error must be nil");

  NSArray *difference = [model1 differenceFrom:model2];
  expect(difference).to(equal(@[
    @"weakModel:",
    @"|\tname:",
    @"|\t|\tExpected: foo",
    @"|\t|\tActual\t: moo"
  ]));
});

QuickSpecEnd
