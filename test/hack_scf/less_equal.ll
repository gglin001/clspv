; RUN: clspv-opt -SignedCompareFixupPass -hack-scf %s -o %t.ll
; RUN: FileCheck %s < %t.ll

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define i1 @less_equal(i32 %x, i32 %y) {
entry:
  %cmp = icmp sle i32 %x, %y
  ret i1 %cmp
}

; CHECK: [[sub:%[a-zA-Z0-9_.]+]] = sub i32 %y, %x
; CHECK: [[and:%[a-zA-Z0-9_.]+]] = and i32 [[sub]], -2147483648
; CHECK: [[cmp:%[a-zA-Z0-9_.]+]] = icmp eq i32 [[and]], 0
; CHECK: ret i1 [[cmp]]

