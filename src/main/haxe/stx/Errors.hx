package stx;

import stx.types.Fault;
import tink.core.Error;

import haxe.CallStack;
import haxe.PosInfos;

import stx.Show;

using stx.Options;
using stx.Eithers;
using stx.Arrays;
using stx.Enums;
using stx.Compose;
using stx.Positions;
using stx.Functions;

class Errors{
  static public function append(e0:Error,e1:Error):Error{
    return Error.withData(
      'error stack',
      switch ([e0.data,e1.data]) {
        case [ErrorStack(errs),ErrorStack(errs0)]   : ErrorStack(errs.append(errs0));
        case [ErrorStack(errs),er]                  : ErrorStack(errs.add(e1));
        case [er,ErrorStack(errs)]                  : ErrorStack([e0].append(errs));
        case [er0,er1]                              : ErrorStack([e0,e1]);
      }
    );
  }
}