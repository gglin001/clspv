; RUN: clspv-opt %s -o %t -ReplacePointerBitcast
; RUN: FileCheck %s < %t

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

; CHECK: [[shl:%[a-zA-Z0-9_.]+]] = shl i32 %i, 1
; CHECK: [[cast:%[a-zA-Z0-9_.]+]] = bitcast <2 x float> %0 to <2 x i32>
; CHECK: [[ex0:%[a-zA-Z0-9_.]+]] = extractelement <2 x i32> [[cast]], i32 0
; CHECK: [[ex1:%[a-zA-Z0-9_.]+]] = extractelement <2 x i32> [[cast]], i32 1
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr i32, i32 addrspace(1)* %a, i32 [[shl]]
; CHECK: store i32 [[ex0]], i32 addrspace(1)* [[gep]]
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[shl]], 1
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr i32, i32 addrspace(1)* %a, i32 [[add]]
; CHECK: store i32 [[ex1]], i32 addrspace(1)* [[gep]]
define spir_kernel void @foo(i32 addrspace(1)* %a, <2 x float> addrspace(1)* %b, i32 %i) {
entry:
  %0 = load <2 x float>, <2 x float> addrspace(1)* %b, align 8
  %1 = bitcast i32 addrspace(1)* %a to <2 x float> addrspace(1)*
  %arrayidx = getelementptr inbounds <2 x float>, <2 x float> addrspace(1)* %1, i32 %i
  store <2 x float> %0, <2 x float> addrspace(1)* %arrayidx, align 8
  ret void
}

