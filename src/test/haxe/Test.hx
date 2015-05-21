package;

import stx.Tuple2;

using Lambda;
import utest.Runner;

import stx.ds.Set;
import stx.Sink;

import stx.ifs.Mix;
import stx.ifs.Immix;

import stx.Maps;
import stx.types.*;
import stx.Bools;
import stx.Enums;
import stx.Pairs;
import stx.Maths;
import stx.Tuples;

import stx.Anys;
import stx.Arrays;
import stx.CallStacks;
import stx.Clone;
import stx.Compare;
import stx.Dates;
import stx.Eithers;

import stx.Equal;
import stx.Errors;
import stx.Generator;
import stx.Hasher;
import stx.Iterables;
import stx.Iterators;
import stx.Kind;

import stx.Method;
import stx.Objects;
import stx.Order;

import stx.Plus;
import stx.Positions;
import stx.Reflects;
import stx.Show;
import stx.Strings;
import stx.Stuff;
import stx.Tables;

import stx.Types;
import stx.Upshot;
import stx.ValueTypes;

import stx.Effect;
import stx.Sink;

import stx.macro.WithTest;

class Test{
  static function main(){
    new Test();
  }
  public function new(){
    var runner = new Runner();
    utest.ui.Report.create(runner);
    var arr : Array<Dynamic> = [
      new stx.CallableTest()
    ];
    arr.iter(
      function(x){
        runner.addCase(x);
      }
    );
    runner.run();
  }
}